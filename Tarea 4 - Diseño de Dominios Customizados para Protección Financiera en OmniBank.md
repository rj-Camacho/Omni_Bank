# Tarea 4: Diseño de Dominios Customizados para Protección Financiera en OmniBank

## Dominio Monetario Bancario

```sql
CREATE DOMAIN monto_financiero AS NUMERIC(15, 2)
CHECK (VALUE >= 0.00);
```

## Dominio de Identificación Fiscal / Cadena No Vacía

```sql
CREATE DOMAIN texto_obligatorio AS VARCHAR(100)
CHECK (VALUE <> '' AND LENGTH(TRIM(VALUE)) > 0);
```

## Reporte de Implementación en el ERD

El nuevo dominio `monto_financiero` actuará como un blindaje transversal y se implementará para sustituir el tipo de dato genérico en las siguientes **3 columnas específicas** de nuestro diseño:

- **`saldo_actual`** (Tabla: Cuentas)
- **`limite_credito`** (Tabla: Cuentas)
- **`monto`** (Tabla: Transacciones)
