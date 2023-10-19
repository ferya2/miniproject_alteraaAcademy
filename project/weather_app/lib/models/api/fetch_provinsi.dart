import 'package:dio/dio.dart';
import 'package:weather_app/models/provinci_data.dart';

Future<List<Provinsi>> fetchProvinsi(String apiKey) async {
  final dio = Dio();
  final response = await dio
      .get('https://api.goapi.id/v1/regional/provinsi?api_key=$apiKey');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data.map((json) => Provinsi.fromJson(json)).toList();
  } else {
    throw Exception('Gagal mengambil data provinsi');
  }
}
