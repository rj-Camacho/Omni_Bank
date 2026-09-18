# Tarea 7: Sincronización Resiliente del Pipeline KYC con Escrituras Idempotentes (`UPSERT`)

El patrón de ejecutar un `SELECT` previo para decidir entre un `INSERT` o `UPDATE` en el backend queda **estrictamente prohibido** por dos motivos:

1. **Latencia Excesiva:** Obliga al sistema a realizar dos viajes de red por registro. En cargas masivas, esto retrasa el procesamiento por horas.
2. **Condiciones de Carrera (Race Conditions):** En entornos concurrentes, dos procesos pueden no encontrar el email al mismo instante e intentar hacer el `INSERT` simultáneamente. Uno fallará violentamente por violar la restricción de unicidad (`UNIQUE`).

**LA SOLUCIÓN: UPSERT ATÓMICO EN EL MÓDULO KYC**

Toda la lógica debe delegarse a la base de datos en una sola operación atómica. El pipeline debe usar esta única instrucción SQL:

SQL

```
INSERT INTO core.customers (
    customer_id, first_name, last_name, email, phone, tax_id, date_of_birth
) 
VALUES (
    '99999999-9999-9999-9999-999999999999', 'Carlos', 'Gomez', 'carlos.g@email.com', '555-8888', 'TAX-500', '1982-10-30'
)
-- Si el email ya existe, el motor atrapa la colisión y desvía la orden a un UPDATE
ON CONFLICT (email) 
DO UPDATE SET 
    -- EXCLUDED contiene los datos "frescos" que intentaban entrar.
    -- Así actualizamos solo lo necesario, protegiendo el ID original y la fecha de alta.
    first_name = EXCLUDED.first_name,
    last_name  = EXCLUDED.last_name,
    phone      = EXCLUDED.phone
-- Devuelve instantáneamente el ID y el email final al microservicio
RETURNING customer_id, email;

```

**Comportamiento:** En un solo viaje de red y con garantía ACID, PostgreSQL evalúa e inserta al cliente si es nuevo, o actualiza su nombre y teléfono si ya existía. Al finalizar, devuelve los datos actualizados mediante `RETURNING`, otorgando confirmación absoluta al pipeline en milisegundos.