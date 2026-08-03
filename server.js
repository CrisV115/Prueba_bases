const express = require('express');
const { Pool } = require('pg');
const path = require('path');

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname)));

// Configuración de la conexión a PostgreSQL para Natural
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'natural_f',
  password: process.env.DB_PASSWORD || '1234',
  port: Number(process.env.DB_PORT || 5432),
});

app.get('/api/health', async (req, res) => {
  try {
    const result = await pool.query('SELECT current_database() AS database_name, current_user AS database_user');
    res.json({ ok: true, ...result.rows[0] });
  } catch (error) {
    console.error('Error al verificar la conexión a PostgreSQL:', error);
    res.status(500).json({ ok: false, error: 'No se pudo conectar a la base de datos de Natural.' });
  }
});

// Endpoint: Autenticación de Usuario (Login)
app.post('/api/login', async (req, res) => {
  const { usuario, clave, sucursal } = req.body;

  if (!usuario || !clave || !sucursal) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }

  try {
    const query = `
      SELECT u.id_usuario, u.perfil, e.nombres, e.apellidos, e.id_sucursal, s.nombre AS nombre_sucursal
      FROM usuario u
      JOIN empleado e ON u.id_usuario = e.id_empleado
      JOIN sucursal s ON e.id_sucursal = s.id_sucursal
      WHERE (e.nombres ILIKE $1 OR CAST(u.id_usuario AS VARCHAR) = $1)
        AND u.clave = $2
        AND (s.nombre ILIKE $3 OR CAST(s.id_sucursal AS VARCHAR) = $3);
    `;

    const result = await pool.query(query, [usuario.trim(), clave.trim(), sucursal.trim()]);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas o sucursal incorrecta.' });
    }

    const user = result.rows[0];
    res.json({
      success: true,
      message: 'Inicio de sesión exitoso',
      user: {
        id: user.id_usuario,
        nombres: user.nombres,
        apellidos: user.apellidos,
        perfil: user.perfil,
        id_sucursal: user.id_sucursal,
        nombre_sucursal: user.nombre_sucursal
      }
    });
  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Endpoint: Obtener lista de productos
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT codigo_barras, nombre, precio_unitario FROM producto ORDER BY nombre;');
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener productos:', error);
    res.status(500).json({ error: 'Error al obtener productos.' });
  }
});

// Endpoint: Obtener lista de sucursales
app.get('/api/branches', async (req, res) => {
  try {
    const result = await pool.query('SELECT id_sucursal, nombre FROM sucursal ORDER BY nombre;');
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener sucursales:', error);
    res.status(500).json({ error: 'Error al obtener sucursales.' });
  }
});

// Endpoint: Consultar stock de un producto en una sucursal
app.get('/api/stock', async (req, res) => {
  const { product_code, branch_id } = req.query;

  if (!product_code || !branch_id) {
    return res.status(400).json({ error: 'Faltan parámetros requeridos.' });
  }

  try {
    const query = 'SELECT stock FROM inventario WHERE id_sucursal = $1 AND codigo_barras = $2;';
    const result = await pool.query(query, [branch_id, product_code]);

    const stock = result.rows.length > 0 ? result.rows[0].stock : 0;
    res.json({ stock });
  } catch (error) {
    console.error('Error al consultar stock:', error);
    res.status(500).json({ error: 'Error al consultar stock.' });
  }
});

// Endpoint: Registrar transferencia y actualizar inventario (con transacciones)
app.post('/api/transfer', async (req, res) => {
  const { product_code, source_branch, dest_branch, quantity } = req.body;
  const qty = parseInt(quantity, 10);

  if (!product_code || !source_branch || !dest_branch || isNaN(qty) || qty <= 0) {
    return res.status(400).json({ error: 'Datos de transferencia inválidos.' });
  }

  if (parseInt(source_branch, 10) === parseInt(dest_branch, 10)) {
    return res.status(400).json({ error: 'La sucursal de destino debe ser diferente a la de origen.' });
  }

  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    // 1. Verificar stock en origen
    const stockQuery = 'SELECT stock FROM inventario WHERE id_sucursal = $1 AND codigo_barras = $2 FOR UPDATE;';
    const stockRes = await client.query(stockQuery, [source_branch, product_code]);
    const sourceStock = stockRes.rows.length > 0 ? stockRes.rows[0].stock : 0;

    if (sourceStock < qty) {
      await client.query('ROLLBACK');
      return res.status(400).json({ error: `Stock insuficiente en la sucursal de origen. Stock disponible: ${sourceStock}` });
    }

    // 2. Descontar stock del origen
    const updateSourceQuery = 'UPDATE inventario SET stock = stock - $1 WHERE id_sucursal = $2 AND codigo_barras = $3;';
    await client.query(updateSourceQuery, [qty, source_branch, product_code]);

    // 3. Incrementar stock en destino (o insertar si no existe)
    const destStockQuery = 'SELECT id_inventario, stock FROM inventario WHERE id_sucursal = $1 AND codigo_barras = $2 FOR UPDATE;';
    const destStockRes = await client.query(destStockQuery, [dest_branch, product_code]);

    if (destStockRes.rows.length > 0) {
      const updateDestQuery = 'UPDATE inventario SET stock = stock + $1 WHERE id_sucursal = $2 AND codigo_barras = $3;';
      await client.query(updateDestQuery, [qty, dest_branch, product_code]);
    } else {
      const insertDestQuery = 'INSERT INTO inventario (id_sucursal, codigo_barras, stock) VALUES ($1, $2, $3);';
      await client.query(insertDestQuery, [dest_branch, product_code, qty]);
    }

    // 4. Crear registro en la tabla transferencia (id_estado = 1: Solicitada)
    const insertTransferQuery = `
      INSERT INTO transferencia (sucursal_origen, sucursal_destino, id_estado, fecha_transferencia)
      VALUES ($1, $2, 1, NOW()) RETURNING id_transferencia;
    `;
    const transferRes = await client.query(insertTransferQuery, [source_branch, dest_branch]);
    const id_transferencia = transferRes.rows[0].id_transferencia;

    // 5. Crear detalle de la transferencia
    const insertDetailQuery = `
      INSERT INTO detalle_transferencia (id_transferencia, codigo_barras, cantidad)
      VALUES ($1, $2, $3);
    `;
    await client.query(insertDetailQuery, [id_transferencia, product_code, qty]);

    await client.query('COMMIT');
    res.json({
      success: true,
      message: 'Transferencia registrada exitosamente.',
      id_transferencia
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error al realizar transferencia:', error);
    res.status(500).json({ error: 'Ocurrió un error al procesar la transferencia en la base de datos.' });
  } finally {
    client.release();
  }
});

// Endpoint: Obtener historial de transferencias recientes
app.get('/api/transfers', async (req, res) => {
  try {
    const query = `
      SELECT t.id_transferencia, t.fecha_transferencia, 
             so.nombre AS sucursal_origen_nombre, 
             sd.nombre AS sucursal_destino_nombre, 
             et.descripcion AS estado,
             dt.codigo_barras, p.nombre AS producto_nombre, dt.cantidad
      FROM transferencia t
      JOIN sucursal so ON t.sucursal_origen = so.id_sucursal
      JOIN sucursal sd ON t.sucursal_destino = sd.id_sucursal
      JOIN estado_transferencia et ON t.id_estado = et.id_estado
      JOIN detalle_transferencia dt ON t.id_transferencia = dt.id_transferencia
      JOIN producto p ON dt.codigo_barras = p.codigo_barras
      ORDER BY t.id_transferencia DESC
      LIMIT 10;
    `;
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener historial:', error);
    res.status(500).json({ error: 'Error al obtener historial.' });
  }
});

// Servir la aplicación HTML
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'formulario1.html'));
});

// Iniciar Servidor
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor Natura activo en http://localhost:${PORT}`);
});
