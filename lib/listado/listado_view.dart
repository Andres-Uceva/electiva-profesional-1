import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taller1/servicios/servicio_pokemon.dart';

class ListaView extends StatefulWidget {
  ListaView({super.key});

  ServicioPokemon servicio = ServicioPokemon();

  @override
  State<ListaView> createState() => _ListaViewState();
}

class _ListaViewState extends State<ListaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de pokemones'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: widget.servicio.fetchPokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando pokemones...')
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text('Ocurrió un error al cargar los pokemones.',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('${snapshot.error}',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay pokemones disponibles.',
                  style: TextStyle(fontSize: 16)),
            );
          } else {
            final pokemons = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        pokemon
                            .image, // 👈 asegúrate de que tu modelo tenga esta propiedad
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      pokemon.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      context.push('/listado_detail', extra: pokemon);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
