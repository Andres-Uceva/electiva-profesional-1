import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Hola, Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Título actualizado')),
    );
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
                Image.asset(
                  'assets/paisaje.jpg',
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _toggleTitle,
              child: const Text('Cambiar título'),
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
