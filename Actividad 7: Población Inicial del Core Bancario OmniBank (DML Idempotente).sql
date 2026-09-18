-- Day 07 Answer Key — Población Inicial del Core Bancario OmniBank (DML Idempotente)

-- 1. Inserción resiliente e idempotente de Clientes Pioneros de OmniBank
INSERT INTO core.customers (customer_id, first_name, last_name, email, phone_number, tax_id, date_of_birth)
VALUES 
    ('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@email.com', '555-0100', 'TAX-100', '1985-04-12'),
    ('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@email.com', '555-0200', 'TAX-200', '1990-08-25'),
    ('33333333-3333-3333-3333-333333333333', 'Alice', 'Johnson', 'alice.j@email.com', '555-0300', 'TAX-300', '1978-11-05')
ON CONFLICT (email) DO NOTHING;

-- 2. Apertura protegida ante duplicidades para Cuentas Financieras
INSERT INTO core.accounts (account_id, customer_id, account_number, account_type, balance, credit_limit)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'ACCT-1001', 'CHECKING', 5000.00, 0),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'ACCT-2001', 'SAVINGS', 15000.00, 0),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'ACCT-3001', 'CREDIT', 0.00, 10000.00)
ON CONFLICT (account_number) DO NOTHING;

-- 3. Inserción de Operaciones y Movimientos Iniciales de Prueba
-- (Nota: No aplica obligatoriamente ON CONFLICT en transacciones sin una columna única asignada, pero podemos insertarlas convencionalmente o condicionar contra duplicados por ID de transacción si se pasa manual).
INSERT INTO core.transactions (from_account_id, to_account_id, amount, currency, transaction_type, status, description)
VALUES 
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 150.00, 'USD', 'TRANSFER', 'COMPLETED', 'Pago de cena'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 300.00, 'USD', 'TRANSFER', 'COMPLETED', 'Abono a tarjeta de crédito'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 50.00, 'USD', 'FEE', 'COMPLETED', 'Comisión mensual por manejo de cuenta');

-- 4. Deducción de Comisión con Filtro Inquebrantable WHERE y Extracción al Vuelo con RETURNING
UPDATE core.accounts 
SET balance = balance - 50.00,
    updated_at = CURRENT_TIMESTAMP
WHERE account_number = 'ACCT-1001'
RETURNING account_number, balance;