drop database if exists panaderiasanjuan;
create database panaderiasanjuan;
use panaderiasanjuan;

create table cliente (
	id_cliente int not null auto_increment,
	nombres varchar(100) default null,
	apellidos varchar(100) default null,
	dni varchar(100) default null,
	telefono varchar(100) default null,
	direccion varchar(100) default null,
	primary key(id_cliente)
) Engine = InnoDB;

create table pedido (
	id_pedido int not null auto_increment,
	observacion varchar(100) default null,
	adelanto decimal(5, 2) default 0,
	hora_recepcion timestamp default current_timestamp,
	hora_entrega timestamp default null,
	primary key(id_pedido),
	id_cliente int,
	foreign key(id_cliente) references cliente(id_cliente) on delete cascade
) Engine = InnoDB;

create table fuente (
	id_fuente int not null auto_increment,
	descripcion varchar(100) default null,
	costo decimal(5, 2) not null,
	primary key(id_fuente),
	id_pedido int,
	foreign key(id_pedido) references pedido(id_pedido) on delete cascade
) Engine = InnoDB;

insert into cliente(nombres, dni) values("Juan", "x");
insert into cliente(nombres, dni) values("Paco", "y");
insert into cliente(nombres, dni) values("Luciana", "z");

insert into pedido(observacion, id_cliente) values("pedido 1", 1);
insert into pedido(observacion, id_cliente) values("pedido 2", 2);
insert into pedido(observacion, id_cliente) values("pedido 3", 3);

insert into fuente(descripcion, costo, id_pedido) values("f1-1", 15.26, 1);
insert into fuente(descripcion, costo, id_pedido) values("f2-1", 25.13, 1);

insert into fuente(descripcion, costo, id_pedido) values("f1-2", 8.54, 2);
insert into fuente(descripcion, costo, id_pedido) values("f2-2", 24.14, 2);
insert into fuente(descripcion, costo, id_pedido) values("f3-2", 11.01, 2);

insert into fuente(descripcion, costo, id_pedido) values("f1-3", 33.4, 3);

delimiter $$
create function calcular_costo_total(idpe int)
returns decimal(5, 2)
deterministic
begin
	declare var_costo_total decimal(5, 2) default 0;
	select sum(costo) into var_costo_total from fuente where id_pedido = idpe;
    return var_costo_total;
end$$
delimiter ;

delimiter $$
create procedure listar_pedidos()
begin
	select distinct
		P.id_pedido as numeropedido,
		concat(C.nombres, ' ', C.apellidos) as nombresyapellidos,
		concat('Teléfono: ', C.telefono, ', Direccion: ', C.direccion) as contacto,
		P.observacion,
		(select calcular_costo_total(P.id_pedido)) as costo_total,
		P.adelanto,
		(select calcular_costo_total(P.id_pedido)) - P.adelanto as adeuda,
		P.hora_recepcion,
		P.hora_entrega
	from cliente C, pedido P;
end$$
delimiter ;