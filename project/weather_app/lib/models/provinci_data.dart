class Provinsi {
  final String id;
  final String name;

  Provinsi({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Provinsi.fromJson(Map<String, dynamic> json) {
    return Provinsi(
      id: json['id'],
      name: json['name'],
    );
  }
}
