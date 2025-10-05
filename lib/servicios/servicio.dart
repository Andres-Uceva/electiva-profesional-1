class Servicio {
  static Future<String> obtenerDatos() async {
    await Future.delayed(const Duration(seconds: 3));
    if (DateTime.now().second.isEven) {
      return "Datos cargados correctamente";
    } else {
      throw Exception("Fallo al cargar datos");
    }
  }
}