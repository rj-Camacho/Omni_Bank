# Actividad 4: Asignación de Tipos de Datos Nativos y Enums en OmniBank

```sql
CREATE DATABASE OmniBanck;

CREATE TYPE tipo_monedas AS ENUM('USD','EUR','MXN');

CREATE TYPE tipo_de_cuentas AS ENUM('CHECKING','SAVINGS','CREDIT');

CREATE TYPE tipo_de_transaccion AS ENUM('DEPOSIT','WITHDRAWAL','TRANSFER');

CREATE DOMAIN correo_electronico AS VARCHAR(150);
       CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');
```

## Cliente
- id_cliente: PK UUID
- nombre_completo
- correo electronico: VARCHAR
- telefono: VARCHAR
- fecha_nacimiento: DATE
- tax_id: VARCHAR
- is_active: Boolean

## Cuentas
- id_cuenta: PK UUID
- cliente_id: FK UUID
- numero_cuenta: VARCHAR
- moneda: VARCHAR
- tipo_cuenta: VARCHAR
- saldo_actual: Decimal
- limite_ credito: Decimal
- updated_at: Timestamp

## Transacciones
- id_transacciones: UUID
- cuenta_origen_id: UUID
- cuenta_destino_id: UUID
- monto: Decimal
- tipo_transaccion: VARCHAR
- fecha_completa: Timestamp
