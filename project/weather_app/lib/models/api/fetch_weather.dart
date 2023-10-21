// fetch_weather.dart

import 'package:dio/dio.dart';

const String apiKey =
    'YOUR_API_KEY'; 

class WeatherApiClient {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    try {
      final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&lang=id');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error loading weather data: $e');
    }
  }
}
