# RetailPro | Análisis de datos de un retail de tecnología

**Proyecto integrador – Curso Data Analytics | Coderhouse**

## Descripción del proyecto

RetailPro es un proyecto de análisis de datos desarrollado sobre una empresa ficticia dedicada a la comercialización de productos tecnológicos, con sucursales en Argentina y un canal de venta online.

El objetivo principal del proyecto es analizar el comportamiento comercial del negocio, identificar tendencias de ventas y detectar oportunidades de mejora en su desempeño.

El análisis parte de una problemática central: **¿por qué la empresa vende más, pero obtiene un menor margen de contribución en 2025?**

A partir de los datos disponibles, se busca identificar los factores que pueden explicar esta situación, analizando la evolución de la facturación, los productos comercializados, el comportamiento de los clientes y los distintos canales de venta.

El período de análisis comprende desde enero de 2024 hasta septiembre de 2025.

## Objetivos del análisis

- Analizar la evolución mensual de la facturación y la cantidad de pedidos.
- Evaluar el comportamiento del ticket promedio.
- Identificar los productos con mayor volumen de ventas y facturación.
- Analizar clientes recurrentes y su comportamiento de compra.
- Comparar el desempeño comercial entre períodos.
- Identificar oportunidades de mejora a partir de los datos.
- Construir un modelo de datos que permita visualizar indicadores y facilitar la toma de decisiones.

## Herramientas utilizadas

| Herramienta | Aplicación |
|---|---|
| SQL Server (SSMS) | Creación de bases de datos, consultas SQL y análisis de información. |
| Power Query | Limpieza, transformación y preparación de datos. |
| Power BI | Modelado de datos, creación de medidas DAX y visualización de indicadores. |

## Estructura del repositorio

```text
retailpro_sql/
│
├── ENTREGABLE 3_RETAILPRO_CABRERA AGUIRRE DAIANA.sql
│
├── m4_consultas_negocio.sql
│
├── m5_consultas_joins.sql
│
├── Pipeline_ETL_CabreraAguirre_Daiana.pbix
│
├── CabreraAguirre_Daiana_Checkpoint2.pbix
│
└── README.md
```

### Descripción de los archivos

**1. ENTREGABLE 3_RETAILPRO_CABRERA AGUIRRE DAIANA.sql – Entrega 3**

Script de creación de la base de datos `BD_RETAILPRO_DAIANA`.

Incluye la creación de las tablas, sus relaciones y la carga de los datos necesarios para desarrollar el análisis.

**2. m4_consultas_negocio.sql – Consultas de negocio**

Contiene consultas SQL orientadas a responder preguntas comerciales:

- Resumen mensual de facturación, cantidad de pedidos y ticket promedio.
- Ranking de productos por cantidad vendida y facturación.
- Identificación de clientes recurrentes.
- Análisis de meses con resultados por encima o por debajo del promedio.

**3. m5_consultas_joins.sql – Consultas con JOIN y UNION**

Incluye consultas para integrar información de distintas tablas y ampliar el análisis:

- Vista base de ventas mediante relaciones entre tablas.
- Identificación de clientes y productos sin ventas.
- Análisis de ventas por canal.

**4. Pipeline_ETL_CabreraAguirre_Daiana.pbix – Entrega 6**

Archivo de Power BI con el proceso ETL. Se trabajó con el dataset de práctica del curso (`Pipeline_ETL_Dataset.xlsx`, empresa TechStore), no con la base RetailPro.

En Power Query se quitaron duplicados por ID, se resolvieron los valores nulos, se corrigieron los tipos de datos, se renombraron las tablas con el estándar Dim_ / Fact_ y se hizo un Merge para sumar el nombre y la categoría del producto a la tabla de ventas. Los pasos están documentados con comentarios en lenguaje M.

**5. CabreraAguirre_Daiana_Checkpoint2.pbix – Entrega 8**

Continúa sobre el archivo de la Entrega 6 (dataset TechStore). Incluye el modelo con relaciones 1:N y dirección única, la tabla calendario `Dim_Fechas` y la tabla `_Medidas` con 5 medidas DAX: Total Ventas, Ventas Online (CALCULATE), Ventas YTD (TOTALYTD), Ventas LY (SAMEPERIODLASTYEAR) y % Crecimiento Anual (VAR + DIVIDE).

## Cómo ejecutar el proyecto

Para reproducir el análisis, seguir los siguientes pasos:

### 1. Crear la base de datos

- Abrir SQL Server Management Studio (SSMS).
- Conectarse a la instancia de SQL Server.
- Abrir el archivo `ENTREGABLE 3_RETAILPRO_CABRERA AGUIRRE DAIANA.sql`.
- Ejecutar el script para crear la base de datos, las tablas y cargar los registros.
- Control: la tabla `Ventas` tiene que tener **1.760 líneas** y un total facturado de **1.020.612.881**.

### 2. Ejecutar las consultas de negocio

Una vez creada y cargada la base de datos:

- Abrir `m4_consultas_negocio.sql`.
- Seleccionar la base de datos `BD_RETAILPRO_DAIANA`.
- Ejecutar las consultas para obtener los principales indicadores comerciales.

### 3. Ejecutar las consultas con JOIN y UNION

- Abrir `m5_consultas_joins.sql`.
- Verificar que la base de datos seleccionada sea `BD_RETAILPRO_DAIANA`.
- Ejecutar las consultas para integrar información y analizar las relaciones entre las distintas entidades del negocio.

### 4. Abrir los proyectos de Power BI

- Abrir `Pipeline_ETL_CabreraAguirre_Daiana.pbix` para revisar el proceso de limpieza y transformación de datos en Power Query.
- Abrir `CabreraAguirre_Daiana_Checkpoint2.pbix` para explorar el modelo de datos, las medidas DAX y los indicadores desarrollados.

**Nota:** los dos archivos de Power BI se conectan al Excel `Pipeline_ETL_Dataset.xlsx` (no a SQL Server). Para actualizar los datos hay que cambiar la ruta del Excel en **Transformar datos → Configuración de origen de datos**.

## Principales hallazgos

- **Más pedidos, menor ticket:** de enero a septiembre de 2025 los pedidos subieron 23,7 % frente al mismo período de 2024, pero el ticket promedio bajó 8,4 %. Hay que revisar los descuentos y las cuotas sin interés aplicados en 2025.
- **Pocos productos explican gran parte de la facturación:** los 5 productos que más facturan (notebooks, celulares y PC de escritorio) concentran el 42 % del total.
- **Estacionalidad:** noviembre y diciembre son los meses más altos (más de 71 M por mes en 2024), y febrero, mayo y junio quedan por debajo del promedio mensual (48,6 M) en los dos años.
- **Clientes sin compras:** 52 de los 400 clientes registrados (13 %) nunca compraron; 20 de ellos son empresas.
- **Canal online:** factura el 68 % del total, con un ticket promedio similar al presencial.

## Enfoque de análisis

El proyecto busca transformar los datos operativos en información útil para la toma de decisiones comerciales.

El foco está puesto en comprender la relación entre el crecimiento de las ventas y la evolución del margen de contribución, considerando variables como:

- Volumen de operaciones.
- Ticket promedio.
- Mix de productos.
- Canales de comercialización.
- Comportamiento de los clientes.
- Evolución de la facturación.

El análisis permite identificar tendencias, detectar posibles desvíos y generar información que contribuya a mejorar el desempeño comercial y la rentabilidad del negocio.

---

**Proyecto académico desarrollado por Daiana Cabrera Aguirre**  
Curso Data Analytics – Coderhouse  
Herramientas: SQL Server | Power Query | Power BI