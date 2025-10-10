import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:taller1/modelos/pokemon.dart';

class ServicioPokemon {

  String apiUrl = dotenv.env['POKEMON_API_URL']!;

  Future<List<Pokemon>> fetchPokemons() async {
    int limit = 10;
    debugPrint('Estado: CARGANDO pokemones...');
    try {
      final response = await http.get(Uri.parse('$apiUrl/pokemon?limit=$limit'));
      if (response.statusCode == 200) {
        debugPrint('Estado: ÉXITO al obtener lista de pokemones');
        final List<dynamic> jsonData = json.decode(response.body)['results'];
        List<Future<Pokemon>> futures = jsonData.map((item) {
          return fetchPokemonDetail(item['url']);
        }).toList();
        return await Future.wait(futures);
      } else {
        debugPrint('Estado: ERROR al obtener lista de pokemones. Código: ${response.statusCode}');
        throw Exception('Error al obtener la lista de pokemones. Código: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Estado: ERROR de red o formato: $e');
      throw Exception('Error de red o formato: $e');
    }
  }

  Future<Pokemon> fetchPokemonDetail(String url) async {
    debugPrint('Estado: CARGANDO detalle de pokemon...');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        debugPrint('Estado: ÉXITO al obtener detalle de pokemon');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Pokemon.fromJson(jsonData);
      } else {
        debugPrint('Estado: ERROR al obtener detalle del pokemon. Código: ${response.statusCode}');
        throw Exception('Error al obtener detalles del pokemon. Código: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Estado: ERROR de red o formato en detalle: $e');
      throw Exception('Error de red o formato en detalle: $e');
    }
  }

}