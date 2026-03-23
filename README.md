# 🏨 RoomKeyDB

Este proyecto consiste en el diseño, implementación y explotación de una base de datos relacional para la gestión de un complejo hotelero. La infraestructura ha sido desplegada en la nube utilizando **AWS RDS**.

## 🚀 Características Técnicas

* **Motor de Base de Datos:** MySQL 8.0.
* **Entorno de Despliegue:** AWS RDS (Relational Database Service).
* **Volumen de Datos:** +1000 registros por tabla generados con Mockaroo.
* **Herramientas de Gestión:** DBeaver / MySQL Workbench.

## 📊 Diseño del Modelo

El proyecto incluye dos niveles de abstracción:
1.  **Modelo Entidad-Relación (E-R):** Diseño lógico de entidades y relaciones de negocio.
2.  **Modelo Relacional (Físico):** Implementación técnica con tipos de datos estructurados, variables de estado (`ENUM`, `SET`), Primary Keys y Foreign Keys.

## 🔍 Explotación y Consultas Destacadas

El proyecto incluye consultas complejas para la toma de decisiones, entre las que destacan:
* **Análisis Multitabla:** Cruce de hasta 5 tablas (JOINs) para obtener información detallada, como los servicios extra solicitados por los clientes al hacer Check-in.
* **Subconsultas y Funciones de Agregación:** Identificación de tarifas por encima de la media del hotel o ingresos agrupados por fechas.
* **Vistas (Views):** Creación de reportes predefinidos para agilizar el trabajo de los departamentos de Limpieza (habitaciones urgentes) y Finanzas (pagos VIP).

## ⚙️ Programación Avanzada en Base de Datos

Para garantizar la integridad y automatizar los procesos diarios del hotel, se ha incorporado lógica de programación directamente en el motor de la base de datos:
* **Funciones:** Módulos determinísticos para el cálculo de días de estancia y validación de los totales facturados.
* **Procedimientos Almacenados:** Rutinas invocables para la inserción rápida de nuevos clientes, cancelación de reservas y resumen de facturación (haciendo uso interno de las funciones creadas).
* **Triggers (Disparadores):** Reglas de negocio activas para bloquear pagos negativos (`BEFORE INSERT` con lanzamiento de errores personalizados usando `SIGNAL SQLSTATE`) y automatización del estado de las habitaciones pasando a 'sucia' tras un Check-out (`AFTER UPDATE`).

## 🛠️ Retos Superados

Durante el desarrollo se gestionaron diversos desafíos técnicos:
* **Integridad Referencial:** Configuración precisa de claves foráneas y jerarquías (como la recursividad de empleados a cargo) para asegurar la consistencia de los datos.
* **Carga Masiva:** Resolución de conflictos de inserción mediante la correcta secuenciación de dependencias entre tablas.
* **Cloud Computing:** Conexión y administración remota de la base de datos en un entorno real de AWS.
* **Manejo de Excepciones:** Control de flujo y lanzamiento de errores controlados desde el propio servidor de base de datos para evitar transacciones ilógicas.

---
**Autor:** José María Gómez Vélez  
**Curso:** 1º DAW, Base de Datos
