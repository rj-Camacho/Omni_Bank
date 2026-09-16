# Actividad 1: Levantamiento de Requisitos de OmniBank

## Base de datos

### Entidades Identificadas:

- **Clientes:** Los usuarios que utilizan los servicios del banco.
- **Cuentas:** Los productos financieros que un cliente puede abrir.
- **Transacciones:** Los movimientos de dinero que ocurren dentro del sistema.

### Requerimientos funcionales

- **RF1 Información de clientes:** El sistema debe almacenar los datos personales de cada cliente, lo cual incluye obligatoriamente nombre completo, correo electrónico, número de teléfono, fecha de nacimiento y número de identificación fiscal.
- **RF2 Información de cuenta:** El sistema debe permitir registrar una o múltiples cuentas asociadas a un cliente. De cada cuenta se debe guardar el número de cuenta, la moneda, el tipo de cuenta, el saldo actual y el límite de crédito.
- **RF3 Registro de transacciones:** El sistema debe registrar de manera precisa cada movimiento de dinero, almacenando la cuenta de origen, la cuenta de destino, el monto, el tipo de transacción y la fecha y hora exacta en la que se completó.
