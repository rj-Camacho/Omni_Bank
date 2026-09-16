# Actividad 3: Normalizando el Prototipo Monolítico de OmniBank

## 1NF

| transaccion_id | fecha_tx   | cliente_tax_id | cliente_nombre |
| -------------- | ---------- | -------------- | -------------- |
| TX-0001        | 2026-07-20 | TAX-9911       | Roberto Soto   |
| TX-0002        | 2026-07-21 | TAX-9911       | Roberto Soto   |

| cliente_correo                      | cliente_telefono | cuenta_numero |
| ----------------------------------- | ---------------- | ------------- |
| [rob@mail.com](mailto:rob@mail.com) | 555-9011         | CTA-100       |
| [rob@mail.com](mailto:rob@mail.com) | 555-9011         | CTA-100       |

| moneda | tipo_cuenta | saldo_actual | monto_tx |
| ------ | ----------- | -----------: | -------: |
| USD    | Checking    |      1500.00 |  +500.00 |
| USD    | Checking    |      1300.00 |  -200.00 |

| sucursal_cod | sucursal_direccion |
| ------------ | ------------------ |
| S-CDMX       | Av. Juárez #100    |
| S-CDMX       | Av. Juárez #100    |

## 2NF

cliente_tax_id, cliente_nombre, cliente_correo y cliente_telefono describen al cliente.

cuenta_numero, moneda, tipo_cuenta y saldo_actual describen a la cuenta.

sucursal_codigo y sucursal_direccion describen a la sucursal.

## 3NF

### Tabla 1 — Clientes

| cliente_tax_id (PK) | nombre       | correo                              | telefono |
| ------------------- | ------------ | ----------------------------------- | -------- |
| TAX-9911            | Roberto Soto | [rob@mail.com](mailto:rob@mail.com) | 555-9011 |

### Tabla 2 — Sucursales

| sucursal_codigo (PK) | direccion       |
| -------------------- | --------------- |
| S-CDMX               | Av. Juárez #100 |

### Tabla 3 — Cuentas

| cuenta_numero (PK) | cliente_tax_id (FK) | moneda | tipo_cuenta | saldo_actual | sucursal_codigo (FK) |
| ------------------ | ------------------- | ------ | ----------- | -----------: | -------------------- |
| CTA-100            | TAX-9911            | USD    | Checking    |      1500.00 | S-CDMX               |
| CTA-100            | TAX-9911            | USD    | Checking    |      1300.00 | S-CDMX               |

### Tabla 4 — Transacciones

| transaccion_id (PK) | fecha_tx   | cuenta_numero (FK) | monto_tx |
| ------------------- | ---------- | ------------------ | -------: |
| TX-0001             | 2026-07-20 | CTA-100            |  +500.00 |
| TX-0002             | 2026-07-21 | CTA-100            |  -200.00 |
