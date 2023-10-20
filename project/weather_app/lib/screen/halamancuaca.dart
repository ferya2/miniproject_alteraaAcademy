import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/models/api/fetch_weather.dart';

class CurrentWeatherPage extends StatefulWidget {
  final String city;

  CurrentWeatherPage({
    required this.city,
    Key? key,
  }) : super(key: key);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late WeatherApiClient weatherApiClient;
  Map<String, dynamic> weatherData = {};

  @override
  void initState() {
    super.initState();
    weatherApiClient = WeatherApiClient();
    _loadWeatherData();
  }

  void _loadWeatherData() async {
    final city = widget.city;

    try {
      final data = await weatherApiClient.getCurrentWeather(city);

      setState(() {
        this.weatherData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cuaca Saat Ini",
          style: GoogleFonts.poppins(fontSize: 17, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 50, 84, 132),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Text(
                widget.city,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                weatherData['weather'] != null
                    ? weatherData['weather'][0]['description']
                    : 'Loading...', // Tampilkan 'Loading...' jika data cuaca belum ada
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  letterSpacing: 5,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: weatherData['weather'] != null
                  ? Image.network(
                      'https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}.png',
                      width: 100,
                      height: 100,
                    )
                  : CircularProgressIndicator(), // Anda dapat menggunakan CircularProgressIndicator atau widget lain sebagai gantinya
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                weatherData['main'] != null
                    ? '${weatherData['main']['temp']}°'
                    : 'Loading...', // Tampilkan 'Loading...' jika data suhu belum ada
                style: GoogleFonts.poppins(fontSize: 20),
              ),
            ),
            // Menambahkan tampilan lainnya seperti suhu, kelembaban, dll.
          ],
        ),
      ),
    );
  }
}
