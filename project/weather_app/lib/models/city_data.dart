import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class City {
  final int id;
  final String name;
  final String country;
  final double lon;
  final double lat;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.lon,
    required this.lat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'lon': lon,
      'lat': lat,
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      lon: json['coord']['lon'].toDouble(),
      lat: json['coord']['lat'].toDouble(),
    );
  }
}

class CityData {
  static List<City> cities = [];

  static Future<void> loadCities() async {
    final jsonString = await rootBundle.loadString('assets/json/city.json');
    final List<dynamic> cityList = json.decode(jsonString);

    cities = cityList.map((cityData) => City.fromJson(cityData)).toList();
  }
}
