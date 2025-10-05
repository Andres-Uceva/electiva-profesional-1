import 'dart:isolate';
import 'package:flutter/material.dart';

class IsolatePantalla extends StatefulWidget {
  const IsolatePantalla({super.key});
  @override
  State<IsolatePantalla> createState() => _IsolatePantallaState();
}

class _IsolatePantallaState extends State<IsolatePantalla> {
  String resultado = "presiona para ejecutar tarea pesada";
  String tiempoTranscurrido = "";

  void ejecutarTarea() async {
    final temporizador = Stopwatch()..start();
    setState(() => resultado = "procesando...");
    final receivePort = ReceivePort();
    await Isolate.spawn(tareaPesada, receivePort.sendPort);
    receivePort.listen((message) {
      debugPrint("Tiempo total: ${temporizador.elapsedMilliseconds} ms");
      setState(() {
        debugPrint("Tarea completada. Resultado: $message");
        resultado = "resultado: $message";
        tiempoTranscurrido = "${temporizador.elapsedMilliseconds} ms";
      });
      receivePort.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isolate / Tarea pesada")),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(resultado, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: ejecutarTarea, child: const Text("Ejecutar")),
        ]),
      ),
    );
  }
}

void tareaPesada(SendPort sendPort) { 
  debugPrint("sumando...");
  int sum = 0;
  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }
  debugPrint("sumando terminado, enviando...");
  sendPort.send(sum);
}