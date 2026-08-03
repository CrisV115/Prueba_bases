-- PostgreSQL Dump - Adaptación desde MySQL soy_natural
-- ------------------------------------------------------

BEGIN;

-- 1. PROVINCIA
DROP TABLE IF EXISTS provincia CASCADE;
CREATE TABLE provincia (
  id_provincia SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE
);
CREATE INDEX idx_provincia_nombre ON provincia(nombre);

INSERT INTO provincia (id_provincia, nombre) VALUES 
(3,'Azuay'),(16,'Bolivar'),(17,'Canar'),(15,'Carchi'),(10,'Chimborazo'),
(9,'Cotopaxi'),(7,'El Oro'),(11,'Esmeraldas'),(2,'Guayas'),(8,'Imbabura'),
(6,'Loja'),(14,'Los Rios'),(4,'Manabi'),(19,'Napo'),(20,'Orellana'),
(18,'Pastaza'),(1,'Pichincha'),(13,'Santa Elena'),(12,'Santo Domingo'),(5,'Tungurahua');


-- 2. CIUDAD
DROP TABLE IF EXISTS ciudad CASCADE;
CREATE TABLE ciudad (
  id_ciudad SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_provincia INT NOT NULL REFERENCES provincia(id_provincia)
);
CREATE INDEX idx_ciudad_nombre ON ciudad(nombre);
CREATE INDEX idx_ciudad_provincia ON ciudad(id_provincia);

INSERT INTO ciudad (id_ciudad, nombre, id_provincia) VALUES 
(1,'Quito',1),(2,'Guayaquil',2),(3,'Cuenca',3),(4,'Manta',4),(5,'Ambato',5),
(6,'Loja',6),(7,'Machala',7),(8,'Ibarra',8),(9,'Latacunga',9),(10,'Riobamba',10),
(11,'Esmeraldas',11),(12,'Santo Domingo',12),(13,'Salinas',13),(14,'Babahoyo',14),(15,'Tulcan',15),
(16,'Guaranda',16),(17,'Azogues',17),(18,'Puyo',18),(19,'Tena',19),(20,'Francisco de Orellana',20);


-- 3. DIRECCION
DROP TABLE IF EXISTS direccion CASCADE;
CREATE TABLE direccion (
  id_direccion SERIAL PRIMARY KEY,
  calle_principal VARCHAR(150),
  calle_secundaria VARCHAR(150),
  referencia VARCHAR(250),
  id_ciudad INT NOT NULL REFERENCES ciudad(id_ciudad)
);
CREATE INDEX idx_direccion_ciudad ON direccion(id_ciudad);

INSERT INTO direccion (id_direccion, calle_principal, calle_secundaria, referencia, id_ciudad) VALUES 
(1,'Av. Amazonas','Naciones Unidas','Referencia local 01',1),
(2,'Av. 9 de Octubre','Malecon','Referencia local 02',2),
(3,'Gran Colombia','Benigno Malo','Referencia local 03',3),
(4,'Av. Flavio Reyes','Calle 12','Referencia local 04',4),
(5,'Av. Cevallos','Montalvo','Referencia local 05',5),
(6,'18 de Noviembre','Rocafuerte','Referencia local 06',6),
(7,'Av. 25 de Junio','Sucre','Referencia local 07',7),
(8,'Bolivar','Sanchez y Cifuentes','Referencia local 08',8),
(9,'Av. Eloy Alfaro','Quito','Referencia local 09',9),
(10,'Primera Constituyente','Espejo','Referencia local 10',10),
(11,'Simon Plata Torres','Olmedo','Referencia local 11',11),
(12,'Av. Quito','Rio Toachi','Referencia local 12',12),
(13,'Av. Carlos Espinoza','Calle 5','Referencia local 13',13),
(14,'General Barona','10 de Agosto','Referencia local 14',14),
(15,'Av. Manabi','Bolivar','Referencia local 15',15),
(16,'Convencion de 1884','Garcia Moreno','Referencia local 16',16),
(17,'Av. 24 de Mayo','Azuay','Referencia local 17',17),
(18,'Ceslao Marin','Atahualpa','Referencia local 18',18),
(19,'Av. Jumandy','15 de Noviembre','Referencia local 19',19),
(20,'Av. Alejandro Labaka','Amazonas','Referencia local 20',20);


-- 4. MATRIZ
DROP TABLE IF EXISTS matriz CASCADE;
CREATE TABLE matriz (
  id_matriz SERIAL PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  ruc VARCHAR(13) UNIQUE,
  telefono VARCHAR(20),
  correo VARCHAR(100),
  id_direccion INT REFERENCES direccion(id_direccion)
);

INSERT INTO matriz (id_matriz, nombre, ruc, telefono, correo, id_direccion) VALUES 
(1,'Matriz Natura Norte','1791000000001','02-240001','matriz01@soynatural.com',1),
(2,'Matriz Natura Sur','1791000000002','02-240002','matriz02@soynatural.com',2),
(3,'Matriz Natura Centro','1791000000003','02-240003','matriz03@soynatural.com',3),
(4,'Matriz Natura Costa','1791000000004','02-240004','matriz04@soynatural.com',4),
(5,'Matriz Natura Sierra','1791000000005','02-240005','matriz05@soynatural.com',5),
(6,'Matriz Natura Andina','1791000000006','02-240006','matriz06@soynatural.com',6),
(7,'Matriz Natura Pacifico','1791000000007','02-240007','matriz07@soynatural.com',7),
(8,'Matriz Natura Oriental','1791000000008','02-240008','matriz08@soynatural.com',8),
(9,'Matriz Natura Salud','1791000000009','02-240009','matriz09@soynatural.com',9),
(10,'Matriz Natura Vida','1791000000010','02-240010','matriz10@soynatural.com',10),
(11,'Matriz Natura Bienestar','1791000000011','02-240011','matriz11@soynatural.com',11),
(12,'Matriz Natura Familiar','1791000000012','02-240012','matriz12@soynatural.com',12),
(13,'Matriz Natura Integral','1791000000013','02-240013','matriz13@soynatural.com',13),
(14,'Matriz Natura Farma','1791000000014','02-240014','matriz14@soynatural.com',14),
(15,'Matriz Natura Express','1791000000015','02-240015','matriz15@soynatural.com',15),
(16,'Matriz Natura Plus','1791000000016','02-240016','matriz16@soynatural.com',16),
(17,'Matriz Natura Verde','1791000000017','02-240017','matriz17@soynatural.com',17),
(18,'Matriz Natura Medica','1791000000018','02-240018','matriz18@soynatural.com',18),
(19,'Matriz Natura Popular','1791000000019','02-240019','matriz19@soynatural.com',19),
(20,'Matriz Natura Mayorista','1791000000020','02-240020','matriz20@soynatural.com',20);


-- 5. SUCURSAL
DROP TABLE IF EXISTS sucursal CASCADE;
CREATE TABLE sucursal (
  id_sucursal SERIAL PRIMARY KEY,
  numero_local VARCHAR(20) NOT NULL UNIQUE,
  nombre VARCHAR(150),
  telefono VARCHAR(20),
  id_direccion INT NOT NULL REFERENCES direccion(id_direccion),
  id_matriz INT NOT NULL REFERENCES matriz(id_matriz)
);
CREATE INDEX idx_sucursal_local ON sucursal(numero_local);

INSERT INTO sucursal (id_sucursal, numero_local, nombre, telefono, id_direccion, id_matriz) VALUES 
(1,'LOC-001','Sucursal Quito Norte','03-250001',1,1),
(2,'LOC-002','Sucursal Guayaquil Centro','03-250002',2,2),
(3,'LOC-003','Sucursal Cuenca Historica','03-250003',3,3),
(4,'LOC-004','Sucursal Manta Playa','03-250004',4,4),
(5,'LOC-005','Sucursal Ambato Central','03-250005',5,5),
(6,'LOC-006','Sucursal Loja Sur','03-250006',6,6),
(7,'LOC-007','Sucursal Machala Este','03-250007',7,7),
(8,'LOC-008','Sucursal Ibarra Plaza','03-250008',8,8),
(9,'LOC-009','Sucursal Latacunga Parque','03-250009',9,9),
(10,'LOC-010','Sucursal Riobamba Norte','03-250010',10,10),
(11,'LOC-011','Sucursal Esmeraldas Puerto','03-250011',11,11),
(12,'LOC-012','Sucursal Santo Domingo','03-250012',12,12),
(13,'LOC-013','Sucursal Salinas Malecon','03-250013',13,13),
(14,'LOC-014','Sucursal Babahoyo Centro','03-250014',14,14),
(15,'LOC-015','Sucursal Tulcan Frontera','03-250015',15,15),
(16,'LOC-016','Sucursal Guaranda Plaza','03-250016',16,16),
(17,'LOC-017','Sucursal Azogues Centro','03-250017',17,17),
(18,'LOC-018','Sucursal Puyo Terminal','03-250018',18,18),
(19,'LOC-019','Sucursal Tena Norte','03-250019',19,19),
(20,'LOC-020','Sucursal Coca Central','03-250020',20,20);


-- 6. TIPO_EMPLEADO
DROP TABLE IF EXISTS tipo_empleado CASCADE;
CREATE TABLE tipo_empleado (
  id_tipo_empleado SERIAL PRIMARY KEY,
  descripcion VARCHAR(50) UNIQUE
);

INSERT INTO tipo_empleado (id_tipo_empleado, descripcion) VALUES 
(1,'Administrador'),(12,'Analista inventario'),(13,'Asesor comercial'),(20,'Asistente'),
(18,'Atencion cliente'),(16,'Auditor'),(4,'Auxiliar'),(5,'Bodeguero'),(2,'Cajero'),
(17,'Comprador'),(8,'Contador'),(15,'Coordinador'),(3,'Farmaceutico'),(19,'Gerente sucursal'),
(11,'Jefe de compras'),(9,'Mensajero'),(10,'Recepcionista'),(7,'Supervisor'),(14,'Tecnico sistemas'),(6,'Vendedor');


-- 7. EMPLEADO
DROP TABLE IF EXISTS empleado CASCADE;
CREATE TABLE empleado (
  id_empleado SERIAL PRIMARY KEY,
  cedula VARCHAR(10) NOT NULL UNIQUE,
  nombres VARCHAR(100),
  apellidos VARCHAR(100),
  telefono VARCHAR(20),
  correo VARCHAR(100),
  fecha_ingreso DATE,
  id_tipo_empleado INT REFERENCES tipo_empleado(id_tipo_empleado),
  id_sucursal INT REFERENCES sucursal(id_sucursal)
);
CREATE INDEX idx_empleado_cedula ON empleado(cedula);
CREATE INDEX idx_empleado_sucursal ON empleado(id_sucursal);

INSERT INTO empleado (id_empleado, cedula, nombres, apellidos, telefono, correo, fecha_ingreso, id_tipo_empleado, id_sucursal) VALUES 
(1,'0102030001','Ana','Mora','0980000001','ana.mora@soynatural.com','2025-01-01',1,1),
(2,'0102030002','Luis','Perez','0980000002','luis.perez@soynatural.com','2025-02-02',2,2),
(3,'0102030003','Maria','Vasquez','0980000003','maria.vasquez@soynatural.com','2025-03-03',3,3),
(4,'0102030004','Carlos','Lopez','0980000004','carlos.lopez@soynatural.com','2025-04-04',4,4),
(5,'0102030005','Sofia','Castro','0980000005','sofia.castro@soynatural.com','2025-05-05',5,5),
(6,'0102030006','Diego','Torres','0980000006','diego.torres@soynatural.com','2025-06-06',6,6),
(7,'0102030007','Lucia','Rojas','0980000007','lucia.rojas@soynatural.com','2025-07-07',7,7),
(8,'0102030008','Jorge','Suarez','0980000008','jorge.suarez@soynatural.com','2025-08-08',8,8),
(9,'0102030009','Paula','Cevallos','0980000009','paula.cevallos@soynatural.com','2025-09-09',9,9),
(10,'0102030010','Andres','Vera','0980000010','andres.vera@soynatural.com','2025-10-10',10,10),
(11,'0102030011','Valeria','Ortega','0980000011','valeria.ortega@soynatural.com','2025-11-11',11,11),
(12,'0102030012','Miguel','Munoz','0980000012','miguel.munoz@soynatural.com','2025-12-12',12,12),
(13,'0102030013','Camila','Bravo','0980000013','camila.bravo@soynatural.com','2025-01-13',13,13),
(14,'0102030014','Ricardo','Paredes','0980000014','ricardo.paredes@soynatural.com','2025-02-14',14,14),
(15,'0102030015','Daniela','Santos','0980000015','daniela.santos@soynatural.com','2025-03-15',15,15),
(16,'0102030016','Fernando','Reyes','0980000016','fernando.reyes@soynatural.com','2025-04-16',16,16),
(17,'0102030017','Gabriela','Mendoza','0980000017','gabriela.mendoza@soynatural.com','2025-05-17',17,17),
(18,'0102030018','Sebastian','Alvarez','0980000018','sebastian.alvarez@soynatural.com','2025-06-18',18,18),
(19,'0102030019','Natalia','Naranjo','0980000019','natalia.naranjo@soynatural.com','2025-07-19',19,19),
(20,'0102030020','Esteban','Guerrero','0980000020','esteban.guerrero@soynatural.com','2025-08-20',20,20);


-- 8. CATEGORIA_PRODUCTO
DROP TABLE IF EXISTS categoria_producto CASCADE;
CREATE TABLE categoria_producto (
  id_categoria SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO categoria_producto (id_categoria, nombre) VALUES 
(1,'Analgesicos'),(18,'Antialergicos'),(2,'Antibioticos'),(8,'Cardiologia'),
(4,'Cuidado personal'),(5,'Dermatologia'),(9,'Diabetes'),(6,'Digestivos'),
(11,'Ginecologia'),(16,'Higiene'),(15,'Naturales'),(19,'Neurologia'),
(20,'Nutricion'),(12,'Oftalmologia'),(13,'Ortopedia'),(10,'Pediatria'),
(17,'Primeros auxilios'),(7,'Respiratorios'),(14,'Suplementos'),(3,'Vitaminas');


-- 9. UNIDAD_MEDIDA
DROP TABLE IF EXISTS unidad_medida CASCADE;
CREATE TABLE unidad_medida (
  id_unidad SERIAL PRIMARY KEY,
  nombre VARCHAR(50) UNIQUE
);

INSERT INTO unidad_medida (id_unidad, nombre) VALUES 
(6,'Ampolla'),(13,'Blister'),(4,'Caja'),(2,'Capsula'),(7,'Crema'),(3,'Frasco'),
(8,'Gel'),(10,'Gotas'),(20,'Inhalador'),(9,'Jarabe'),(17,'Parche'),(16,'Pomo'),
(15,'Sachet'),(5,'Sobre'),(18,'Solucion'),(11,'Spray'),(19,'Suspension'),
(1,'Tableta'),(14,'Tubo'),(12,'Unidad');


-- 10. LABORATORIO
DROP TABLE IF EXISTS laboratorio CASCADE;
CREATE TABLE laboratorio (
  id_laboratorio SERIAL PRIMARY KEY,
  nombre VARCHAR(150),
  pais VARCHAR(100)
);
CREATE INDEX idx_laboratorio_nombre ON laboratorio(nombre);

INSERT INTO laboratorio (id_laboratorio, nombre, pais) VALUES 
(1,'Farbiol','Ecuador'),(2,'Life','Ecuador'),(3,'Bayer','Alemania'),(4,'Roemmers','Argentina'),
(5,'Bago','Chile'),(6,'Genfar','Colombia'),(7,'MK','Colombia'),(8,'La Sante','Colombia'),
(9,'Pfizer','Estados Unidos'),(10,'Novartis','Suiza'),(11,'Rocnarf','Ecuador'),(12,'Acromax','Ecuador'),
(13,'Grunenthal','Alemania'),(14,'Sanofi','Francia'),(15,'Abbott','Estados Unidos'),(16,'Bristol','Estados Unidos'),
(17,'Tecnoquimicas','Colombia'),(18,'Glaxo','Reino Unido'),(19,'Medicamenta','Ecuador'),(20,'Nifa','Ecuador');


-- 11. PRODUCTO
DROP TABLE IF EXISTS producto CASCADE;
CREATE TABLE producto (
  codigo_barras VARCHAR(50) PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  precio_unitario DECIMAL(10,2),
  registro_sanitario VARCHAR(100),
  es_generico BOOLEAN,
  id_categoria INT REFERENCES categoria_producto(id_categoria),
  id_unidad INT REFERENCES unidad_medida(id_unidad),
  id_laboratorio INT REFERENCES laboratorio(id_laboratorio)
);
CREATE INDEX idx_producto_nombre ON producto(nombre);
CREATE INDEX idx_producto_categoria ON producto(id_categoria);

INSERT INTO producto (codigo_barras, nombre, descripcion, precio_unitario, registro_sanitario, es_generico, id_categoria, id_unidad, id_laboratorio) VALUES 
('7861000000001','Paracetamol 500 mg','Producto Paracetamol 500 mg para venta en farmacia',2.10,'RSN-2027-0001',TRUE,1,1,1),
('7861000000002','Ibuprofeno 400 mg','Producto Ibuprofeno 400 mg para venta en farmacia',2.95,'RSN-2028-0002',TRUE,2,2,2),
('7861000000003','Vitamina C 1 g','Producto Vitamina C 1 g para venta en farmacia',3.80,'RSN-2029-0003',FALSE,3,3,3),
('7861000000004','Alcohol antiseptico','Producto Alcohol antiseptico para venta en farmacia',4.65,'RSN-2030-0004',FALSE,4,4,4),
('7861000000005','Crema hidratante','Producto Crema hidratante para venta en farmacia',5.50,'RSN-2031-0005',FALSE,5,5,5),
('7861000000006','Omeprazol 20 mg','Producto Omeprazol 20 mg para venta en farmacia',6.35,'RSN-2032-0006',TRUE,6,6,6),
('7861000000007','Loratadina 10 mg','Producto Loratadina 10 mg para venta en farmacia',7.20,'RSN-2033-0007',TRUE,7,7,7),
('7861000000008','Losartan 50 mg','Producto Losartan 50 mg para venta en farmacia',8.05,'RSN-2034-0008',TRUE,8,8,8),
('7861000000009','Metformina 850 mg','Producto Metformina 850 mg para venta en farmacia',8.90,'RSN-2035-0009',TRUE,9,9,9),
('7861000000010','Jarabe infantil','Producto Jarabe infantil para venta en farmacia',9.75,'RSN-2036-0010',FALSE,10,10,10),
('7861000000011','Acido folico','Producto Acido folico para venta en farmacia',10.60,'RSN-2037-0011',FALSE,11,11,11),
('7861000000012','Lagrimas artificiales','Producto Lagrimas artificiales para venta en farmacia',11.45,'RSN-2038-0012',FALSE,12,12,12),
('7861000000013','Venda elastica','Producto Venda elastica para venta en farmacia',12.30,'RSN-2039-0013',FALSE,13,13,13),
('7861000000014','Omega 3','Producto Omega 3 para venta en farmacia',13.15,'RSN-2040-0014',FALSE,14,14,14),
('7861000000015','Propoleo spray','Producto Propoleo spray para venta en farmacia',14.00,'RSN-2041-0015',FALSE,15,15,15),
('7861000000016','Gel antibacterial','Producto Gel antibacterial para venta en farmacia',14.85,'RSN-2042-0016',FALSE,16,16,16),
('7861000000017','Gasas esteriles','Producto Gasas esteriles para venta en farmacia',15.70,'RSN-2043-0017',FALSE,17,17,17),
('7861000000018','Cetirizina 10 mg','Producto Cetirizina 10 mg para venta en farmacia',16.55,'RSN-2044-0018',TRUE,18,18,18),
('7861000000019','Complejo B','Producto Complejo B para venta en farmacia',17.40,'RSN-2045-0019',TRUE,19,19,19),
('7861000000020','Suero oral','Producto Suero oral para venta en farmacia',18.25,'RSN-2046-0020',FALSE,20,20,20);


-- 12. LOTE_PRODUCTO
DROP TABLE IF EXISTS lote_producto CASCADE;
CREATE TABLE lote_producto (
  id_lote SERIAL PRIMARY KEY,
  codigo_barras VARCHAR(50) REFERENCES producto(codigo_barras),
  numero_lote VARCHAR(50),
  fecha_caducidad DATE
);
CREATE INDEX idx_lote_fecha ON lote_producto(fecha_caducidad);

INSERT INTO lote_producto (id_lote, codigo_barras, numero_lote, fecha_caducidad) VALUES 
(1,'7861000000001','LOT-2027-001','2027-01-01'),
(2,'7861000000002','LOT-2027-002','2027-02-02'),
(3,'7861000000003','LOT-2027-003','2027-03-03'),
(4,'7861000000004','LOT-2027-004','2027-04-04'),
(5,'7861000000005','LOT-2027-005','2027-05-05'),
(6,'7861000000006','LOT-2027-006','2027-06-06'),
(7,'7861000000007','LOT-2027-007','2027-07-07'),
(8,'7861000000008','LOT-2027-008','2027-08-08'),
(9,'7861000000009','LOT-2027-009','2027-09-09'),
(10,'7861000000010','LOT-2027-010','2027-10-10'),
(11,'7861000000011','LOT-2027-011','2027-11-11'),
(12,'7861000000012','LOT-2027-012','2027-12-12'),
(13,'7861000000013','LOT-2027-013','2027-01-13'),
(14,'7861000000014','LOT-2027-014','2027-02-14'),
(15,'7861000000015','LOT-2027-015','2027-03-15'),
(16,'7861000000016','LOT-2027-016','2027-04-16'),
(17,'7861000000017','LOT-2027-017','2027-05-17'),
(18,'7861000000018','LOT-2027-018','2027-06-18'),
(19,'7861000000019','LOT-2027-019','2027-07-19'),
(20,'7861000000020','LOT-2027-020','2027-08-20');


-- 13. INVENTARIO
DROP TABLE IF EXISTS inventario CASCADE;
CREATE TABLE inventario (
  id_inventario SERIAL PRIMARY KEY,
  id_sucursal INT REFERENCES sucursal(id_sucursal),
  codigo_barras VARCHAR(50) REFERENCES producto(codigo_barras),
  stock INT DEFAULT 0
);
CREATE INDEX idx_inventario_producto ON inventario(codigo_barras);
CREATE INDEX idx_inventario_sucursal ON inventario(id_sucursal);

INSERT INTO inventario (id_inventario, id_sucursal, codigo_barras, stock) VALUES 
(1,1,'7861000000001',343),(2,2,'7861000000002',348),(3,3,'7861000000003',353),
(4,4,'7861000000004',362),(5,5,'7861000000005',367),(6,6,'7861000000006',372),
(7,7,'7861000000007',377),(8,8,'7861000000008',386),(9,9,'7861000000009',391),
(10,10,'7861000000010',396),(11,11,'7861000000011',401),(12,12,'7861000000012',410),
(13,13,'7861000000013',415),(14,14,'7861000000014',420),(15,15,'7861000000015',425),
(16,16,'7861000000016',434),(17,17,'7861000000017',439),(18,18,'7861000000018',444),
(19,19,'7861000000019',449),(20,20,'7861000000020',458);


-- 14. TIPO_CLIENTE
DROP TABLE IF EXISTS tipo_cliente CASCADE;
CREATE TABLE tipo_cliente (
  id_tipo_cliente SERIAL PRIMARY KEY,
  descripcion VARCHAR(50)
);

INSERT INTO tipo_cliente (id_tipo_cliente, descripcion) VALUES 
(1,'Consumidor final'),(2,'Afiliado'),(3,'Corporativo'),(4,'Tercera edad'),(5,'Estudiante'),
(6,'Convenio empresa'),(7,'Paciente cronico'),(8,'Mayorista'),(9,'Minorista'),(10,'Cliente frecuente'),
(11,'Cliente nuevo'),(12,'Seguro privado'),(13,'Seguro publico'),(14,'Empleado interno'),(15,'Institucion'),
(16,'Clinica'),(17,'Hospital'),(18,'Medico referido'),(19,'Online'),(20,'Domicilio');


-- 15. CLIENTE
DROP TABLE IF EXISTS cliente CASCADE;
CREATE TABLE cliente (
  id_cliente SERIAL PRIMARY KEY,
  ruc_cedula VARCHAR(20),
  nombre VARCHAR(150),
  telefono VARCHAR(20),
  correo VARCHAR(100),
  id_direccion INT REFERENCES direccion(id_direccion),
  id_tipo_cliente INT REFERENCES tipo_cliente(id_tipo_cliente)
);
CREATE INDEX idx_cliente_documento ON cliente(ruc_cedula);

INSERT INTO cliente (id_cliente, ruc_cedula, nombre, telefono, correo, id_direccion, id_tipo_cliente) VALUES 
(1,'1713000001','Cliente Natura 01','0970000001','cliente01@correo.com',1,1),
(2,'1713000002','Cliente Natura 02','0970000002','cliente02@correo.com',2,2),
(3,'1713000003','Cliente Natura 03','0970000003','cliente03@correo.com',3,3),
(4,'1713000004','Cliente Natura 04','0970000004','cliente04@correo.com',4,4),
(5,'1713000005','Cliente Natura 05','0970000005','cliente05@correo.com',5,5),
(6,'1713000006','Cliente Natura 06','0970000006','cliente06@correo.com',6,6),
(7,'1713000007','Cliente Natura 07','0970000007','cliente07@correo.com',7,7),
(8,'1713000008','Cliente Natura 08','0970000008','cliente08@correo.com',8,8),
(9,'1713000009','Cliente Natura 09','0970000009','cliente09@correo.com',9,9),
(10,'1713000010','Cliente Natura 10','0970000010','cliente10@correo.com',10,10),
(11,'1713000011','Cliente Natura 11','0970000011','cliente11@correo.com',11,11),
(12,'1713000012','Cliente Natura 12','0970000012','cliente12@correo.com',12,12),
(13,'1713000013','Cliente Natura 13','0970000013','cliente13@correo.com',13,13),
(14,'1713000014','Cliente Natura 14','0970000014','cliente14@correo.com',14,14),
(15,'1713000015','Cliente Natura 15','0970000015','cliente15@correo.com',15,15),
(16,'1713000016','Cliente Natura 16','0970000016','cliente16@correo.com',16,16),
(17,'1713000017','Cliente Natura 17','0970000017','cliente17@correo.com',17,17),
(18,'1713000018','Cliente Natura 18','0970000018','cliente18@correo.com',18,18),
(19,'1713000019','Cliente Natura 19','0970000019','cliente19@correo.com',19,19),
(20,'1713000020','Cliente Natura 20','0970000020','cliente20@correo.com',20,20);


-- 16. CONVENIO_SEGURO
DROP TABLE IF EXISTS convenio_seguro CASCADE;
CREATE TABLE convenio_seguro (
  id_seguro SERIAL PRIMARY KEY,
  nombre VARCHAR(150),
  descripcion TEXT
);

INSERT INTO convenio_seguro (id_seguro, nombre, descripcion) VALUES 
(1,'Salud Total','Convenio activo para cobertura de medicamentos 01'),
(2,'Vida Sana','Convenio activo para cobertura de medicamentos 02'),
(3,'MedSeguro','Convenio activo para cobertura de medicamentos 03'),
(4,'Familia Plus','Convenio activo para cobertura de medicamentos 04'),
(5,'Proteccion Integral','Convenio activo para cobertura de medicamentos 05'),
(6,'Plan Empresarial','Convenio activo para cobertura de medicamentos 06'),
(7,'Bienestar 360','Convenio activo para cobertura de medicamentos 07'),
(8,'Seguro Popular','Convenio activo para cobertura de medicamentos 08'),
(9,'Clinica Aliada','Convenio activo para cobertura de medicamentos 09'),
(10,'Red Salud','Convenio activo para cobertura de medicamentos 10'),
(11,'Salud Premium','Convenio activo para cobertura de medicamentos 11'),
(12,'Cobertura Farma','Convenio activo para cobertura de medicamentos 12'),
(13,'Plan Dorado','Convenio activo para cobertura de medicamentos 13'),
(14,'Plan Plata','Convenio activo para cobertura de medicamentos 14'),
(15,'Plan Basico','Convenio activo para cobertura de medicamentos 15'),
(16,'Plan Mujer','Convenio activo para cobertura de medicamentos 16'),
(17,'Plan Infantil','Convenio activo para cobertura de medicamentos 17'),
(18,'Plan Senior','Convenio activo para cobertura de medicamentos 18'),
(19,'Plan Cronico','Convenio activo para cobertura de medicamentos 19'),
(20,'Plan Emergencia','Convenio activo para cobertura de medicamentos 20');


-- 17. MEDICO
DROP TABLE IF EXISTS medico CASCADE;
CREATE TABLE medico (
  id_medico SERIAL PRIMARY KEY,
  cedula VARCHAR(20) UNIQUE,
  nombre VARCHAR(150),
  especialidad VARCHAR(100)
);

INSERT INTO medico (id_medico, cedula, nombre, especialidad) VALUES 
(1,'1004000001','Dr. Ana Mora','Medicina general'),(2,'1004000002','Dr. Luis Perez','Pediatria'),
(3,'1004000003','Dr. Maria Vasquez','Cardiologia'),(4,'1004000004','Dr. Carlos Lopez','Dermatologia'),
(5,'1004000005','Dr. Sofia Castro','Ginecologia'),(6,'1004000006','Dr. Diego Torres','Traumatologia'),
(7,'1004000007','Dr. Lucia Rojas','Oftalmologia'),(8,'1004000008','Dr. Jorge Suarez','Neurologia'),
(9,'1004000009','Dr. Paula Cevallos','Endocrinologia'),(10,'1004000010','Dr. Andres Vera','Gastroenterologia'),
(11,'1004000011','Dr. Valeria Ortega','Otorrinolaringologia'),(12,'1004000012','Dr. Miguel Munoz','Urologia'),
(13,'1004000013','Dr. Camila Bravo','Psiquiatria'),(14,'1004000014','Dr. Ricardo Paredes','Neumologia'),
(15,'1004000015','Dr. Daniela Santos','Reumatologia'),(16,'1004000016','Dr. Fernando Reyes','Oncologia'),
(17,'1004000017','Dr. Gabriela Mendoza','Nefrologia'),(18,'1004000018','Dr. Sebastian Alvarez','Alergologia'),
(19,'1004000019','Dr. Natalia Naranjo','Nutricion'),(20,'1004000020','Dr. Esteban Guerrero','Geriatria');


-- 18. RECETA_MEDICA
DROP TABLE IF EXISTS receta_medica CASCADE;
CREATE TABLE receta_medica (
  id_receta SERIAL PRIMARY KEY,
  id_medico INT REFERENCES medico(id_medico),
  id_cliente INT REFERENCES cliente(id_cliente),
  fecha_emision DATE
);

INSERT INTO receta_medica (id_receta, id_medico, id_cliente, fecha_emision) VALUES 
(1,1,1,'2026-01-01'),(2,2,2,'2026-02-02'),(3,3,3,'2026-03-03'),(4,4,4,'2026-04-04'),
(5,5,5,'2026-05-05'),(6,6,6,'2026-06-06'),(7,7,7,'2026-01-07'),(8,8,8,'2026-02-08'),
(9,9,9,'2026-03-09'),(10,10,10,'2026-04-10'),(11,11,11,'2026-05-11'),(12,12,12,'2026-06-12'),
(13,13,13,'2026-01-13'),(14,14,14,'2026-02-14'),(15,15,15,'2026-03-15'),(16,16,16,'2026-04-16'),
(17,17,17,'2026-05-17'),(18,18,18,'2026-06-18'),(19,19,19,'2026-01-19'),(20,20,20,'2026-02-20');


-- 19. DETALLE_RECETA
DROP TABLE IF EXISTS detalle_receta CASCADE;
CREATE TABLE detalle_receta (
  id_detalle_receta SERIAL PRIMARY KEY,
  id_receta INT REFERENCES receta_medica(id_receta),
  codigo_barras VARCHAR(50) REFERENCES producto(codigo_barras)
);

INSERT INTO detalle_receta (id_detalle_receta, id_receta, codigo_barras) VALUES 
(1,1,'7861000000001'),(2,2,'7861000000002'),(3,3,'7861000000003'),(4,4,'7861000000004'),
(5,5,'7861000000005'),(6,6,'7861000000006'),(7,7,'7861000000007'),(8,8,'7861000000008'),
(9,9,'7861000000009'),(10,10,'7861000000010'),(11,11,'7861000000011'),(12,12,'7861000000012'),
(13,13,'7861000000013'),(14,14,'7861000000014'),(15,15,'7861000000015'),(16,16,'7861000000016'),
(17,17,'7861000000017'),(18,18,'7861000000018'),(19,19,'7861000000019'),(20,20,'7861000000020');


-- 20. METODO_PAGO
DROP TABLE IF EXISTS metodo_pago CASCADE;
CREATE TABLE metodo_pago (
  id_metodo_pago SERIAL PRIMARY KEY,
  descripcion VARCHAR(50)
);

INSERT INTO metodo_pago (id_metodo_pago, descripcion) VALUES 
(1,'Efectivo'),(2,'Tarjeta debito'),(3,'Tarjeta credito'),(4,'Transferencia'),(5,'Cheque'),
(6,'Pago movil'),(7,'Billetera digital'),(8,'Credito interno'),(9,'Deposito'),(10,'PayPhone'),
(11,'Datafast'),(12,'Deuna'),(13,'PayPal'),(14,'Gift card'),(15,'Convenio'),
(16,'Cupon'),(17,'Pago mixto'),(18,'Retencion'),(19,'Anticipo'),(20,'Contra entrega');


-- 21. VENTA
DROP TABLE IF EXISTS venta CASCADE;
CREATE TABLE venta (
  id_venta SERIAL PRIMARY KEY,
  id_sucursal INT REFERENCES sucursal(id_sucursal),
  id_cliente INT REFERENCES cliente(id_cliente),
  id_empleado INT REFERENCES empleado(id_empleado),
  id_metodo_pago INT REFERENCES metodo_pago(id_metodo_pago),
  id_seguro INT REFERENCES convenio_seguro(id_seguro),
  fecha_venta TIMESTAMP
);
CREATE INDEX idx_venta_fecha ON venta(fecha_venta);

INSERT INTO venta (id_venta, id_sucursal, id_cliente, id_empleado, id_metodo_pago, id_seguro, fecha_venta) VALUES 
(1,1,1,1,1,1,'2026-01-01 15:03:00'),(2,2,2,2,2,2,'2026-02-02 15:06:00'),
(3,3,3,3,3,3,'2026-03-03 15:09:00'),(4,4,4,4,4,4,'2026-04-04 15:12:00'),
(5,5,5,5,5,5,'2026-05-05 15:15:00'),(6,6,6,6,6,6,'2026-06-06 15:18:00'),
(7,7,7,7,7,7,'2026-01-07 15:21:00'),(8,8,8,8,8,8,'2026-02-08 15:24:00'),
(9,9,9,9,9,9,'2026-03-09 15:27:00'),(10,10,10,10,10,10,'2026-04-10 15:30:00'),
(11,11,11,11,11,11,'2026-05-11 15:33:00'),(12,12,12,12,12,12,'2026-06-12 15:36:00'),
(13,13,13,13,13,13,'2026-01-13 15:39:00'),(14,14,14,14,14,14,'2026-02-14 15:42:00'),
(15,15,15,15,15,15,'2026-03-15 15:45:00'),(16,16,16,16,16,16,'2026-04-16 15:48:00'),
(17,17,17,17,17,17,'2026-05-17 15:51:00'),(18,18,18,18,18,18,'2026-06-18 15:54:00'),
(19,19,19,19,19,19,'2026-01-19 15:57:00'),(20,20,20,20,20,20,'2026-02-20 15:00:00');


-- 22. DETALLE_VENTA
DROP TABLE IF EXISTS detalle_venta CASCADE;
CREATE TABLE detalle_venta (
  id_detalle_venta SERIAL PRIMARY KEY,
  id_venta INT REFERENCES venta(id_venta),
  codigo_barras VARCHAR(50) REFERENCES producto(codigo_barras),
  cantidad INT,
  precio_venta DECIMAL(10,2)
);

INSERT INTO detalle_venta (id_detalle_venta, id_venta, codigo_barras, cantidad, precio_venta) VALUES 
(1,1,'7861000000001',3,2.10),(2,2,'7861000000002',4,2.95),(3,3,'7861000000003',5,3.80),
(4,4,'7861000000004',2,4.65),(5,5,'7861000000005',3,5.50),(6,6,'7861000000006',4,6.35),
(7,7,'7861000000007',5,7.20),(8,8,'7861000000008',2,8.05),(9,9,'7861000000009',3,8.90),
(10,10,'7861000000010',4,9.75),(11,11,'7861000000011',5,10.60),(12,12,'7861000000012',2,11.45),
(13,13,'7861000000013',3,12.30),(14,14,'7861000000014',4,13.15),(15,15,'7861000000015',5,14.00),
(16,16,'7861000000016',2,14.85),(17,17,'7861000000017',3,15.70),(18,18,'7861000000018',4,16.55),
(19,19,'7861000000019',5,17.40),(20,20,'7861000000020',2,18.25);


-- 23. TIPO_PROVEEDOR
DROP TABLE IF EXISTS tipo_proveedor CASCADE;
CREATE TABLE tipo_proveedor (
  id_tipo_proveedor SERIAL PRIMARY KEY,
  descripcion VARCHAR(50)
);

INSERT INTO tipo_proveedor (id_tipo_proveedor, descripcion) VALUES 
(1,'Laboratorio'),(2,'Distribuidor'),(3,'Mayorista'),(4,'Importador'),(5,'Fabricante'),
(6,'Representante'),(7,'Comercializadora'),(8,'Operador logistico'),(9,'Proveedor local'),(10,'Proveedor nacional'),
(11,'Proveedor internacional'),(12,'Insumos medicos'),(13,'Productos naturales'),(14,'Material POP'),(15,'Tecnologia'),
(16,'Transporte'),(17,'Servicios'),(18,'Empaque'),(19,'Farmaceutico'),(20,'Consignacion');


-- 24. PROVEEDOR
DROP TABLE IF EXISTS proveedor CASCADE;
CREATE TABLE proveedor (
  id_proveedor SERIAL PRIMARY KEY,
  ruc_cedula VARCHAR(20) UNIQUE,
  nombre VARCHAR(150),
  telefono VARCHAR(20),
  correo VARCHAR(100),
  id_direccion INT REFERENCES direccion(id_direccion),
  id_tipo_proveedor INT REFERENCES tipo_proveedor(id_tipo_proveedor)
);
CREATE INDEX idx_proveedor_ruc ON proveedor(ruc_cedula);

INSERT INTO proveedor (id_proveedor, ruc_cedula, nombre, telefono, correo, id_direccion, id_tipo_proveedor) VALUES 
(1,'0992000000001','Proveedor Natura 01','04-260001','proveedor01@mail.com',1,1),
(2,'0992000000002','Proveedor Natura 02','04-260002','proveedor02@mail.com',2,2),
(3,'0992000000003','Proveedor Natura 03','04-260003','proveedor03@mail.com',3,3),
(4,'0992000000004','Proveedor Natura 04','04-260004','proveedor04@mail.com',4,4),
(5,'0992000000005','Proveedor Natura 05','04-260005','proveedor05@mail.com',5,5),
(6,'0992000000006','Proveedor Natura 06','04-260006','proveedor06@mail.com',6,6),
(7,'0992000000007','Proveedor Natura 07','04-260007','proveedor07@mail.com',7,7),
(8,'0992000000008','Proveedor Natura 08','04-260008','proveedor08@mail.com',8,8),
(9,'0992000000009','Proveedor Natura 09','04-260009','proveedor09@mail.com',9,9),
(10,'0992000000010','Proveedor Natura 10','04-260010','proveedor10@mail.com',10,10),
(11,'0992000000011','Proveedor Natura 11','04-260011','proveedor11@mail.com',11,11),
(12,'0992000000012','Proveedor Natura 12','04-260012','proveedor12@mail.com',12,12),
(13,'0992000000013','Proveedor Natura 13','04-260013','proveedor13@mail.com',13,13),
(14,'0992000000014','Proveedor Natura 14','04-260014','proveedor14@mail.com',14,14),
(15,'0992000000015','Proveedor Natura 15','04-260015','proveedor15@mail.com',15,15),
(16,'0992000000016','Proveedor Natura 16','04-260016','proveedor16@mail.com',16,16),
(17,'0992000000017','Proveedor Natura 17','04-260017','proveedor17@mail.com',17,17),
(18,'0992000000018','Proveedor Natura 18','04-260018','proveedor18@mail.com',18,18),
(19,'0992000000019','Proveedor Natura 19','04-260019','proveedor19@mail.com',19,19),
(20,'0992000000020','Proveedor Natura 20','04-260020','proveedor20@mail.com',20,20);


-- 25. COMPRA
DROP TABLE IF EXISTS compra CASCADE;
CREATE TABLE compra (
  id_compra SERIAL PRIMARY KEY,
  id_proveedor INT REFERENCES proveedor(id_proveedor),
  id_sucursal INT REFERENCES sucursal(id_sucursal),
  fecha_compra TIMESTAMP
);

INSERT INTO compra (id_compra, id_proveedor, id_sucursal, fecha_compra) VALUES 
(1,1,1,'2026-01-01 09:02:00'),(2,2,2,'2026-02-02 09:04:00'),
(3,3,3,'2026-03-03 09:06:00'),(4,4,4,'2026-04-04 09:08:00'),
(5,5,5,'2026-05-05 09:10:00'),(6,6,6,'2026-06-06 09:12:00'),
(7,7,7,'2026-01-07 09:14:00'),(8,8,8,'2026-02-08 09:16:00'),
(9,9,9,'2026-03-09 09:18:00'),(10,10,10,'2026-04-10 09:20:00'),
(11,11,11,'2026-05-11 09:22:00'),(12,12,12,'2026-06-12 09:24:00'),
(13,13,13,'2026-01-13 09:26:00'),(14,14,14,'2026-02-14 09:28:00'),
(15,15,15,'2026-03-15 09:30:00'),(16,16,16,'2026-04-16 09:32:00'),
(17,17,17,'2026-05-17 09:34:00'),(18,18,18,'2026-06-18 09:36:00'),
(19,19,19,'2026-01-19 09:38:00'),(20,20,20,'2026-02-20 09:40:00');


-- 26. DETALLE_COMPRA
DROP TABLE IF EXISTS detalle_compra CASCADE;
CREATE TABLE detalle_compra (
  id_detalle_compra SERIAL PRIMARY KEY,
  id_compra INT REFERENCES compra(id_compra),
  codigo_barras VARCHAR(50) REFERENCES producto(codigo_barras),
  cantidad INT,
  precio_compra DECIMAL(10,2)
);

INSERT INTO detalle_compra (id_detalle_compra, id_compra, codigo_barras, cantidad, precio_compra) VALUES 
(1,1,'7861000000001',41,1.55),(2,2,'7861000000002',42,2.15),(3,3,'7861000000003',43,2.75),
(4,4,'7861000000004',44,3.35),(5,5,'7861000000005',45,3.95),(6,6,'7861000000006',46,4.55),
(7,7,'7861000000007',47,5.15),(8,8,'7861000000008',48,5.75),(9,9,'7861000000009',49,6.35),
(10,10,'7861000000010',50,6.95),(11,11,'7861000000011',51,7.55),(12,12,'7861000000012',52,8.15),
(13,13,'7861000000013',53,8.75),(14,14,'7861000000014',54,9.35),(15,15,'7861000000015',55,9.95),
(16,16,'7861000000016',56,10.55),(17,17,'7861000000017',57,11.15),(18,18,'7861000000018',58,11.75),
(19,19,'7861000000019',59,12.35),(20,20,'7861000000020',60,12.95);


-- 27. ESTADO_TRANSFERENCIA
DROP TABLE IF EXISTS estado_transferencia CASCADE;
CREATE TABLE estado_transferencia (
  id_estado SERIAL PRIMARY KEY,
  descripcion VARCHAR(50)
);

INSERT INTO estado_transferencia (id_estado, descripcion) VALUES 
(1,'Solicitada'),(2,'Aprobada'),(3,'En preparacion'),(4,'Despachada'),(5,'En ruta'),
(6,'Recibida'),(7,'Parcial'),(8,'Rechazada'),(9,'Cancelada'),(10,'Cerrada'),
(11,'Pendiente stock'),(12,'Validada'),(13,'Observada'),(14,'Reprogramada'),(15,'Devuelta'),
(16,'En revision'),(17,'Autorizada'),(18,'Facturada'),(19,'Completada'),(20,'Archivada');


-- 28. TRANSFERENCIA
DROP TABLE IF EXISTS transferencia CASCADE;
CREATE TABLE transferencia (
  id_transferencia SERIAL PRIMARY KEY,
  sucursal_origen INT REFERENCES sucursal(id_sucursal),
  sucursal_destino INT REFERENCES sucursal(id_sucursal),
  id_estado INT REFERENCES estado_transferencia(id_estado),
  fecha_transferencia TIMESTAMP
);

INSERT INTO transferencia (id_transferencia, sucursal_origen, sucursal_destino, id_estado, fecha_transferencia) VALUES 
(1,1,2,1,'2026-01-01 11:04:00'),(2,2,3,2,'2026-02-02 11:08:00'),
(3,3,4,3,'2026-03-03 11:12:00'),(4,4,5,4,'2026-04-04 11:16:00'),
(5,5,6,5,'2026-05-05 11:20:00'),(6,6,7,6,'2026-06-06 11:24:00'),
(7,7,8,7,'2026-01-07 11:28:00'),(8,8,9,8,'2026-02-08 11:32:00'),
(9,9,10,9,'2026-03-09 11:36:00'),(10,10,11,10,'2026-04-10 11:40:00'),
(11,11,12,11,'2026-05-11 11:44:00'),(12,12,13,12,'2026-06-12 11:48:00'),
(13,13,14,13,'2026-01-13 11:52:00'),(14,14,15,14,'2026-02-14 11:56:00'),
(15,15,16,15,'2026-03-15 11:00:00'),(16,16,17,16,'2026-04-16 11:04:00'),
(17,17,18,17,'2026-05-17 11:08:00'),(18,18,19,18,'2026-06-18 11:12:00'),
(19,19,20,19,'2026-01-19 11:16:00'),(20,20,1,20,'2026-02-20 11:20:00');


-- 29. DETALLE_TRANSFERENCIA
DROP TABLE IF EXISTS detalle_transferencia CASCADE;
CREATE TABLE detalle_transferencia (
  id_detalle_transferencia SERIAL PRIMARY KEY,
  id_transferencia INT REFERENCES transferencia(id_transferencia),
  codigo_barras VARCHAR(50) REFERENCES producto(codigo_barras),
  cantidad INT
);

INSERT INTO detalle_transferencia (id_detalle_transferencia, id_transferencia, codigo_barras, cantidad) VALUES 
(1,1,'7861000000001',6),(2,2,'7861000000002',7),(3,3,'7861000000003',8),
(4,4,'7861000000004',9),(5,5,'7861000000005',10),(6,6,'7861000000006',11),
(7,7,'7861000000007',12),(8,8,'7861000000008',13),(9,9,'7861000000009',14),
(10,10,'7861000000010',15),(11,11,'7861000000011',16),(12,12,'7861000000012',17),
(13,13,'7861000000013',18),(14,14,'7861000000014',19),(15,15,'7861000000015',20),
(16,16,'7861000000016',21),(17,17,'7861000000017',22),(18,18,'7861000000018',23),
(19,19,'7861000000019',24),(20,20,'7861000000020',25);


-- 30. VENTANILLA
DROP TABLE IF EXISTS ventanilla CASCADE;
CREATE TABLE ventanilla (
  id_ventanilla SERIAL PRIMARY KEY,
  numero INT NOT NULL,
  id_sucursal INT NOT NULL REFERENCES sucursal(id_sucursal)
);

INSERT INTO ventanilla (id_ventanilla, numero, id_sucursal) VALUES 
(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,1,6),(7,2,7),(8,3,8),(9,4,9),(10,5,10),
(11,1,11),(12,2,12),(13,3,13),(14,4,14),(15,5,15),(16,1,16),(17,2,17),(18,3,18),(19,4,19),(20,5,20);


-- ------------------------------------------------------
-- SINCRONIZACIÓN DE SECUENCIAS
-- (Requerido al insertar IDs numéricos manualmente en campos SERIAL)
-- ------------------------------------------------------
SELECT setval(pg_get_serial_sequence('provincia', 'id_provincia'), (SELECT MAX(id_provincia) FROM provincia));
SELECT setval(pg_get_serial_sequence('ciudad', 'id_ciudad'), (SELECT MAX(id_ciudad) FROM ciudad));
SELECT setval(pg_get_serial_sequence('direccion', 'id_direccion'), (SELECT MAX(id_direccion) FROM direccion));
SELECT setval(pg_get_serial_sequence('matriz', 'id_matriz'), (SELECT MAX(id_matriz) FROM matriz));
SELECT setval(pg_get_serial_sequence('sucursal', 'id_sucursal'), (SELECT MAX(id_sucursal) FROM sucursal));
SELECT setval(pg_get_serial_sequence('tipo_empleado', 'id_tipo_empleado'), (SELECT MAX(id_tipo_empleado) FROM tipo_empleado));
SELECT setval(pg_get_serial_sequence('empleado', 'id_empleado'), (SELECT MAX(id_empleado) FROM empleado));
SELECT setval(pg_get_serial_sequence('categoria_producto', 'id_categoria'), (SELECT MAX(id_categoria) FROM categoria_producto));
SELECT setval(pg_get_serial_sequence('unidad_medida', 'id_unidad'), (SELECT MAX(id_unidad) FROM unidad_medida));
SELECT setval(pg_get_serial_sequence('laboratorio', 'id_laboratorio'), (SELECT MAX(id_laboratorio) FROM laboratorio));
SELECT setval(pg_get_serial_sequence('lote_producto', 'id_lote'), (SELECT MAX(id_lote) FROM lote_producto));
SELECT setval(pg_get_serial_sequence('inventario', 'id_inventario'), (SELECT MAX(id_inventario) FROM inventario));
SELECT setval(pg_get_serial_sequence('tipo_cliente', 'id_tipo_cliente'), (SELECT MAX(id_tipo_cliente) FROM tipo_cliente));
SELECT setval(pg_get_serial_sequence('cliente', 'id_cliente'), (SELECT MAX(id_cliente) FROM cliente));
SELECT setval(pg_get_serial_sequence('convenio_seguro', 'id_seguro'), (SELECT MAX(id_seguro) FROM convenio_seguro));
SELECT setval(pg_get_serial_sequence('medico', 'id_medico'), (SELECT MAX(id_medico) FROM medico));
SELECT setval(pg_get_serial_sequence('receta_medica', 'id_receta'), (SELECT MAX(id_receta) FROM receta_medica));
SELECT setval(pg_get_serial_sequence('detalle_receta', 'id_detalle_receta'), (SELECT MAX(id_detalle_receta) FROM detalle_receta));
SELECT setval(pg_get_serial_sequence('metodo_pago', 'id_metodo_pago'), (SELECT MAX(id_metodo_pago) FROM metodo_pago));
SELECT setval(pg_get_serial_sequence('venta', 'id_venta'), (SELECT MAX(id_venta) FROM venta));
SELECT setval(pg_get_serial_sequence('detalle_venta', 'id_detalle_venta'), (SELECT MAX(id_detalle_venta) FROM detalle_venta));
SELECT setval(pg_get_serial_sequence('tipo_proveedor', 'id_tipo_proveedor'), (SELECT MAX(id_tipo_proveedor) FROM tipo_proveedor));
SELECT setval(pg_get_serial_sequence('proveedor', 'id_proveedor'), (SELECT MAX(id_proveedor) FROM proveedor));
SELECT setval(pg_get_serial_sequence('compra', 'id_compra'), (SELECT MAX(id_compra) FROM compra));
SELECT setval(pg_get_serial_sequence('detalle_compra', 'id_detalle_compra'), (SELECT MAX(id_detalle_compra) FROM detalle_compra));
SELECT setval(pg_get_serial_sequence('estado_transferencia', 'id_estado'), (SELECT MAX(id_estado) FROM estado_transferencia));
SELECT setval(pg_get_serial_sequence('transferencia', 'id_transferencia'), (SELECT MAX(id_transferencia) FROM transferencia));
SELECT setval(pg_get_serial_sequence('detalle_transferencia', 'id_detalle_transferencia'), (SELECT MAX(id_detalle_transferencia) FROM detalle_transferencia));
SELECT setval(pg_get_serial_sequence('ventanilla', 'id_ventanilla'), (SELECT MAX(id_ventanilla) FROM ventanilla));

COMMIT;