import 'dart:async';
import 'package:flutter/material.dart';

class Temporizador extends StatefulWidget {
  const Temporizador({super.key});

  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;

  void start() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds++);
    });
    setState(() => isRunning = true);
  }

  void pause() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void reset() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isRunning = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timer / Cronómetro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$seconds s', style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pause : start,
                  child: Text(isRunning ? "Pausar" : "Iniciar"),
                ),
                ElevatedButton(onPressed: reset, child: const Text("Reiniciar")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}