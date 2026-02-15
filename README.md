# 🏨 RoomKeyDB

Este proyecto consiste en el diseño, implementación y explotación de una base de datos relacional para la gestión de un complejo hotelero. La infraestructura ha sido desplegada en la nube utilizando **AWS RDS**.

## 🚀 Características Técnicas

* **Motor de Base de Datos:** MySQL 8.0.
* **Entorno de Despliegue:** AWS RDS (Relational Database Service).
* **Volumen de Datos:** +1000 registros por tabla generados con Mockaroo.
* **Herramienta de Gestión:** DBeaver.

## 📊 Diseño del Modelo

El proyecto incluye dos niveles de abstracción:
1.  **Modelo Entidad-Relación (E-R):** Diseño lógico de entidades y relaciones de negocio.
2.  **Modelo Relacional (Físico):** Implementación técnica con tipos de datos, Primary Keys y Foreign Keys.

## 🔍 Consultas de Explotación Destacadas

El proyecto incluye consultas avanzadas para la toma de decisiones, entre las que destacan:
* **Análisis Multitabla:** Cruce de 5 tablas para obtener servicios extra por cliente en Check-in.
* **Subconsultas Dinámicas:** Identificación de facturas con importes por encima de la media.
* **Vistas (Views):** Automatización de reportes para los departamentos de Limpieza y Finanzas.

## 🛠️ Retos Superados

Durante el desarrollo se gestionaron diversos desafíos técnicos:
* **Integridad Referencial:** Configuración precisa de claves foráneas para asegurar la consistencia de los datos en cascada.
* **Carga Masiva:** Resolución de conflictos de inserción mediante la gestión de jerarquías de tablas.
* **Cloud Computing:** Conexión y administración remota de la base de datos en un entorno real de AWS.

---
**Autor:** José María Gómez Vélez
**Curso:** 1º DAW, Base de Datos
