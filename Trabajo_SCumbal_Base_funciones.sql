create database tienda_online;
use tienda_online;
create table clientes (
    id int auto_increment primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) unique not null,
    telefono varchar(15),
    fecha_registro date not null
);
create table productos (
    id int auto_increment primary key,
    nombre varchar(100) unique not null,
    precio decimal(10, 2) check (precio > 0) not null,
    stock int check (stock >= 0) not null,
    descripcion text
);
create table pedidos (
    id int auto_increment primary key,
    cliente_id int not null,
    fecha_pedido date not null,
    total decimal(10, 2),
    foreign key (cliente_id) references clientes(id)
);
create table detalles_pedido (
    id int auto_increment primary key,
    pedido_id int not null,
    producto_id int not null,
    cantidad int check (cantidad > 0) not null,
    precio_unitario decimal(10, 2) not null,
    foreign key (pedido_id) references pedidos(id),
    foreign key (producto_id) references productos(id)
);

insert into clientes (nombre, apellido, email, telefono, fecha_registro) values
('Juan', 'Pérez', 'juan.perez@hotmail.com', '1234567890', '2023-01-15'),
('Ana', 'Gómez', 'ana.gomez@hotmail.com', '0987654321', '2023-03-20'),
('Luis', 'Martínez', 'luis.martinez@hotmail.com', '1112223334', '2022-12-10'),
('María', 'López', 'maria.lopez@hotmail.com', '4445556667', '2023-05-25'),
('Carlos', 'Hernández', 'carlos.hernandez@hotmail.com', '7778889990', '2023-07-30');

insert into productos (nombre, precio, stock, descripcion) values
('Laptop', 800.00, 10, 'Laptop de alto rendimiento para trabajo y juegos.'),
('Smartphone', 500.00, 15, 'Teléfono inteligente con gran cámara y batería duradera.'),
('Auriculares', 50.00, 25, 'Auriculares inalámbricos con cancelación de ruido.'),
('Monitor', 150.00, 8, 'Monitor Full HD de 24 pulgadas para trabajo y entretenimiento.'),
('Teclado', 30.00, 20, 'Teclado mecánico RGB para gaming.');

insert into pedidos (cliente_id, fecha_pedido, total) values
(1, '2023-08-01', 850.00),
(2, '2023-08-05', 150.00),
(3, '2023-08-10', 200.00),
(4, '2023-08-12', 530.00),
(5, '2023-08-15', 1000.00);

insert into detalles_pedido (pedido_id, producto_id, cantidad, precio_unitario) values
(1, 1, 1, 800.00),
(1, 3, 1, 50.00),
(2, 4, 1, 150.00),
(3, 5, 4, 30.00),
(4, 2, 1, 500.00),
(4, 3, 1, 30.00),
(5, 1, 1, 800.00),
(5, 2, 1, 200.00);

delimiter //
create function obtener_nombre_completo(cliente_id int) 
returns varchar(101)
deterministic
begin
    declare nombre_completo varchar(101);
    select concat(nombre, ' ', apellido) into nombre_completo
    from clientes
    where id = cliente_id;
    return nombre_completo;
end;//
delimiter ;

delimiter //
create function calcular_descuento(precio decimal(10, 2), descuento decimal(5, 2)) 
returns decimal(10, 2)
deterministic
begin
    return precio - (precio * descuento / 100);
end;//
delimiter ;

delimiter //
create function calcular_total_pedido(pedido_id int) 
returns decimal(10, 2)
deterministic
begin
    declare total decimal(10, 2);
    select sum(cantidad * precio_unitario) into total
    from detalles_pedido
    where pedido_id = pedido_id;
    return total;
end;//
delimiter ;

delimiter //
create function verificar_stock(producto_id int, cantidad int) 
returns boolean
deterministic
begin
    declare disponible boolean;
    select stock >= cantidad into disponible
    from productos
    where id = producto_id;
    return disponible;
end;//
delimiter ;

delimiter //
create function calcular_antiguedad(cliente_id int) 
returns int
deterministic
begin
    declare antiguedad int;
    select timestampdiff(year, fecha_registro, curdate()) into antiguedad
    from clientes
    where id = cliente_id;
    return antiguedad;
end;//
delimiter ;

select obtener_nombre_completo(1);

select calcular_descuento(100.00, 10);

select calcular_total_pedido(1);

select verificar_stock(1, 5);

select calcular_antiguedad(1);


-- Parte 2
delimiter //
create function calcular_total_orden(id_orden int)
returns decimal(10, 2)
deterministic
begin
    declare total decimal(10, 2);
    declare iva decimal(10, 2);
    set iva = 0.15;
    select sum(p.precio * o.cantidad) into total
    from ordenes o
    join productos p on o.producto_id = p.productoid
    where o.ordenid = id_orden;
    set total = total + (total * iva);
    return total;
end //
delimiter ;

delimiter $$
create function calcular_edad(fecha_nacimiento date)
returns int
deterministic
begin
    declare edad int;
    set edad = timestampdiff(year, fecha_nacimiento, curdate());
    return edad;
end $$
delimiter ;

delimiter $$
create function verificar_stock(producto_id int)
returns boolean
deterministic
begin
    declare stock int;

    select existencia into stock
    from productos
    where productoid = producto_id;

    if stock > 0 then
        return true;
    else
        return false;
    end if;
end $$
delimiter ;
