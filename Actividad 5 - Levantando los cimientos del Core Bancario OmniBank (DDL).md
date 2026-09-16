# Actividad 5: Levantando los cimientos del Core Bancario OmniBank (DDL)

```sql
CREATE SCHEMA IF NOT EXISTS core;

CREATE TABLE core.customers (
    id_clientes UUID DEFAULT gen_random_uuid(),
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(150) NOT NULL,
    telefono VARCHAR(50),
    fecha_nacimiento DATE,
    tax_id VARCHAR(20),
    is_active BOOLEAN DEFAULT true NOT NULL,

    CONSTRAINT pk_clientes PRIMARY KEY (cliente_id),
    CONSTRAINT uq_clientes_email UNIQUE (correo_electronico),
    CONSTRAINT uq_clientes_tax UNIQUE (tax_id)
);

CREATE TABLE core.accounts (
    id_cuenta UUID DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    numero_cuenta VARCHAR(100) NOT NULL,
    moneda VARCHAR(35) NULL,
    tipo_cuenta VARCHAR(25) NULL,
    saldo_actual NUMERIC(15,2),
    limite_credito NUMERIC DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT pk_cuenta PRIMARY KEY (id_cuenta),
    CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES core.customers (cliente_id) ON DELETE RESTRICT
);

CREATE TABLE core.loans (
    transaccion_id UUID DEFAULT gen_random_uuid(),
    from_account UUID DEFAULT gen_random_uuid(),
    to_account UUID DEFAULT gen_random_uuid(),
    monto NOT NULL,
    tipo_transaccion VARCHAR(15) NULL,
    fecha_completa TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT pk_transaccion PRIMARY KEY (transaccion_id),
    CONSTRAINT fk_from FOREIGN KEY (from_account) REFERENCES core.accounts (id_cuenta) ON DELETE RES...
    CONSTRAINT fk_to FOREIGN KEY (to_account) REFERENCES core.accounts (id_cuenta) ON DELETE RESTRICT
);
```
