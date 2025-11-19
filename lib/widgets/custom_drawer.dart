import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary, // Usa el color primario del tema
            ),
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors
                    .white, // Texto blanco para contrastar con el color primario
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              context.go('/'); // Navega a la ruta principal
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Pantalla primaria'),
            onTap: () => context.push('/primaria'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Listado'),
            onTap: () => context.push('/listado'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Temporizador'),
            onTap: () => context.push('/temporizador'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Tarea pesada / Isolate'),
            onTap: () => context.push('/isolate'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Asincronico / Future'),
            onTap: () => context.push('/futuro'),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Universidades CRUD'),
            onTap: () {
              context.go('/universidadesFirebase');
            },
          ),
        ],
      ),
    );
  }
}
