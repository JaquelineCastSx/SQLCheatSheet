CREATE DATABASE Pruebas;
use Pruebas;

CREATE TABLE productos(
id_prod int not null,
nombre_prod varchar(30) not null,
stock int not null,
estado varchar(40) not null,
precio double not null
);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(001, "Lavadora", 35, "Disponible", 4500);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(002, "Licuadora", 50, "Disponible", 1500);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(003, "Estufa", 12, "Disponible", 5500);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(004, "Aspiradora", 8, "En transito", 3500);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(005, "Plancha", 24, "Disponible", 2500);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(006, "Television", 31, "Disponible", 9500);

INSERT INTO productos (id_prod, nombre_prod, stock, estado, precio) 
VALUES(007, "PlayStation", 0, "Agotado", 10000);

SELECT * FROM productos;
DELIMITER 
CREATE PROCEDURE obtenerProductosPorEstado(IN nombre_estado VARCHAR(50)) 
BEGIN
	SELECT * 
    FROM productos
    WHERE estado = "Agotado";
END 

CALL obtenerProductosPorEstado("Agotado")

DELIMITER 
CREATE PROCEDURE contarProductosPorEstado(
IN nombre_estado VARCHAR(50),
OUT numero INT)
BEGIN 
	SELECT count(id_prod)
    INTO numero
    FROM productos
    WHERE estado = nombre_estado;
END

CALL contarProductosPorEstado("Agotado", @numero);
SELECT @numero AS agotados;
CALL contarProductosPorEstado("Disponible", @numero);
SELECT @numero AS disponibles;

DELIMITER //
CREATE PROCEDURE venderProducto(
	INOUT total INT,
	IN id_producto INT)
BEGIN 
	SELECT @incremento_precio := precio
    FROM productos
    WHERE id_prod = id_producto;
    SET total = total + @incremento_precio;
END

SET @total = 0;
CALL venderProducto(@total,2);
CALL venderProducto(@total,7);
CALL venderProducto(@total,4);
SELECT @total;

DELIMITER //
CREATE PROCEDURE comprarProducto(
	IN id_producto INT,
    IN piezas_compradas INT,
    INOUT pagar INT,
    INOUT num_productos INT)
BEGIN
	SELECT @incremento_precio := precio
    FROM productos
    WHERE id_prod = id_producto;
    SET num_productos = num_productos+piezas_compradas;
    SET pagar = pagar + (@incremento_precio * piezas_compradas);
    UPDATE productos set stock = stock - piezas_compradas WHERE id_prod = id_producto;
END

set @pagar = 0;
set @num_productos = 0;
CALL comprarProducto(3,5,@pagar,@num_productos);
CALL comprarProducto(2,3,@pagar,@num_productos);
CALL comprarProducto(1,1,@pagar,@num_productos);
CALL comprarProducto(3,3,@pagar,@num_productos);
SELECT @pagar, @num_producto;
    
    
    
DELIMITER //
CREATE PROCEDURE hacerVenta(
IN id_producto INT,
IN piezas_compradas INT)
BEGIN
	SELECT @disponibles := stock
    FROM productos
    WHERE id_prod = id_producto;
    
IF @disponibles IS NOT NULL AND @disponibles >= piezas_compradas THEN
    UPDATE productos
    SET stock = stock - piezas_compradas
    WHERE id_prod = id_producto;
    
	SELECT concat('Venta de', piezas_compradas, 'piezas de', id_producto) AS result;
ELSE 
	SELECT 'Producto no disponible' AS result;
	END IF;
END

CALL hacerVenta(1, 5);


