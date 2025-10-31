import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taller1/servicios/auth_servicio.dart'; 

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final AuthService _auth = AuthService();
  String _name = '';
  String _email = '';
  bool _hasToken = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    setState(() => _loading = true);
    try {
      final user = await _auth.getUserData();
      final tokenPresent = await _auth.hasToken();
      if (kDebugMode) {
        print('Session load - name:${user['name']} email:${user['email']} token:$tokenPresent');
      }
      setState(() {
        _name = user['name'] ?? '';
        _email = user['email'] ?? '';
        _hasToken = tokenPresent;
      });
    } catch (e) {
      if (kDebugMode) print('Error cargando sesión: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
      context.go('/'); // ir a home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencia de sesión'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${_name.isNotEmpty ? _name : "No registrado"}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Email: ${_email.isNotEmpty ? _email : "No registrado"}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Token: ', style: TextStyle(fontSize: 16)),
                      _hasToken
                          ? const Chip(label: Text('token presente'), backgroundColor: Colors.green)
                          : const Chip(label: Text('sin token'), backgroundColor: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}