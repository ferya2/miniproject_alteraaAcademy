import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/models/api/fetch_weather.dart';

class DetailForecast extends StatefulWidget {
  final String city;

  DetailForecast({Key? key, required this.city}) : super(key: key);

  @override
  _DetailForecastState createState() => _DetailForecastState();
}

class _DetailForecastState extends State<DetailForecast> {
  List<Map<String, dynamic>> forecastData = [];
  WeatherApiClient weatherApiClient = WeatherApiClient(apiKey);

  @override
  void initState() {
    super.initState();
    _loadForecastData();
  }

  void _loadForecastData() async {
    final city = widget.city;
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&lang=id';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        forecastData = (data['list'] as List).cast<Map<String, dynamic>>();
      });
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Perkiraan Cuaca',
          style: GoogleFonts.poppins(fontSize: 17, color: Colors.black),
        ),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        elevation: 5,
      ),
      body: _buildForecastList(),
    );
  }

  Widget _buildForecastList() {
    return ListView.builder(
      itemCount: forecastData.length,
      itemBuilder: (context, index) {
        final forecast = forecastData[index];
        final dateTime =
            DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
        final day = DateFormat('EEE', 'id_ID').format(dateTime);
        final time = DateFormat.jm('id_ID').format(dateTime);

        return Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.white70],
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.0,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day,
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ],
                ),
                Text(
                  forecast['weather'][0]['description'] ?? 'Loading...',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                Text(
                  '${forecast['main']['temp']} °C' ?? 'Loading...',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                if (forecast['weather'][0]['icon'] != null)
                  Image.network(
                    'https://openweathermap.org/img/wn/${forecast['weather'][0]['icon']}.png',
                    width: 50,
                    height: 50,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
