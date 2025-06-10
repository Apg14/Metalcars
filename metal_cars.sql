CREATE DATABASE IF NOT EXISTS metal_cars;
USE metal_cars;

CREATE TABLE `sedes` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre_sede` VARCHAR(50),
  `direccion` VARCHAR(255),
  `telefono_contacto` VARCHAR(20)
);

CREATE TABLE `usuarios` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombres` VARCHAR(100),
  `apellido_paterno` VARCHAR(50),
  `apellido_materno` VARCHAR(50),
  `correo` VARCHAR(100) UNIQUE NOT NULL,
  `contrasenia` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20),
  `dni` VARCHAR(8),
  `estado` BOOLEAN
);

CREATE TABLE `roles` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50)
);

CREATE TABLE `usuario_rol` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT,
  `id_rol` INT
);

CREATE TABLE `colaboradores` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT
);

CREATE TABLE `conductores` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT,
  `ruc` VARCHAR(15)
);

CREATE TABLE `contribuyentes` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `ruc` VARCHAR(15) UNIQUE,
  `razon_social` VARCHAR(255),
  `id_usuario` INT
);

CREATE TABLE `vehiculos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT,
  `id_contribuyente` INT,
  `marca` VARCHAR(50),
  `modelo` VARCHAR(20),
  `anio` INT,
  `placa` VARCHAR(10),
  `color` VARCHAR(20)
);

CREATE TABLE `reparaciones` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_vehiculo` INT,
  `id_mecanico` INT,
  `estado` ENUM ('pendiente', 'en_proceso', 'finalizada', 'entregada', 'cancelada') NOT NULL,
  `fecha_ingreso` DATE,
  `fecha_programada` DATE,
  `fecha_estimada` DATE,
  `fecha_salida` DATE,
  `observaciones` TEXT,
  `kilometraje` INT,
  `nivel_combustible` VARCHAR(20),
  `exteriores` TEXT,
  `interiores` TEXT,
  `accesorios` TEXT,
  `otros` TEXT,
  `id_sede` INT,
  `id_asesor` INT
);

CREATE TABLE `detalle_reparaciones` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_reparacion` INT,
  `id_servicio` INT,
  `id_repuesto` INT,
  `cantidad` INT,
  `costo_unitario` DECIMAL(10,2),
  `total` DECIMAL(10,2)
);

CREATE TABLE `servicios` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50),
  `descripcion` TEXT,
  `precio` DECIMAL(10,2)
);

CREATE TABLE `proveedores` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `ruc` VARCHAR(15) UNIQUE NOT NULL,
  `razon_social` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(20),
  `correo` VARCHAR(100),
  `direccion` VARCHAR(255)
);

CREATE TABLE `repuestos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(20),
  `descripcion` TEXT,
  `precio_unitario` DECIMAL(10,2),
  `stock` INT,
  `id_proveedor` INT
);

CREATE TABLE `reservas` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT,
  `id_vehiculo` INT,
  `estado` ENUM ('pendiente', 'confirmada', 'cancelada') NOT NULL,
  `fecha_reserva` DATE,
  `hora_reserva` TIME,
  `comentario` TEXT,
  `id_sede` INT
);

CREATE TABLE `comprobante_pago` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT,
  `id_reparacion` INT,
  `id_contribuyente` INT,
  `fecha_emision` DATE,
  `monto_total` DECIMAL(10,2),
  `tipo_pago` VARCHAR(20),
  `tipo_comprobante` ENUM ('boleta', 'factura') NOT NULL,
  `id_cajero` INT
);

CREATE TABLE `detalle_comprobante` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_comprobante` INT,
  `id_servicio` INT,
  `id_repuesto` INT,
  `cantidad` INT,
  `precio_unitario` DECIMAL(10,2),
  `total` DECIMAL(10,2),
  `tipo_comprobante` ENUM ('boleta', 'factura')
);

ALTER TABLE `repuestos` ADD FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id`);

ALTER TABLE `usuario_rol` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `usuario_rol` ADD FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`);

ALTER TABLE `colaboradores` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `conductores` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `contribuyentes` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `vehiculos` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `vehiculos` ADD FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id`);

ALTER TABLE `reparaciones` ADD FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id`);

ALTER TABLE `reparaciones` ADD FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

ALTER TABLE `reparaciones` ADD FOREIGN KEY (`id_asesor`) REFERENCES `colaboradores` (`id`);

ALTER TABLE `reparaciones` ADD FOREIGN KEY (`id_mecanico`) REFERENCES `usuarios` (`id`);

ALTER TABLE `detalle_reparaciones` ADD FOREIGN KEY (`id_reparacion`) REFERENCES `reparaciones` (`id`);

ALTER TABLE `detalle_reparaciones` ADD FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id`);

ALTER TABLE `detalle_reparaciones` ADD FOREIGN KEY (`id_repuesto`) REFERENCES `repuestos` (`id`);

ALTER TABLE `reservas` ADD FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id`);

ALTER TABLE `reservas` ADD FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

ALTER TABLE `reservas` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `comprobante_pago` ADD FOREIGN KEY (`id_reparacion`) REFERENCES `reparaciones` (`id`);

ALTER TABLE `comprobante_pago` ADD FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id`);

ALTER TABLE `comprobante_pago` ADD FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

ALTER TABLE `comprobante_pago` ADD FOREIGN KEY (`id_cajero`) REFERENCES `colaboradores` (`id`);

ALTER TABLE `detalle_comprobante` ADD FOREIGN KEY (`id_comprobante`) REFERENCES `comprobante_pago` (`id`);

ALTER TABLE `detalle_comprobante` ADD FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id`);

ALTER TABLE `detalle_comprobante` ADD FOREIGN KEY (`id_repuesto`) REFERENCES `repuestos` (`id`);


-- Insertar datos de prueba en la tabla 'diagnostico'
INSERT INTO diagnostico (cliente, vehiculo, descripcion, mecanico) VALUES
('Carlos Pérez', 'Toyota Corolla', 'Frenos desgastados', NULL),
('Lucía Torres', 'Nissan Versa', 'Cambio de aceite', NULL),
('Juan Gómez', 'Nissan Frontier', 'Batería defectuosa', NULL),
('Andrea Ríos', 'Hyundai Accent', 'Sensor de oxígeno dañado', NULL),
('Marco Vidal', 'Kia Sportage', 'Fallo en sistema eléctrico', NULL);
SHOW TABLES;

-- Crear una sede
INSERT INTO sedes (nombre_sede, direccion, telefono_contacto) VALUES 
('Sede Lima Norte', 'Av. Universitaria 123', '987654321');

-- Crear usuarios (mecánico y asesor)
INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado) VALUES
('Luis', 'Mendoza', 'Gómez', 'luis@example.com', '123456', '999888777', '12345678', true),  -- mecánico (id = 1)
('Ana', 'Torres', 'Salas', 'ana@example.com', '123456', '998877665', '87654321', true);     -- asesor (id = 2)

-- Asociar roles (mecánico y asesor)
INSERT INTO roles (nombre) VALUES ('MECANICO'), ('ASESOR');

-- Relación de usuarios con roles
INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (1, 1), (2, 2);

-- Insertar colaboradores
INSERT INTO colaboradores (id_usuario) VALUES (2);

-- Insertar contribuyente
INSERT INTO contribuyentes (ruc, razon_social, id_usuario) VALUES 
('20304050601', 'Transportes San Juan SAC', 2);

-- Insertar vehículo
INSERT INTO vehiculos (id_usuario, id_contribuyente, marca, modelo, anio, placa, color) VALUES
(2, 1, 'Toyota', 'Corolla', 2020, 'ABC123', 'Rojo');

-- Insertar una reparación
INSERT INTO reparaciones (
  id_vehiculo, id_mecanico, estado, fecha_ingreso, fecha_programada, fecha_estimada, fecha_salida,
  observaciones, kilometraje, nivel_combustible, exteriores, interiores, accesorios, otros,
  id_sede, id_asesor
) VALUES (
  1, 1, 'pendiente', '2025-06-09', '2025-06-10', '2025-06-15', NULL,
  'Observaciones de prueba', 45000, 'Medio tanque', 'Rayón leve en parachoque', 'Buen estado', 'Sin accesorios', 'N/A',
  1, 1
);

USE metal_cars;
SELECT * FROM mecanico;

INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado)
VALUES 
('Juan', 'Rodríguez', 'Lozano', 'juan@metalcars.com', '123456', '987654321', '10000001', true),
('Luis', 'Mendoza', 'García', 'luis@metalcars.com', '123456', '987654322', '10000002', true),
('Pedro', 'Salas', 'Vera', 'pedro@metalcars.com', '123456', '987654323', '10000003', true),
('Laura', 'Chávez', 'Paredes', 'laura@metalcars.com', '123456', '987654324', '10000004', true),
('Sofía', 'Ramírez', 'Ríos', 'sofia@metalcars.com', '123456', '987654325', '10000005', true);

-- Relacionar esos usuarios con el rol MECANICO
INSERT INTO usuario_rol (id_usuario, id_rol)
VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1);  -- reemplaza con los ID reales si es necesario


INSERT INTO roles (id, nombre) VALUES
(1, 'Mecanico'),
(2, 'Administrador'),
(3, 'Gerente de Sede');

SELECT * FROM usuarios WHERE id_rol = 1;

INSERT INTO roles (id, nombre) VALUES
(1, 'Mecánico'),
(2, 'Administrador'),
(3, 'Gerente de Sede');

INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado, id_rol) VALUES
('Juan', 'Pérez', 'Gómez', 'juan.perez@metalcars.com', '123456', '987654321', '12345678', 1, 1),
('Luis', 'Ramírez', 'Torres', 'luis.ramirez@metalcars.com', '123456', '987654322', '87654321', 1, 1),
('María', 'López', 'Quispe', 'maria.lopez@metalcars.com', '123456', '987654323', '11223344', 1, 1);

SELECT * FROM usuarios WHERE id_rol = 1;
SELECT * FROM diagnosticos WHERE id_mecanico IS NULL;
INSERT INTO diagnosticos (cliente, descripcion, fecha, id_mecanico, vehiculo)
VALUES 
('Harold Morales', 'Cambio de frenos', NOW(), NULL, 'Toyota Corolla'),
('Cristina Munoz', 'Ruido en el motor', NOW(), NULL, 'Hyundai Accent'),
('Adriel Gonzales', 'Cambio de aceite', NOW(), NULL, 'Chevrolet Camaro');

SELECT DISTINCT id_rol FROM usuarios WHERE id_rol NOT IN (SELECT id FROM roles);
SHOW CREATE TABLE reparaciones;
SHOW CREATE TABLE detalle_reparaciones;
SHOW CREATE TABLE usuarios;
SHOW CREATE TABLE roles;

SELECT id, id_mecanico, estado FROM reparaciones WHERE id_mecanico IS NOT NULL;

INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado)
VALUES ('José', 'Flores', 'Gomez', 'jose.flores@metalcars.com', '21254556', '987775566', '74845655', true);

SELECT LAST_INSERT_ID();

INSERT INTO usuario_rol (id_usuario, id_rol)
VALUES (13, 1);
 
SELECT id FROM reparaciones;
INSERT INTO reparaciones (id_vehiculo, id_mecanico, estado, fecha_ingreso, id_sede, id_asesor)
VALUES 
(1, NULL, 'pendiente', CURDATE(), 1, 1),
(1, NULL, 'pendiente', CURDATE(), 1, 1),
(1, NULL, 'pendiente', CURDATE(), 1, 1);

SELECT id, placa, id_usuario FROM vehiculos;

INSERT INTO usuarios (id, nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado)
VALUES 
(23, 'Renato', 'Gómez', '', 'renato@example.com', '1234', '999111111', '12345678', 1),
(24, 'Adriel', 'Díaz', '', 'adriel@example.com', '1234', '999222222', '22345678', 1),
(25, 'Harold', 'Morales', '', 'harold@example.com', '1234', '999333333', '32345678', 1),
(26, 'Cristina', 'Munoz', '', 'cristina@example.com', '1234', '999444444', '42345678', 1),
(27, 'Adriel', 'Gonzales', '', 'gonzales@example.com', '1234', '999555555', '52345678', 1);

INSERT INTO vehiculos (id_usuario, id_contribuyente, marca, modelo, anio, placa, color)
VALUES 
(23, NULL, 'Hyundai', 'Accent', 2020, 'REN123', 'Blanco'),
(24, NULL, 'Kia', 'Picanto', 2021, 'ADR456', 'Negro'),
(25, NULL, 'Toyota', 'Corolla', 2019, 'HAR789', 'Gris'),
(26, NULL, 'Hyundai', 'Accent', 2020, 'CRI321', 'Rojo'),
(27, NULL, 'Chevrolet', 'Camaro', 2022, 'GON654', 'Azul');

INSERT INTO reparaciones (id_vehiculo, id_mecanico, estado, fecha_ingreso, id_sede, id_asesor, observaciones)
VALUES
(7, NULL, 'pendiente', CURDATE(), 1, 1, 'Ruido en el motor'),
(8, NULL, 'pendiente', CURDATE(), 1, 1, 'Cambio de aceite'),
(9, NULL, 'pendiente', CURDATE(), 1, 1, 'Cambio de frenos'),
(10, NULL, 'pendiente', CURDATE(), 1, 1, 'Ruido en el motor'),
(11, NULL, 'pendiente', CURDATE(), 1, 1, 'Cambio de aceite');

SELECT id, id_usuario, placa FROM vehiculos;

SELECT id, id_vehiculo, id_mecanico, estado FROM reparaciones WHERE id_mecanico IS NOT NULL;



INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado)
VALUES
('Lucía', 'Ramírez', '', 'lucia.ramirez@clientes.com', '1234', '987123123', '70000001', 1),
('Carlos', 'Salas', '', 'carlos.salas@clientes.com', '1234', '987123124', '70000002', 1);


INSERT INTO vehiculos (id_usuario, id_contribuyente, marca, modelo, anio, placa, color)
VALUES
((SELECT id FROM usuarios WHERE correo = 'lucia.ramirez@clientes.com'), NULL, 'Nissan', 'Versa', 2021, 'LUC001', 'Negro'),
((SELECT id FROM usuarios WHERE correo = 'carlos.salas@clientes.com'), NULL, 'Mazda', 'CX-3', 2022, 'CAR002', 'Rojo');

-- Insertar reparaciones pendientes
INSERT INTO reparaciones (id_vehiculo, id_mecanico, estado, fecha_ingreso, id_sede, id_asesor, observaciones)
VALUES
((SELECT id FROM vehiculos WHERE placa = 'LUC001'), NULL, 'pendiente', CURDATE(), 1, 1, 'Ruidos al frenar'),
((SELECT id FROM vehiculos WHERE placa = 'CAR002'), NULL, 'pendiente', CURDATE(), 1, 1, 'Fuga de aceite');

-- Insertar mecánicos
INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, correo, contrasenia, telefono, dni, estado)
VALUES
('Wilfredo', 'Cubas', '', 'wilfredo.cubas@mecanicos.com', '1234', '985236147', '98775655', 1),
('Luis', 'Jimenez', '', 'luis.jimenez@mecanicos.com', '1234', '986532157', '98523641', 1);

INSERT INTO usuario_rol (id_usuario, id_rol)
VALUES
((SELECT id FROM usuarios WHERE correo = 'wilfredo.cubas@mecanicos.com'), 1),
((SELECT id FROM usuarios WHERE correo = 'luis.jimenez@mecanicos.com'), 1);

SELECT 
    r.id AS id_reparacion,
    r.estado,
    r.fecha_ingreso,
    r.observaciones,
    v.marca,
    v.modelo,
    u_cliente.nombres AS cliente,
    u_mecanico.nombres AS mecanico
FROM reparaciones r
JOIN vehiculos v ON r.id_vehiculo = v.id
JOIN usuarios u_cliente ON v.id_usuario = u_cliente.id
JOIN usuarios u_mecanico ON r.id_mecanico = u_mecanico.id
WHERE r.id_mecanico IS NOT NULL;

SELECT 
    r.id, r.estado, v.placa, u.nombres AS cliente
FROM reparaciones r
JOIN vehiculos v ON r.id_vehiculo = v.id
JOIN usuarios u ON v.id_usuario = u.id
WHERE r.id_mecanico IS NULL;

SELECT u.id, u.nombres, u.apellido_paterno
FROM usuarios u
JOIN usuario_rol ur ON u.id = ur.id_usuario
WHERE ur.id_rol = 1; -- 1 = rol MECÁNICO