import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:weather_app/models/indonesia_data.dart';

Future<List<IndonesianCity>> loadIndonesianCities() async {
  final String jsonString =
      await rootBundle.loadString('assets/json/city.list.min.json');
  final List<dynamic> jsonList = json.decode(jsonString);

  final List<IndonesianCity> indonesianCities = jsonList
      .where((city) => city['country'] == 'ID')
      .map((city) => IndonesianCity.fromJson(city))
      .toList();

  return indonesianCities;
}
