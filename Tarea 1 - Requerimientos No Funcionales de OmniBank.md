# Tarea 1: Requerimientos No Funcionales de OmniBank

## Requerimientos no funcionales

### 1. Consistencia del saldo

- **Requerimiento:** La base de datos debe impedir que el saldo de cualquier cuenta tome un valor negativo tras cualquier transacción o modificación, asegurando que la cuenta nunca entre en sobregiro no autorizado directamente en el motor de datos.
- **Traducción técnica:** Restricción de verificación.

### 2. Auditoría y conservación de datos

- **Requerimiento:** La base de datos debe prohibir la eliminación física de los registros de clientes una vez insertados, obligando a manejar la desactivación mediante un estado lógico para garantizar el cumplimiento de normativas de auditoría financiera.
- **Traducción técnica:** Columna de estado booleano y restricción de permisos contra sentencias DELETE.

### 3. Rastreo temporal

- **Requerimiento:** La base de datos debe capturar y actualizar automáticamente la fecha y hora exacta en que se realiza cualquier modificación en los registros de la tabla de cuentas.
- **Traducción técnica:** Columna temporal con valor por defecto y actualización automática.
