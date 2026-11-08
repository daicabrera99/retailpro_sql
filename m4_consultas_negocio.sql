--=========================================================
-- Proyecto RetailPro - Entregable N4: Consultas SQL de negocio
-- Alumna: Cabrera Aguirre, Daiana
-- Base: BD_RETAILPRO_DAIANA (SQL Server)
--=========================================================


USE BD_RETAILPRO_DAIANA
GO

-- CONSULTA 1 : RESUMEN EJECUTIVO MENSUAL --> TOTAL FACTURADO, CANTIDAD DE PEDIDOS Y TICKET PROMEDIO, AGRUPADO POR MES.
-- Utilizo Total_venta (ya descuenta promociones y devoluciones) en lugar de Cantidad * Precio_unitario.
-- Utilizo COUNT(DISTINCT Nro_pedido) porque un pedido puede tener varias líneas (una por producto). Es por eso que el ticket promedio es total facturado / pedidos y no AVG por línea.
-- Se agrupa por año y mes para no mezclar meses de 2024 y 2025.

SELECT
    YEAR(Fecha_venta)                             AS Año,
    MONTH(Fecha_venta)                            AS Mes,
    SUM(Total_venta)                              AS Total_facturado,
    COUNT(DISTINCT Nro_pedido)                    AS Total_pedidos,
    SUM(Total_venta) / COUNT(DISTINCT Nro_pedido) AS Ticket_promedio
FROM Ventas
GROUP BY YEAR(Fecha_venta), MONTH(Fecha_venta)
ORDER BY Año, Mes;


-- CONSULTA 2 : RANKING DE PRODUCTOS CON MAYOR FACTURACION.

SELECT TOP 5
    Id_producto,
    SUM(Cantidad)    AS Total_cantidad_vendida,
    SUM(Total_venta) AS Total_facturado
FROM Ventas
GROUP BY Id_producto
ORDER BY Total_facturado DESC;


-- CONSULTA 3 : CLIENTES RECURRENTES.
-- Se usa COUNT(DISTINCT Nro_pedido) en lugar de COUNT(*) para no contar dos o más veces a un cliente que hizo una sola compra con varios productos.

SELECT
    Id_cliente,
    COUNT(DISTINCT Nro_pedido) AS Total_pedidos,
    SUM(Total_venta)           AS Total_facturado
FROM Ventas
GROUP BY Id_cliente
HAVING COUNT(DISTINCT Nro_pedido) > 1
ORDER BY Total_pedidos DESC;


-- CONSULTA 4: MESES POR ENCIMA/POR DEBAJO DEL PROMEDIO

---- Paso 1 --> total por mes
SELECT
    SUM(Total_venta) AS Total_facturado_mensual
FROM Ventas
GROUP BY YEAR(Fecha_venta), MONTH(Fecha_venta);

---- Paso 2 --> promedio mensual (48.600.613)
SELECT
    AVG(Total_facturado_mensual) AS Promedio_facturacion_mensual
FROM (SELECT SUM(Total_venta) AS Total_facturado_mensual
      FROM Ventas
      GROUP BY YEAR(Fecha_venta), MONTH(Fecha_venta)) AS X;

---- Consulta final
SELECT
    YEAR(Fecha_venta)  AS Año,
    MONTH(Fecha_venta) AS Mes,
    SUM(Total_venta)   AS Total_facturado_mensual,
    CASE
        WHEN SUM(Total_venta) > (SELECT AVG(Total_facturado_mensual)
                                 FROM (SELECT SUM(Total_venta) AS Total_facturado_mensual
                                       FROM Ventas
                                       GROUP BY YEAR(Fecha_venta), MONTH(Fecha_venta)) AS X)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END                AS Clasificacion
FROM Ventas
GROUP BY YEAR(Fecha_venta), MONTH(Fecha_venta)
ORDER BY Año, Mes;


-- CONSULTA DE APOYO A: RANKING DE PRODUCTOS CON MAYOR CANTIDAD VENDIDA (Hallazgo 2)

SELECT TOP 5
    Id_producto,
    SUM(Cantidad)    AS Total_cantidad_vendida,
    SUM(Total_venta) AS Total_facturado
FROM Ventas
GROUP BY Id_producto
ORDER BY Total_cantidad_vendida DESC;


-- CONSULTA DE APOYO B: TOTAL FACTURADO, CANTIDAD DE PEDIDOS Y TICKET PROMEDIO, AGRUPADO POR AÑO (Hallazgo 1)
-- Como en la base de datos, el año 2025 tiene datos solo hasta septiembre, se compara por mes y no por total anual.

SELECT
    YEAR(Fecha_venta)                                               AS Año,
    COUNT(DISTINCT MONTH(Fecha_venta))                              AS Meses_con_ventas,
    SUM(Total_venta)                                                AS Total_facturado,
    COUNT(DISTINCT Nro_pedido)                                      AS Total_pedidos,
    COUNT(DISTINCT Nro_pedido) / COUNT(DISTINCT MONTH(Fecha_venta)) AS Pedidos_por_mes,
    SUM(Total_venta) / COUNT(DISTINCT MONTH(Fecha_venta))           AS Facturado_por_mes,
    SUM(Total_venta) / COUNT(DISTINCT Nro_pedido)                   AS Ticket_promedio
FROM Ventas
GROUP BY YEAR(Fecha_venta)
ORDER BY Año;


-- BLOQUE DE CIERRE: HALLAZGOS SOBRE LAS CONSULTAS REALIZADAS

--- HALLAZGO 1 = -- Más allá de que 2025 no contamos con los datos completos se puede ver:
				 -- Aumentó la cantidad de pedidos por mes (2024 era 74 pedidos y en 2025 aumentó a 82, o sea fue una subida de 10,81%).
				 -- Pero a pesar de la suba en los pedidos, el total facturado por mes se mantuvo casi igual (−0,7%), porque el ticket promedio bajó un 11,1%.
				 -- Acción: revisar los descuentos y cuotas sin interés aplicados en 2025.
--- HALLAZGO 2 = -- Los productos que concentran la mayor facturación no se debe a la cantidad vendida, sino que se trata de productos con precio alto: Notebooks, PC de escritorio, Celulares.
				 -- Entre los 5 primeros suman el 42% de la facturación total.
				 -- Si en vez de eso, ordenamos los productos por cantidad vendida, se puede observar que en ese caso tenemos productos que son más accesorios, que equipos, pero que no tienen facturación importante (debido al precio).
				 -- Por ejemplo, el cargador externo vendió 301 unidades y facturó 8.1 M, mientras que la Notebook HP 15 vendió 122 y facturó 102.7 M.
				 -- Acción: asegurar stock de los equipos de mayor valor y usar los accesorios en combos.
--- HALLAZGO 3 = Se puede observar una estacionalidad en las ventas (Promedio mensual --> 48.6M) :
				-- Febrero es un mes con ventas por debajo del promedio, lo cual podría justificarse con temporada de vacaciones.
				-- Marzo - Abril son meses con ventas por encima del promedio, lo cual se podría deber a los meses donde se reactivan las clases y la actividad laboral .
				-- Mayo - Junio también son meses  con ventas por debajo en ambos años.
				-- Noviembre - Diciembre 2024 son los meses más altos (aprox 71M), posiblemente por las fiestas y aguinaldo (son picos de pedidos de 101 y 111).
				-- Acción: reforzar stock y promociones antes de noviembre y planificar acciones para los meses bajos.
