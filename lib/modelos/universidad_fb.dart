class UniversidadFb {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaweb;

  UniversidadFb({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaweb,
  });

  factory UniversidadFb.fromMap(String id, Map<String, dynamic> data) {
    return UniversidadFb(
      id: id,
      nit: data['nit'] as String,
      nombre: data['nombre'] as String,
      direccion: data['direccion'] as String,
      telefono: data['telefono'] as String,
      paginaweb: data['paginaweb'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'paginaweb': paginaweb,
    };
  }

}
