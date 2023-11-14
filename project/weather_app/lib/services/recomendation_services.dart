import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/constant/open_ai.dart';
import 'package:weather_app/models/open_ai_model.dart';
import 'package:weather_app/models/usage_model.dart';

class RecomendationService {
  static Future<GPTData> getRecommendation({
    required String city,
    required String deskripsiCuaca,
    required String suhu,
  }) async {
    late GPTData gptData = GPTData(
      id: "",
      object: "",
      created: 0,
      model: "",
      choices: [],
      usage: UsageModel(
        promptToken: 0,
        completionToken: 0,
        totalToken: 0,
      ),
    );
    
    try {
      var url = Uri.parse("https://api.openai.com/v1/completions");
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Charset": "utf-8",
        "Authorization": "Bearer $apiKey2",
      };
      String prompt =
          "Rekomendasi aktivitas di $city dengan cuaca $deskripsiCuaca dan suhu $suhu adalah: ";
      final data = jsonEncode({
        "model": "text-davinci-003",
        "prompt": prompt,
        "max_tokens": 130,
        "temperature": 0.7,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      });
      final response = await http.post(
        url,
        headers: headers,
        body: data,
      );

      if (response.statusCode == 200) {
        gptData = gptDataFromJson(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    return gptData;
  }
}



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:weather_app/constant/open_ai.dart';
// import 'package:weather_app/models/open_ai_model.dart';
// import 'package:weather_app/models/usage_model.dart';

// class RecomendationService {
//   Future<GPTData> getRecommendation({
//     required String city,
//     required String deskripsiCuaca,
//     required String suhu,
//   }) async {
//     try {
//       var url = Uri.parse("https://api.openai.com/v1/completions");

//       Map<String, String> headers = {
//         "Content-Type": "application/json",
//         "Charset": "utf-8",
//         "Authorization": "Bearer $apiKey2",
//       };

//       String prompt =
//           "Rekomendasi aktivitas di $city dengan cuaca $deskripsiCuaca dan suhu $suhu adalah: ";

//       final data = jsonEncode({
//         "model": "text-davinci-003",
//         "prompt": prompt,
//         "max_tokens": 65,
//         "temperature": 0.7,
//         "top_p": 1,
//         "frequency_penalty": 0,
//         "presence_penalty": 0,
//       });

//       final response = await http.post(
//         url,
//         headers: headers,
//         body: data,
//       );

//       if (response.statusCode == 200) {
//         final gptData = gptDataFromJson(response.body);
//         return gptData;
//       } else {
//         print("Gagal mengambil rekomendasi. Status code: ${response.statusCode}");
//         throw Exception("Gagal mengambil rekomendasi");
//       }
//     } catch (e) {
//       print("Gagal mengambil rekomendasi: $e");
//       throw Exception("Gagal mengambil rekomendasi");
//     }
//   }
// }
