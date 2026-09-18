# Tarea 6: Análisis Forense Post-Mortem de Bloqueo Masivo en Producción (OmniBank)

## 1. Causa Raíz Computacional: Mecánica del AccessExclusiveLock

El colapso de 14 minutos en el motor de base de datos no fue provocado por un error de sintaxis, sino por una colisión masiva en la matriz de bloqueos (*Lock Matrix*) de PostgreSQL durante horas pico de concurrencia:

- **Adquisición del Bloqueo Absoluto:** La sentencia `ALTER TABLE ... ADD CONSTRAINT ... CHECK` exige un bloqueo de nivel **`AccessExclusiveLock`** sobre la tabla `core.transactions`. Este es el nivel de bloqueo más agresivo del motor y entra en conflicto directo con **todos** los demás tipos de bloqueo, incluyendo lecturas (`AccessShareLock` generado por `SELECT`) y escrituras (`RowExclusiveLock` generado por `INSERT`, `UPDATE` y `DELETE`).
- **Escaneo Secuencial de 75 Millones de Filas:** Al no indicar parámetros adicionales, PostgreSQL está obligado por diseño a verificar que cada una de las 75 millones de filas históricas cumpla con la regla `LENGTH(TRIM(description)) >= 5`. El motor mantuvo retenido el `AccessExclusiveLock` de forma ininterrumpida mientras leía el disco duro para validar registro por registro.
- **Efecto Dominó en la Aplicación:** Durante esos 14 minutos, cada petición de la app móvil y de los cajeros quedó en estado de espera (*waiting*) intentando adquirir un bloqueo de fila básico. Esto agotó en segundos el pool de conexiones del backend, derivando en cascada en los errores *504 Database Gateway Timeout*.

## 2. Estrategia de Mitigación en Dos Fases (Zero-Downtime Migration)

Para agregar validaciones `CHECK` en tablas masivas en caliente sin interrumpir la operación del banco, el estándar de arquitectura exige desacoplar la creación de la regla de la validación de los datos históricos.

### Paso 1: Creación de la Regla en Tiempo Real (`NOT VALID`)

Ejecuta la adición del *constraint* indicando la cláusula `NOT VALID`. Esto instruye a PostgreSQL a registrar la regla en el catálogo del sistema y aplicarla inmediatamente a todas las **nuevas** inserciones y actualizaciones, omitiendo el escaneo de los 75 millones de registros pasados.

```sql
-- Paso 1: Bloqueo de milisegundos (Metadata-only). No escanea el histórico.
ALTER TABLE core.transactions 
    ADD CONSTRAINT chk_transactions_description_valid 
    CHECK (LENGTH(TRIM(description)) >= 5) NOT VALID;
```

- **Comportamiento del motor:** Adquiere un `AccessExclusiveLock` únicamente durante una fracción de milisegundo para actualizar la metadata del catálogo. No bloquea el tráfico de la aplicación y la regla entra en vigor al instante para peticiones entrantes.

### Paso 2: Validación Asíncrona del Histórico (`VALIDATE CONSTRAINT`)

Una vez creada la regla, se ejecuta la verificación de las filas antiguas de forma asíncrona mediante la instrucción `VALIDATE CONSTRAINT`.

```sql
-- Paso 2: Escaneo en segundo plano sin interrumpir operaciones concurrentes.
ALTER TABLE core.transactions 
    VALIDATE CONSTRAINT chk_transactions_description_valid;
```

- **Comportamiento del motor:** PostgreSQL realiza el escaneo de las 75 millones de filas utilizando un bloqueo leve de tipo `ShareUpdateExclusiveLock`. Este nivel de bloqueo **permite de manera simultánea consultas `SELECT`, inserciones `INSERT` y actualizaciones `UPDATE/DELETE`** sin interrumpir la operación bancaria ni degradar el servicio.

## 3. Directrices Gubernamentales para Futuras Migraciones DDL

1. **Prohibición de DDL Directo en Horas Pico:** Queda estrictamente prohibida la ejecución manual de comandos DDL en caliente sobre las tablas principales (`core.customers`, `core.accounts`, `core.transactions`) sin aprobación previa del Comité de Arquitectura.
2. **Uso de Timeouts de Bloqueo:** Todos los scripts de migración deberán configurar un `lock_timeout` preventivo (ej. `SET lock_timeout = '2s';`) para que la sentencia aborte automáticamente si no logra adquirir el bloqueo de inmediato, evitando la acumulación de transacciones en cola.
