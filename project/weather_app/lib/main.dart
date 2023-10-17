import 'package:flutter/material.dart';
import 'package:weather_app/db/city_db.dart';
import 'package:weather_app/screen/getstarted.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Buka database
  final database = await CityDatabase.database;

  // Mengambil data kota
  final citiesFromDatabase = await CityDatabase.getCities();

  // Cetak nama-nama kota
  for (final city in citiesFromDatabase) {
    print('Nama Kota: ${city.name}');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStarted(),
    );
  }
}
