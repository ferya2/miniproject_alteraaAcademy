import 'package:dio/dio.dart';
import 'package:weather_app/models/city_data.dart';

Future<List<City>> fetchKota(String apiKey, String provinceId) async {
  final dio = Dio();
  final response = await dio.get(
      'https://api.goapi.id/v1/regional/kota?api_key=$apiKey&provinsi_id=$provinceId');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data.map((json) => City.fromJson(json)).toList();
  } else {
    throw Exception('Gagal mengambil data kota');
  }
}
