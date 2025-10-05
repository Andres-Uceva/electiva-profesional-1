import 'package:flutter/material.dart';
import '../servicios/servicio.dart';

class Futuro extends StatefulWidget {
  const Futuro({super.key});

  @override
  State<Futuro> createState() => _FuturoState();
}

class _FuturoState extends State<Futuro> {
  String message = "presiona para consultar datos";

  Future<void> loadData() async {
    debugPrint("antes de la consulta");
    setState(() => message = "cargando...");
    try {
      final result = await Servicio.obtenerDatos();
      debugPrint("durante la consulta");
      setState(() => message = "exito: $result");
    } catch (e) {
      setState(() => message = "error: $e");
    } finally {
      debugPrint("despues de la consulta");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Future | async | await")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: loadData, child: const Text("Consultar"))
          ],
        ),
      ),
    );
  }
}