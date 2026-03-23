use `mydb`; 

-- ==========================================
-- 1. CONSULTAS (Multitabla, subconsultas y agrupaciones)
-- ==========================================

-- Consulta 1: Servicios adicionales solicitados en check-in
select c.nombre, h.numero, h.tipo, e.nombre as nombre_extra, ea.cantidad, r.estado
from cliente c
join reserva r on c.dni = r.cliente_dni
join reserva_habitacion rh on r.idreserva = rh.reserva_idreserva
join habitacion h on rh.habitacion_idhabitacion = h.idhabitacion
join extra_asignado ea on r.idreserva = ea.reserva_habitacion_reserva_idreserva
join extras e on ea.extras_idextras = e.idextras
where r.estado = 'check-in';

-- Consulta 2: Ingresos agrupados por fecha
select date(p.fecha) as dia, count(*) as num_transacciones, sum(p.cantidad) as total_dia
from pago p
group by date(p.fecha)
order by dia;

-- Consulta 3: Habitaciones con precio mayor a la media (subconsulta)
select h.numero, h.tipo, h.precio_noche
from habitacion h
where h.precio_noche > (select avg(precio_noche) from habitacion);

-- Consulta 4: Duración de reservas en días
select r.cliente_dni, r.fecha_entrada, r.fecha_salida,
       datediff(r.fecha_salida, r.fecha_entrada) as noches
from reserva r;

-- Consulta 5: Facturas y reservas gestionadas por empleado
select e.nombre as nombre_empleado, e.cargo, r.idreserva, f.idfactura, f.fecha_emision
from empleado e
join reserva r on e.dni = r.empleado_dni
join factura f on r.idreserva = f.reserva_idreserva
order by e.cargo;


-- ==========================================
-- 2. VISTAS
-- ==========================================

-- Vista 1: Habitaciones pendientes de limpiar o mantener
create view vista_limpieza_urgente as
select numero, tipo, planta, estado
from habitacion
where estado in ('sucia', 'mantenimiento');

-- Vista 2: Facturas con pagos superiores a 90 (VIP)
create view vista_pagos_vip as
select f.idfactura, f.fecha_emision, p.cantidad
from factura f
join pago p on f.idfactura = p.factura_idfactura
where p.cantidad > 90;


-- ==========================================
-- 3. FUNCIONES
-- ==========================================
delimiter //

create function fn_calcular_dias(p_fecha_entrada datetime, p_fecha_salida datetime)
returns int
deterministic
begin
    if p_fecha_entrada >= p_fecha_salida then
        signal sqlstate '45000'
        set message_text = 'error: la fecha de entrada debe ser menor a la fecha de salida.';
    end if;
    
    return datediff(p_fecha_salida, p_fecha_entrada);
end //
delimiter ;

-- PRUEBA DE LA FUNCIÓN 1:
-- select fn_calcular_dias('2026-10-10', '2026-10-15');


delimiter //
create function fn_total_pagado_factura(p_idfactura int)
returns decimal(10,2)
deterministic
begin
    declare v_total decimal(10,2);
    declare v_existe int;

    -- comprobar si la factura existe
    select count(*) into v_existe from FACTURA f  where idfactura = p_idfactura;

    if v_existe = 0 then
        signal sqlstate '45000'
        set message_text = 'error: la factura indicada no existe en la base de datos.';
    end if;

    -- calcular el total
    select ifnull(sum(cantidad), 0) into v_total
    from PAGO p
    where factura_idfactura = p_idfactura;

    return v_total;
end //
delimiter ;

-- PRUEBA DE LA FUNCIÓN 2:
-- select fn_total_pagado_factura(1);


-- ==========================================
-- 4. PROCEDIMIENTOS
-- ==========================================
delimiter //

create procedure sp_crear_cliente(
    in p_dni varchar(9),
    in p_nombre varchar(20),
    in p_apellidos varchar(40),
    in p_telefono varchar(12),
    in p_email varchar(30),
    in p_direccion varchar(45)
)
begin
    insert into CLIENTE (dni, nombre, apellidos, telefono, email, direccion)
    values (p_dni, p_nombre, p_apellidos, p_telefono, p_email, p_direccion);
end //
delimiter ;

-- PRUEBA DEL PROCEDIMIENTO 1:
-- call sp_crear_cliente("12345679E", "Saul", "Rodriguez", "34642098240", "saul@gmail.com", "BOLLULLOS CITY");


delimiter //
create procedure sp_mostrar_total_factura(in p_idfactura int)
begin
    select idfactura, 
           fecha_emision, 
           fn_total_pagado_factura(p_idfactura) as total_pagado
    from FACTURA
    where idfactura = p_idfactura;
end //
delimiter ;

-- PRUEBA DEL PROCEDIMIENTO 2 (HACE USO DE LA FUNCIÓN):
-- call sp_mostrar_total_factura(1);


delimiter //
create procedure sp_cancelar_reserva(in p_idreserva int)
begin
    update RESERVA
    set estado = 'cancelada'
    where idreserva = p_idreserva;
end //
delimiter ;

-- PRUEBA DEL PROCEDIMIENTO 3:
-- call sp_cancelar_reserva(15);
-- select * from RESERVA r where r.idRESERVA = 15;


-- ==========================================
-- 5. TRIGGERS
-- ==========================================
delimiter //

create trigger trg_verificar_pago_positivo before insert on PAGO
for each row
begin
    if new.cantidad <= 0 then
        signal sqlstate '45000'
        set message_text = 'error: la cantidad del pago debe ser mayor que cero.';
    end if;
end //
delimiter ;

-- PRUEBA DEL TRIGGER 1 (Saltará error intencionado):
-- insert into PAGO (idpago, fecha, cantidad, factura_idfactura) values (9999, now(), -50.00, 1);


delimiter //
create trigger trg_habitacion_sucia after update on RESERVA
for each row
begin
    if new.estado = 'check-out' and old.estado != 'check-out' then
        update HABITACION
        set estado = 'sucia'
        where idhabitacion in (
            select habitacion_idhabitacion
            from RESERVA_HABITACION
            where reserva_idreserva = new.idreserva
        );
    end if;
end //
delimiter ;

-- PRUEBA DEL TRIGGER 2:
-- 1º Vemos el estado inicial:
-- select r.idreserva, r.estado as estado_reserva, h.idhabitacion, h.estado as estado_habitacion from RESERVA r inner join RESERVA_HABITACION rh on r.idreserva = rh.reserva_idreserva inner join HABITACION h on rh.habitacion_idhabitacion = h.idhabitacion where r.idreserva = 5;
-- 2º Disparamos el trigger:
-- update RESERVA set estado = 'check-out' where idreserva = 5;
-- 3º Repetimos el SELECT del 1º paso para ver la habitación "sucia".