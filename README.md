## Nombre y codigo
Andres Felipe Bonilla Botero 230221025

## Descripcion del taller
Construccion de una pantalla básica en Flutter con StatefulWidget y evidenciar el uso de setState()

## Capturas de pantalla

### Estado inicial

![alt text](<capturas/estado inicial.png>)

### Estado despues de pulsar boton

![alt text](<capturas/despues de estado.png>)

## Pasos para ejecutar

flutter pug get

flutter run

# Taller 3: Segundo plano, asincronía y servicios en Flutter

## Future / async / await
- Se usa cuando hay operaciones **asíncronas no bloqueantes**, como llamadas a red o consultas simuladas.
- Permite “esperar” un resultado sin congelar la UI.

## Timer
- Se usa para ejecutar código repetidamente o tras un tiempo específico.
- Ideal para cronómetros o temporizadores.

## 3️⃣ Isolate
- Se usa para tareas **pesadas de CPU** que bloquearían la UI (ej. cálculos grandes).
- Cada Isolate tiene su propio hilo de ejecución y se comunica por mensajes (`SendPort` / `ReceivePort`).

