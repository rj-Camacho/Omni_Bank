# Tarea 5: Dictamen y Defensa de Políticas de Integridad Referencial en OmniBank

**A:** Equipo de Pruebas Automáticas (QA) y Comité de Desarrollo Backend

**DE:** Arquitecto Principal de Datos de OmniBank

**ASUNTO:** Rechazo definitivo a la implementación de `ON DELETE CASCADE` en entornos de base de datos

## 1. Riesgo Operativo y Catástrofe en Producción

La solicitud de implementar `ON DELETE CASCADE` en las llaves foráneas que conectan `core.customers`, `core.accounts` y `core.transactions` queda **rotundamente rechazada**. En un motor financiero, habilitar cascadas destructivas transforma cualquier instrucción individual o error operativo en un fallo sistémico catastrófico: la ejecución accidental o maliciosa de un `DELETE` sobre una sola fila de cliente desencadenaría una reacción en cadena que borraría al instante sus cuentas, límites de crédito e historiales contables. Perder este grafo de datos en milisegundos destruye la trazabilidad de los fondos y genera un agujero contable irrecuperable. La regla `ON DELETE RESTRICT` actúa precisamente como el freno de emergencia necesario a nivel de motor para garantizar la inmutabilidad de la información.

## 2. Inviolabilidad del Rastro Fiscal y Normativa Internacional

Desde el marco legal y regulatorio internacional (como SOX, marcos PCI-DSS y legislaciones tributarias locales), las tablas transaccionales como `core.transactions` constituyen un libro mayor contable inalterable. Los registros de movimientos monetarios no pertenecen únicamente a la vista privada del usuario, sino que respaldan impuestos, auditorías de lavado de dinero y la conciliación bancaria del balance general. Un comando `DELETE` físico sobre movimientos históricos —incluso si el cliente decide rescindir su contrato comercial— constituye una infracción legal grave por alteración y destrucción de libros contables. Todo centavo que haya ingresado o salido de OmniBank debe permanecer registrado permanentemente.

## 3. Directriz Oficial: Ciclo de Vida mediante Bajas Lógicas (***Soft Delete***)

Para reflejar el término de la relación comercial con un usuario o la cancelación de un producto, la arquitectura del banco exige el uso de **Bajas Lógicas (***Soft Delete***)**, prohibiendo la eliminación física en tablas productivas. La baja y mantenimiento del entorno deben regirse bajo los siguientes lineamientos:

- **Desactivación de Clientes:** Ante la salida de un usuario, se actualizará su indicador de estado a inactivo (`is_active = FALSE`). El registro de sus datos personales y su `tax_id` permanecerá intacto para fines de auditoría.
- **Cierre de Cuentas:** Las cuentas liquidadas pasarán a un estado formal de cierre (`status = 'CLOSED'`), previa verificación de que su saldo actual sea estrictamente cero (`saldo_actual = 0.00`).
- **Protocolo para Entornos de Pruebas (QA):** El equipo de QA no debe adaptar la arquitectura de producción para resolver fricciones de limpieza en desarrollo. Para las pruebas de integración se deben emplear scripts de reajuste de base de datos (`TRUNCATE ... CASCADE` exclusivamente en esquemas de *sandbox/testing* aislados) o diseñar escenarios de prueba que consuman la API de baja lógica mediante `UPDATE`.
