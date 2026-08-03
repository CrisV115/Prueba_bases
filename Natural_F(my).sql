CREATE DATABASE natural_f;

-- TABLA MATRIZ

CREATE TABLE MATRIZ (
    id_matriz INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(200)
);


-- TABLA SUCURSAL

CREATE TABLE SUCURSAL (
    id_sucursal INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    num_local VARCHAR(20),
    nombre VARCHAR(100),
    ciudad VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    id_matriz INT,
    id_administrador INT,
    CONSTRAINT fk_sucursal_matriz
        FOREIGN KEY (id_matriz)
        REFERENCES MATRIZ(id_matriz)
);


-- TABLA EMPLEADO

CREATE TABLE EMPLEADO (
    id_empleado INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cedula VARCHAR(10),
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    telefono VARCHAR(20),
    cargo VARCHAR(50),
    fecha_ingreso DATE,
    id_sucursal INT,
    CONSTRAINT fk_empleado_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal)
);


-- TABLA VENTANILLA

CREATE TABLE VENTANILLA (
    id_ventanilla INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero INT,
    id_sucursal INT,
    CONSTRAINT fk_ventanilla_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal)
);

-- TABLA CATEGORIA

CREATE TABLE CATEGORIA (
    id_categoria INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_categoria VARCHAR(100)
);


-- TABLA LABORATORIO

CREATE TABLE LABORATORIO (
    id_laboratorio INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100),
    tipo VARCHAR(50),
    origen VARCHAR(30)
);

-- TABLA PRODUCTO

CREATE TABLE PRODUCTO (
    codigo_barras VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(150),
    descripcion TEXT,
    unidad_comercializacion VARCHAR(50),
    precio_unitario DECIMAL(10,2),
    registro_sanitario VARCHAR(100),
    tipo_medicamento VARCHAR(30),
    id_categoria INT,
    id_laboratorio INT,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria),

    CONSTRAINT fk_producto_laboratorio
        FOREIGN KEY (id_laboratorio)
        REFERENCES LABORATORIO(id_laboratorio)
);


-- TABLA LOTE_PRODUCTO

CREATE TABLE LOTE_PRODUCTO (
    id_lote INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_barras VARCHAR(50),
    numero_lote VARCHAR(50),
    fecha_vencimiento DATE,

    CONSTRAINT fk_lote_producto
        FOREIGN KEY (codigo_barras)
        REFERENCES PRODUCTO(codigo_barras)
);


-- TABLA PROVEEDOR

CREATE TABLE PROVEEDOR (
    ruc_proveedor VARCHAR(13) PRIMARY KEY,
    nombre VARCHAR(150),
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    correo VARCHAR(100),
    tipo_proveedor VARCHAR(50)
);


-- TABLA PROVEEDOR_PRODUCTO

CREATE TABLE PROVEEDOR_PRODUCTO (
    id_proveedor_producto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ruc_proveedor VARCHAR(13),
    codigo_barras VARCHAR(50),
    precio_referencia DECIMAL(10,2),

    CONSTRAINT fk_pp_proveedor
        FOREIGN KEY (ruc_proveedor)
        REFERENCES PROVEEDOR(ruc_proveedor),

    CONSTRAINT fk_pp_producto
        FOREIGN KEY (codigo_barras)
        REFERENCES PRODUCTO(codigo_barras)
);


-- TABLA INVENTARIO

CREATE TABLE INVENTARIO (
    id_inventario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_sucursal INT,
    codigo_barras VARCHAR(50),
    id_lote INT,
    cantidad_disponible INT,

    CONSTRAINT fk_inv_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal),

    CONSTRAINT fk_inv_producto
        FOREIGN KEY (codigo_barras)
        REFERENCES PRODUCTO(codigo_barras),

    CONSTRAINT fk_inv_lote
        FOREIGN KEY (id_lote)
        REFERENCES LOTE_PRODUCTO(id_lote)
);


-- TABLA CLIENTE

CREATE TABLE CLIENTE (
    identificacion VARCHAR(13) PRIMARY KEY,
    tipo_cliente VARCHAR(20),
    nombre VARCHAR(150),
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    correo VARCHAR(100)
);


-- TABLA MEDICO

CREATE TABLE MEDICO (
    id_medico INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombres VARCHAR(150),
    especialidad VARCHAR(100),
    telefono VARCHAR(20)
);


-- TABLA SEGURO_SALUD

CREATE TABLE SEGURO_SALUD (
    id_seguro INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_seguro VARCHAR(100),
    descripcion VARCHAR(200),
    fecha_convenio DATE,
    porcentaje_cobertura DECIMAL(5,2)
);


-- TABLA PLAN_MEDICACION

CREATE TABLE PLAN_MEDICACION (
    id_plan INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descripcion VARCHAR(200),
    frecuencia VARCHAR(100)
);


-- TABLA CLIENTE_PLAN

CREATE TABLE CLIENTE_PLAN (
    identificacion VARCHAR(13),
    id_plan INT,

    PRIMARY KEY (identificacion, id_plan),

    CONSTRAINT fk_cp_cliente
        FOREIGN KEY (identificacion)
        REFERENCES CLIENTE(identificacion),

    CONSTRAINT fk_cp_plan
        FOREIGN KEY (id_plan)
        REFERENCES PLAN_MEDICACION(id_plan)
);


-- TABLA METODO_PAGO

CREATE TABLE METODO_PAGO (
    id_metodo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descripcion VARCHAR(50)
);


-- TABLA COMPRA

CREATE TABLE COMPRA (
    id_compra INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_compra DATE,
    ruc_proveedor VARCHAR(13),
    id_sucursal INT,
    id_matriz INT,

    CONSTRAINT fk_compra_proveedor
        FOREIGN KEY (ruc_proveedor)
        REFERENCES PROVEEDOR(ruc_proveedor),

    CONSTRAINT fk_compra_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal),

    CONSTRAINT fk_compra_matriz
        FOREIGN KEY (id_matriz)
        REFERENCES MATRIZ(id_matriz)
);


-- TABLA DETALLE_COMPRA

CREATE TABLE DETALLE_COMPRA (
    id_detalle_compra INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_compra INT,
    codigo_barras VARCHAR(50),
    cantidad INT,
    precio_compra DECIMAL(10,2),

    CONSTRAINT fk_detcomp_compra
        FOREIGN KEY (id_compra)
        REFERENCES COMPRA(id_compra),

    CONSTRAINT fk_detcomp_producto
        FOREIGN KEY (codigo_barras)
        REFERENCES PRODUCTO(codigo_barras)
);


-- TABLA VENTA

CREATE TABLE VENTA (
    id_venta INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_hora TIMESTAMP,
    id_sucursal INT,
    id_empleado INT,
    identificacion_cliente VARCHAR(13),
    id_metodo INT,
    id_seguro INT,
    id_medico INT,

    CONSTRAINT fk_venta_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal),

    CONSTRAINT fk_venta_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO(id_empleado),

    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (identificacion_cliente)
        REFERENCES CLIENTE(identificacion),

    CONSTRAINT fk_venta_metodo
        FOREIGN KEY (id_metodo)
        REFERENCES METODO_PAGO(id_metodo),

    CONSTRAINT fk_venta_seguro
        FOREIGN KEY (id_seguro)
        REFERENCES SEGURO_SALUD(id_seguro),

    CONSTRAINT fk_venta_medico
        FOREIGN KEY (id_medico)
        REFERENCES MEDICO(id_medico)
);


-- TABLA DETALLE_VENTA

CREATE TABLE DETALLE_VENTA (
    id_detalle_venta INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_venta INT,
    codigo_barras VARCHAR(50),
    id_sucursal_origen INT,
    cantidad INT,
    precio_venta DECIMAL(10,2),

    CONSTRAINT fk_detventa_venta
        FOREIGN KEY (id_venta)
        REFERENCES VENTA(id_venta),

    CONSTRAINT fk_detventa_producto
        FOREIGN KEY (codigo_barras)
        REFERENCES PRODUCTO(codigo_barras),

    CONSTRAINT fk_detventa_sucursal
        FOREIGN KEY (id_sucursal_origen)
        REFERENCES SUCURSAL(id_sucursal)
);


-- TABLA TRANSFERENCIA

CREATE TABLE TRANSFERENCIA (
    id_transferencia INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sucursal_origen INT,
    sucursal_destino INT,
    fecha TIMESTAMP,

    CONSTRAINT fk_transf_origen
        FOREIGN KEY (sucursal_origen)
        REFERENCES SUCURSAL(id_sucursal),

    CONSTRAINT fk_transf_destino
        FOREIGN KEY (sucursal_destino)
        REFERENCES SUCURSAL(id_sucursal)
);


-- TABLA DETALLE_TRANSFERENCIA

CREATE TABLE DETALLE_TRANSFERENCIA (
    id_detalle_transferencia INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_transferencia INT,
    codigo_barras VARCHAR(50),
    cantidad INT,

    CONSTRAINT fk_dettrans_transferencia
        FOREIGN KEY (id_transferencia)
        REFERENCES TRANSFERENCIA(id_transferencia),

    CONSTRAINT fk_dettrans_producto
        FOREIGN KEY (codigo_barras)
        REFERENCES PRODUCTO(codigo_barras)
);


-- TABLA USUARIO

CREATE TABLE USUARIO (
    id_usuario INT PRIMARY KEY,
    clave VARCHAR(255),
    fecha_alta DATE,
    perfil VARCHAR(30),

    CONSTRAINT fk_usuario_empleado
        FOREIGN KEY (id_usuario)
        REFERENCES EMPLEADO(id_empleado)
);


-- TABLA TABLA_AUDIT

CREATE TABLE TABLA_AUDIT (
    id_auditoria INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_tabla VARCHAR(50),
    operacion VARCHAR(20),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    fecha_registro TIMESTAMP,
    id_usuario INT
);

ALTER TABLE SUCURSAL
ADD CONSTRAINT fk_sucursal_administrador
FOREIGN KEY (id_administrador)
REFERENCES EMPLEADO(id_empleado);


-- CREACIÓN DE ROLES

CREATE ROLE administrativo NOLOGIN;
CREATE ROLE director NOLOGIN;
CREATE ROLE supervisor NOLOGIN;
CREATE ROLE cajero NOLOGIN;

-- ASIGNAR PERMISOS
--ROL ADMINISTRATIVO

GRANT ALL PRIVILEGES ON TABLE
MATRIZ,
SUCURSAL,
EMPLEADO,
PROVEEDOR,
PROVEEDOR_PRODUCTO,
COMPRA,
DETALLE_COMPRA,
PRODUCTO,
CATEGORIA,
LABORATORIO,
LOTE_PRODUCTO,
INVENTARIO,
MEDICO,
SEGURO_SALUD,
PLAN_MEDICACION,
CLIENTE_PLAN,
METODO_PAGO,
CLIENTE
TO administrativo;

-- ROL DIRECTOR

GRANT SELECT ON ALL TABLES IN SCHEMA public
TO director;

-- ROL SUPERVISOR

GRANT SELECT ON
PRODUCTO,
INVENTARIO,
VENTA,
DETALLE_VENTA,
CLIENTE,
SUCURSAL,
EMPLEADO,
TRANSFERENCIA,
DETALLE_TRANSFERENCIA
TO supervisor;

GRANT INSERT,UPDATE ON

INVENTARIO,
TRANSFERENCIA,
DETALLE_TRANSFERENCIA

TO supervisor;

-- ROL CAJERO 

GRANT SELECT ON

PRODUCTO,
CLIENTE,
METODO_PAGO,
SEGURO_SALUD,
PLAN_MEDICACION,
MEDICO

TO cajero;

GRANT INSERT ON

VENTA,
DETALLE_VENTA

TO cajero;

--CREAR USUARIOS 
-- DBA

CREATE ROLE dba_natural
LOGIN
PASSWORD 'Dba123';

ALTER ROLE dba_natural
WITH SUPERUSER
CREATEDB
CREATEROLE;

-- Administrativo

CREATE ROLE admin1
LOGIN
PASSWORD 'Admin123';

GRANT administrativo TO admin1;

-- Director

CREATE ROLE director1
LOGIN
PASSWORD 'Director123';

GRANT director TO director1;

-- Supervisor

CREATE ROLE supervisor1
LOGIN
PASSWORD 'Supervisor123';

GRANT supervisor TO supervisor1;

-- Cajero

CREATE ROLE cajero1
LOGIN
PASSWORD 'Cajero123';

GRANT cajero TO cajero1;

-- CAMBIO DE CONTRASEÑA

ALTER ROLE cajero1
PASSWORD 'NuevaClave123';

--MOSTRAR LOS USUARIOS CREADOS

SELECT *
FROM pg_shadow;

-- PRUEBAS DE PERMISO 
-- COMO DIRECTOR 

SELECT * FROM PRODUCTO;

SELECT * FROM INVENTARIO;

SELECT * FROM EMPLEADO;

DELETE FROM PRODUCTO
WHERE codigo_barras='123';

-- COMO CAJERO 
INSERT INTO VENTA
(fecha_hora,id_sucursal,id_empleado,id_metodo)
VALUES
(NOW(),1,1,1);

SELECT * FROM PRODUCTO;

DELETE FROM PRODUCTO;

UPDATE EMPLEADO
SET nombres='PRUEBA';

-- COMO SUPERVISOR

SELECT * FROM INVENTARIO;

UPDATE INVENTARIO
SET cantidad_disponible=50
WHERE id_inventario=1;

DELETE FROM CLIENTE;

-- COMO ADMINISTRADOR

INSERT INTO PRODUCTO
(codigo_barras,nombre)
VALUES
('99999','Producto Prueba');

UPDATE PROVEEDOR
SET telefono='0999999999';

DELETE FROM PROVEEDOR_PRODUCTO
WHERE id_proveedor_producto=1;

SELECT datname FROM pg_database;

