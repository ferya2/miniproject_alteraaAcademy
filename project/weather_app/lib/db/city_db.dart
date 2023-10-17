import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_app/models/city_data.dart';

class CityDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'city_database.db');

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cities(id INTEGER PRIMARY KEY, name TEXT, country TEXT, lon REAL, lat REAL)',
        );
      },
      version: 1,
    );
    return _database!;
  }

  static Future<void> insertCities(List<City> cities) async {
    final db = await database;
    final batch = db.batch();
    for (var city in cities) {
      print('Inserting city: ${city.name}');
      batch.insert(
        'cities',
        city.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  static Future<List<City>> getCities() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('cities');
  final cities = List.generate(maps.length, (i) {
    return City(
      id: maps[i]['id'],
      name: maps[i]['name'],
      country: maps[i]['country'],
      lon: maps[i]['lon'],
      lat: maps[i]['lat'],
    );
  });

  for (final city in cities) {
    print('Nama Kota: ${city.name}');
  }

  return cities;
}
}
