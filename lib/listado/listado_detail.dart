import 'package:flutter/material.dart';
import 'package:taller1/modelos/pokemon.dart';
import 'package:taller1/servicios/servicio_pokemon.dart';

class ListadoDetail extends StatelessWidget {
  final Pokemon pokemon;

  const ListadoDetail({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen
            Center(
              child: Hero(
                tag: pokemon.name, // 👈 si quieres animación al abrir
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    pokemon.image,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nombre y tipo
            Text(
              pokemon.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Tipo: ${pokemon.types.join(", ")}", // son varios tipos
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}