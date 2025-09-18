import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(title: 'Hola Flutter'),
    ),
    GoRoute(
      path: '/primaria',
      builder: (context, state) => TextoPrimera(),
    ),
    GoRoute(
      path: '/secundaria',
      builder: (context, state) => Secundaria(),
    ),
  ],
);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TextoPrimera extends StatelessWidget {
  final TextEditingController _controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Primera pantalla'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24),
            TextField(
              controller: _controlador,
              decoration: InputDecoration(
                labelText: 'Escribe algo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/secundaria',
                      extra: _controlador.text),
                  child: const Text('Go secundaria'),
                ),
                ElevatedButton(
                  onPressed: () => context.push('/secundaria',
                      extra: _controlador.text),
                  child: const Text('Push secundaria'),
                ),
                ElevatedButton(
                  onPressed: () => context.replace('/secundaria',
                      extra: _controlador.text),
                  child: const Text('Replace secundaria'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}

class Secundaria extends StatelessWidget {

  const Secundaria({super.key});

  @override
  Widget build(BuildContext context) {
    final mensaje = GoRouterState.of(context).extra as String?;

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla secundaria'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.cloud_outlined)),
              Tab(icon: Icon(Icons.beach_access_sharp)),
              Tab(icon: Icon(Icons.brightness_5_sharp)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: Text(mensaje!)),
            Center(child: EjemploGrid(key: key)),
            Center(child: CicloDeVidaDemo()),
          ],
        ),
      ),
    );
  }
}

class EjemploGrid extends StatelessWidget {
  const EjemploGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      crossAxisCount: 3,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
          child: const Text("Elemento A"),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[200],
          child: const Text('Elemento B'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[300],
          child: const Text('Elemento C'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[400],
          child: const Text('Elemento D'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[500],
          child: const Text('Elemento E'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[600],
          child: const Text('Elemento F'),
        ),
      ],
    );
  }
}

class CicloDeVidaDemo extends StatefulWidget {
  @override
  State<CicloDeVidaDemo> createState() => _CicloDeVidaDemoState();
}

class _CicloDeVidaDemoState extends State<CicloDeVidaDemo> {
  int contador = 0;

  @override
  void initState() {
    super.initState();
    print('initState() -> Se ejecuta al crear el widget');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies() -> Se ejecuta cuando las dependencias cambian');
  }

  @override
  Widget build(BuildContext context) {
    print('build() -> Se ejecuta cada vez que el widget se construye');
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contador: $contador'),
            ElevatedButton(
              onPressed: () {
                print('setState() -> Se llamó a setState()');
                setState(() {
                  contador++;
                });
              },
              child: Text('Incrementar'),
            ),
          ],
        ),
      );
  }

  @override
  void dispose() {
    print('dispose() -> Se ejecuta cuando el widget se elimina');
    super.dispose();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String _appBarTitle = 'Hola, Flutter';
  final String _studentName = 'Andres Felipe Bonilla Botero';

  void _toggleTitle() {
    setState(() {
      _appBarTitle = _appBarTitle == 'Hola, Flutter'
          ? '¡Título cambiado!'
          : 'Hola, Flutter';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Título actualizado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _studentName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuLXbHX3UYg82Z1noPDhTvp6qvxGB5WlMzvQ&s',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 16),
                Image.asset('assets/paisaje.jpg', width: 80, height: 80),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _toggleTitle,
              child: const Text('Cambiar título'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/primaria'),
              child: const Text('Ir a pantalla primaria'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Elemento 1'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Elemento 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.coffee),
                    title: Text('Elemento 3'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
