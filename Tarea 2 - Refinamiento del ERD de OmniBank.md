# Tarea 2: Refinamiento del ERD de OmniBank

[Tarea 2: Refinamiento del ERD de OmniBank](https://moodle.umsa.edu.mx/mod/assign/view.php?id=21786)

**Comming:** aprendi a identificar nuevos detalles para las claves

## Entidad: Clientes

- `id_cliente` (PK): UUID (Identificador Aleatorio Universal)
- `nombre_completo`: VARCHAR
- `correo_electronico`: VARCHAR — *Constraint: UNIQUE (No puede repetirse)*
- `telefono`: VARCHAR
- `fecha_nacimiento`: DATE
- `tax_id`: VARCHAR — *Constraint: UNIQUE (No puede repetirse)*
- `is_active`: BOOLEAN — *Constraint: DEFAULT TRUE (Atributo de seguridad para Borrado Lógico / Soft Delete)*

## Entidad: Cuentas

- `id_cuenta` (PK): UUID (Identificador Aleatorio Universal)
- `cliente_id` (FK): UUID — *Relación vinculada a Clientes(id_cliente)*
- `numero_cuenta`: VARCHAR — *Constraint: UNIQUE*
- `moneda`: VARCHAR (Ej. USD, EUR)
- `tipo_cuenta`: VARCHAR (Checking, Savings, Credit)
- `saldo_actual`: DECIMAL — *Constraint: CHECK (saldo_actual >= 0) (No puede ser negativo)*
- `limite_credito`: DECIMAL
- `updated_at`: TIMESTAMP — *Atributo de seguridad para auditoría de tiempo de actualización*

## Entidad: Transacciones

- `id_transaccion` (PK): UUID (Identificador Aleatorio Universal)
- `cuenta_origen_id` (FK): UUID — *Relación vinculada a Cuentas(id_cuenta)*
- `cuenta_destino_id` (FK): UUID — *Relación vinculada a Cuentas(id_cuenta)*
- `monto`: DECIMAL — *Constraint: CHECK (monto > 0)*
- `tipo_transaccion`: VARCHAR (Depósito, Retiro, Transferencia)
- `fecha_completada`: TIMESTAMP — *Constraint: DEFAULT CURRENT_TIMESTAMP*
