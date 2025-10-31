import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taller1/servicios/auth_servicio.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

  Future<void> _onLogin() async {
    setState(() => _loading = true);
    try {
      final ok = await _auth.login(_emailCtrl.text.trim(), _passCtrl.text);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login exitoso')));
        context.go('/session');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'), // Botón para regresar a Home
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _onLogin,
            child: _loading ? const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)) : const Text('Iniciar sesión')
          ),
          const SizedBox(height: 12),
          // Botón para crear usuario (navega a /register, crea la ruta si no existe)
          OutlinedButton.icon(
            onPressed: () => context.go('/register'),
            icon: const Icon(Icons.person_add),
            label: const Text('Crear usuario'),
          ),
        ]),
      ),
    );
  }
}