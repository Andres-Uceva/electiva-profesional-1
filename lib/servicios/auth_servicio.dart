import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  // base API tomada desde .env
  final String _base = dotenv.env['API_JWT_URL']!;

  Future<bool> login(String email, String password) async {
    final loginUrl = Uri.parse('$_base/login');
    try {
      if (kDebugMode) print('⏳ Iniciando login para $email -> $loginUrl');
      final resp = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (resp.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(resp.body);

        // Buscar token en la respuesta (ajusta claves según tu API)
        final token = body['access_token'] ?? body['token'] ?? body['data']?['access_token'];
        final user = body['user'] ?? body['data']?['user'] ?? body;

        if (token == null) {
          throw Exception('Token no encontrado en la respuesta');
        }

        // Guardar token en storage seguro
        await _secureStorage.write(key: _tokenKey, value: token);

        // Guardar datos no sensibles en shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', user['name'] ?? user['nombre'] ?? '');
        await prefs.setString('email', user['email'] ?? '');

        if (kDebugMode) print('✅ Login OK, token guardado.');
        return true;
      } else {
        final msg = 'Login fallido: ${resp.statusCode} ${resp.body}';
        if (kDebugMode) print('❌ $msg');
        throw Exception(msg);
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error en login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    if (kDebugMode) print('🚪 Cerrando sesión, limpiando storage y llamando logout remoto si aplica');
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        final logoutUrl = Uri.parse('$_base/logout');
        // Intentar invalidar token en backend (ignorar fallo de red)
        await http.post(
          logoutUrl,
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Error al llamar logout remoto: $e');
      // continuar limpiando storage aunque falle la llamada remota
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final t = await _secureStorage.read(key: _tokenKey);
    return t != null && t.isNotEmpty;
  }

  Future<String?> getToken() async => _secureStorage.read(key: _tokenKey);

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'email': prefs.getString('email') ?? '',
    };
  }

  // Obtener perfil remoto usando /perfil
  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('No token disponible');
    final url = Uri.parse('$_base/perfil');
    final resp = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error obtener perfil: ${resp.statusCode} ${resp.body}');
    }
  }

  // Crear usuario usando /users
  Future<void> createUser(String name, String email, String password) async {
    final url = Uri.parse('$_base/users');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      if (kDebugMode) print('Usuario creado correctamente');
      return;
    }
    throw Exception('Error crear usuario: ${resp.statusCode} ${resp.body}');
  }
}