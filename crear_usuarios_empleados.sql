BEGIN;

CREATE TABLE IF NOT EXISTS usuario (
  id_usuario INT PRIMARY KEY REFERENCES empleado(id_empleado),
  clave VARCHAR(255) NOT NULL,
  fecha_alta DATE NOT NULL DEFAULT CURRENT_DATE,
  perfil VARCHAR(50) NOT NULL
);

INSERT INTO usuario (id_usuario, clave, fecha_alta, perfil)
SELECT e.id_empleado, '1234', CURRENT_DATE, te.descripcion
FROM empleado e
JOIN tipo_empleado te ON te.id_tipo_empleado = e.id_tipo_empleado
ON CONFLICT (id_usuario) DO UPDATE
SET clave = EXCLUDED.clave,
    perfil = EXCLUDED.perfil;

COMMIT;

SELECT
  e.id_empleado AS usuario,
  e.nombres,
  e.apellidos,
  s.id_sucursal,
  s.nombre AS sucursal,
  u.perfil
FROM usuario u
JOIN empleado e ON e.id_empleado = u.id_usuario
JOIN sucursal s ON s.id_sucursal = e.id_sucursal
ORDER BY e.id_empleado;
