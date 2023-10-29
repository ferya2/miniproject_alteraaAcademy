class IndonesianCity {
  final int id;
  final String name;
  final String country;
  final Coord coord;

  IndonesianCity({
    required this.id,
    required this.name,
    required this.country,
    required this.coord,
  });

  factory IndonesianCity.fromJson(Map<String, dynamic> json) {
    return IndonesianCity(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      coord: Coord.fromJson(json['coord']),
    );
  }
}

class Coord {
  final double lon;
  final double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}
