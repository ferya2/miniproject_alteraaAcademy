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
          style: GoogleFonts.poppins(fontSize: 17, color: Colors.black),
        ),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white70],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset: Offset(15, 15),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                          : 'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        letterSpacing: 3,
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
                        : CircularProgressIndicator(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.thermostat_auto_outlined, size: 24),
                        SizedBox(width: 5),
                        Text(
                          weatherData['main'] != null
                              ? '${weatherData['main']['temp']} °C'
                              : 'Loading...',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildWeatherInfoCard(
                    Icons.arrow_circle_up_rounded,
                    weatherData['main'] != null
                        ? '${weatherData['main']['temp_max']} °C'
                        : 'Loading...',
                  ),
                  _buildWeatherInfoCard(
                    Icons.arrow_drop_down_circle_outlined,
                    weatherData['main'] != null
                        ? '${weatherData['main']['temp_min']} °C'
                        : 'Loading...',
                  ),
                  _buildWeatherInfoCard(
                    Icons.water,
                    weatherData['main'] != null
                        ? '${weatherData['main']['humidity']}%'
                        : 'Loading...',
                  ),
                  _buildWeatherInfoCard(
                    Icons.wind_power_outlined,
                    weatherData['wind'] != null
                        ? '${weatherData['wind']['speed']} m/s'
                        : 'Loading...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfoCard(IconData icon, String data) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white70],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.black),
          SizedBox(height: 5),
          Text(
            data,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
