import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/api/fetch_forecast.dart';
import 'package:weather_app/models/api/fetch_weather.dart';
import 'package:weather_app/models/open_ai_model.dart';
import 'package:weather_app/services/recomendation_services.dart';
import 'package:weather_app/screen/detailforecast.dart';
import 'package:weather_app/screen/recomended.dart';

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
  WeatherApiClient weatherApiClient = WeatherApiClient(apiKey);
  ForecastApiClient forecastApiClient = ForecastApiClient(apiKey);

  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> forecastData = {};

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    _loadForecastData();
  }

  void _loadWeatherData() async {
    final city = widget.city;
    final data = await weatherApiClient.getCurrentWeather(city);
    setState(() {
      weatherData = data;
    });
  }

  void _loadForecastData() async {
    final city = widget.city;
    final data = await forecastApiClient.get5DayForecast(city);
    setState(() {
      forecastData = data;
    });
  }

  void _getRecommendation() async {
    GPTData result = await RecomendationService.getRecommendation(
      city: widget.city,
      deskripsiCuaca: weatherData['weather'] != null
          ? weatherData['weather'][0]['description']
          : 'Cuaca tidak tersedia',
      suhu: weatherData['main'] != null
          ? '${weatherData['main']['temp']} °C'
          : 'Suhu tidak tersedia',
    );
    String recommendation = result.choices[0].text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecomendedPage(result: recommendation),
      ),
    );
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            _getRecommendation();
          },
          child: Icon(Icons.add_home_work_sharp, size: 24, color: Colors.white),
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWeatherInfoCard(
                        Icons.arrow_drop_up_outlined,
                        weatherData['main'] != null
                            ? '${weatherData['main']['temp_max']} °C'
                            : 'Loading...',
                      ),
                      _buildWeatherInfoCard(
                        Icons.arrow_drop_down_outlined,
                        weatherData['main'] != null
                            ? '${weatherData['main']['temp_min']} °C'
                            : 'Loading...',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Perkiraan Cuaca",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildForecastSection(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailForecast(city: widget.city),
                  ),
                );
              },
              child: Text(
                "Detail Perkiraan Cuaca",
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 50, 84, 132)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
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

  Widget _buildForecastSection() {
    if (forecastData['list'] == null) {
      return CircularProgressIndicator();
    }

    final now = DateTime.now();
    final today = DateFormat('EEEE', 'id_ID')
        .format(now); // Mengidentifikasi hari saat ini

    final filteredForecast = (forecastData['list'] as List).where((forecast) {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      final day = DateFormat('EEEE', 'id_ID').format(dateTime);
      final isTodayOrLater =
          dateTime.isAfter(now) || dateTime.isAtSameMomentAs(now);

      return today == day && isTodayOrLater;
    }).toList();

    return ListView.builder(
      itemCount: filteredForecast.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final forecast = filteredForecast[index];
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
