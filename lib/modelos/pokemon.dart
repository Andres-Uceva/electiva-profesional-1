class Pokemon {
  int id;
  String name;
  String image;
  List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      image: json['sprites']['front_default'],
      types: List<String>.from(json['types'].map((type) => type['type']['name'])),
    );
  }

}