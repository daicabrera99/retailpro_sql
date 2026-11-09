--=========================================================
-- Proyecto RetailPro - Entregable N5: Consultas con JOIN y UNION
-- Alumna: Cabrera Aguirre, Daiana
-- Base: BD_RETAILPRO_DAIANA (SQL Server)
--=========================================================


USE BD_RETAILPRO_DAIANA
GO

-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Una fila por línea de venta. Aclaración: Provincia y Región son las de la sucursal donde se vendió.

SELECT
    v.Fecha_venta,
    v.Nro_pedido,
    c.Nombre                           AS Nombre_cliente,
    c.Tipo_cliente,
    s.Nombre_sucursal,
    t.Provincia,
    t.Region,
    v.Medio_contacto,
    p.Nombre_producto,
    cat.Nombre_categoria,
    (v.Cantidad - v.Cantidad_devuelta) AS Cantidad_neta,
    v.Precio_unitario,
    v.Total_venta
FROM Ventas v
    INNER JOIN Clientes c
        ON c.Id_cliente = v.Id_cliente
    INNER JOIN Sucursales s
        ON s.Id_sucursal = v.Id_sucursal_venta
    INNER JOIN Territorios t
        ON t.Id_territorio = s.Id_territorio
    INNER JOIN Productos p
        ON p.Id_producto = v.Id_producto
    INNER JOIN Categorias cat
        ON cat.Id_categoria = p.Id_categoria;

-- HALLAZGO: La consulta devuelve 1.760 filas y un total de 1.020.612.881, igual que la tabla Ventas sola.



-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN + IS NULL)

SELECT
    c.Nombre,
    c.Email,
    c.Tipo_cliente,
    c.Fecha_registro
FROM Clientes c
    LEFT JOIN Ventas v
        ON c.Id_cliente = v.Id_cliente
WHERE v.Id_venta IS NULL
ORDER BY c.Fecha_registro ASC;

---- Consulta de apoyo: cantidad de clientes sin compras por tipo de cliente.
SELECT
    c.Tipo_cliente,
    COUNT(DISTINCT c.Id_cliente) AS Total_clientes_sin_compras_realizadas
FROM Clientes c
    LEFT JOIN Ventas v
        ON c.Id_cliente = v.Id_cliente
WHERE v.Id_venta IS NULL
GROUP BY c.Tipo_cliente;

-- HALLAZGO: 52 de los 400 clientes registrados nunca compraron (13%). Dichos clientes están distribuidos en 2024-2025 (27 de 2025 y 24 de 2024), es decir, clientes que se registraron pero no concretaron su primera compra.
--			 20 son empresas, el tipo de cliente con mayor ticket promedio.
--			 Acción: contactar a estos clientes, en especial a las empresas, con alguna promoción para la primera compra.



-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN + IS NULL)
-- Se suma el stock por sucursal (LEFT JOIN Stock) y el capital inmovilizado (stock total x costo).

SELECT
    p.Id_producto,
    p.Nombre_producto,
    c.Nombre_categoria,
    p.Precio,
    p.Costo,
    ISNULL(SUM(s.Cantidad), 0)           AS Total_Stock,
    ISNULL(SUM(s.Cantidad), 0) * p.Costo AS Capital_inmovilizado,
    p.Activo
FROM Productos p
    INNER JOIN Categorias c
        ON c.Id_categoria = p.Id_categoria
    LEFT JOIN Ventas v
        ON v.Id_producto = p.Id_producto
    LEFT JOIN Stock s
        ON s.Id_producto = p.Id_producto
WHERE v.Id_producto IS NULL
GROUP BY p.Id_producto, p.Nombre_producto, c.Nombre_categoria, p.Precio, p.Costo, p.Activo
ORDER BY Capital_inmovilizado DESC;

-- HALLAZGO: Hay 3 productos que nunca se vendieron (Samsung Galaxy S24, Notebook Lenovo Yoga Slim 7 y GoPro Hero 12). Los tres están activos y tienen 81 un. en stock, lo cual representa 75,7 M de capital inmovilizado.
--			 Acción: revisar el precio o promocionarlos, y revisar si no es necesario reponer más stock dada la poca venta de los mismos.



-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)
-- Canal se crea como texto fijo en cada SELECT.Se usa UNION ALL para no eliminar ventas repetidas.

SELECT
    Canal,
    SUM(Total_venta)                              AS Total_facturado,
    COUNT(DISTINCT Nro_pedido)                    AS Total_pedidos,
    SUM(Total_venta) / COUNT(DISTINCT Nro_pedido) AS Ticket_promedio
FROM (SELECT Nro_pedido, Total_venta, 'Presencial' AS Canal
      FROM Ventas
      WHERE Medio_contacto = 'Presencial'
      UNION ALL
      SELECT Nro_pedido, Total_venta, 'Online' AS Canal
      FROM Ventas
      WHERE Medio_contacto <> 'Presencial') AS Ventas_por_canal
GROUP BY Canal
ORDER BY Total_facturado DESC;

-- HALLAZGO: El canal online factura 693,2 M (68%) y el presencial 327,4 M (32%). Más allá de eso, el ticket promedio es casi igual en los dos canales, o sea que el canal online factura el doble por la cantidad de pedidos.
--			 Acción: seguir potenciando lo que es la venta online, dado que es la que mayor volumen de compras está generando.
