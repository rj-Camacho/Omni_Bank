# Actividad 2: Diseñando el ERD Base de OmniBank

[Actividad 2: Diseñando el ERD Base de OmniBank](https://moodle.umsa.edu.mx/mod/assign/view.php?id=21784)

## Cliente

- Cliente_id
- Nombre
- correo
- num_telf
- fecha_nacimiento
- Id_fiscal

## Cuenta

- cuenta-id
- Tipo_cuenta
- Num_cuenta
- moneda
- saldo
- limite_cuenta

## Transacciones

- Transccion_id
- Mov_dinero
- Almacen_cuenta
- Cuenta_destino
- monto
- Tipo_cuenta

## Cardinalidades

```text
Cliente +-------<- Cuenta <--------+ Transaccion
```
