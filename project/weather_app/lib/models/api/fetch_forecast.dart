import 'package:dio/dio.dart';

class ForecastApiClient {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  ForecastApiClient(this.apiKey);

  Future<Map<String, dynamic>> get5DayForecast(String city) async {
    try {
      final response = await Dio().get(
        '$baseUrl?q=$city&appid=$apiKey&units=metric&lang=id',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return data;
      } else {
        throw Exception('Failed to load 5-day forecast');
      }
    } catch (e) {
      throw Exception('Error loading 5-day forecast: $e');
    }
  }
}
