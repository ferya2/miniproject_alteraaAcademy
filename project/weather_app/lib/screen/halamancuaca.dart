import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/api/fetch_forecast.dart';
import 'package:weather_app/models/api/fetch_weather.dart';
import 'package:weather_app/models/open_ai_model.dart';
import 'package:weather_app/screen/favorite.dart';
import 'package:weather_app/screen/news_info.dart';
import 'package:weather_app/services/recomendation_services.dart';
import 'package:weather_app/screen/detailforecast.dart';
import 'package:weather_app/screen/recomended.dart';

class CurrentWeatherPage extends StatefulWidget {
  final String city; // Parameter

  CurrentWeatherPage({
    // Constructor
    required this.city,
    Key? key,
  }) : super(key: key);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  WeatherApiClient weatherApiClient =
      WeatherApiClient(apiKey); // Instance get apiKey
  ForecastApiClient forecastApiClient =
      ForecastApiClient(apiKey); // Instance get apiKey

  Map<String, dynamic> weatherData = {}; // Instance
  Map<String, dynamic> forecastData = {}; // Instance

  // Inisialisasi state dan properti yang diperlukan
  int _currentIndex = 0;
  String _currentMenu = 'Home';

// Metode untuk mengubah item yang dipilih pada bottom navigation bar
  void _changeSelectedNavBar(int index) {
    setState(() {
      _currentIndex = index;
      _currentMenu = index == 0 ? 'Home' : 'News';
    });

    // Handle perpindahan halaman atau tindakan lain sesuai kebutuhan
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CurrentWeatherPage(
            // Set route
            city: widget.city,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BeritaGempa(city: widget.city),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritePage(city: widget.city),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeatherData(); // Load weather data
    _loadForecastData(); // Load forecast data
  }

  // Function to load weather data
  void _loadWeatherData() async {
    final city = widget.city; // Get city
    final data = await weatherApiClient.getCurrentWeather(city); // Get data
    setState(() {
      weatherData = data; // Set state
    });
  }

  // Function to load forecast data
  void _loadForecastData() async {
    final city = widget.city; // Get city
    final data = await forecastApiClient.get5DayForecast(city); // Get data
    setState(() {
      forecastData = data; // Set state
    });
  }

  // Function to get recommendation
  void _getRecommendation() async {
    GPTData result = await RecomendationService.getRecommendation(
      // Get data
      city: widget.city, // Get city
      deskripsiCuaca: weatherData['weather'] != null
          ? weatherData['weather'][0]['description'] // Get description
          : 'Cuaca tidak tersedia',
      suhu: weatherData['main'] != null
          ? '${weatherData['main']['temp']} °C'
          : 'Suhu tidak tersedia', // Get temperature
    );
    String recommendation = result.choices[0].text; // Get recommendation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecomendedPage(result: recommendation), // Push to RecomendedPage
      ),
    );
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
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            _getRecommendation(); // Push to RecomendedPage
          },
          child: Icon(Icons.add_home_work_sharp,
              size: 24, color: Colors.blueAccent),
          backgroundColor: Colors.white,
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
                      widget.city, // Get city
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
                          ? weatherData['weather'][0]
                              ['description'] // Get description
                          : 'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: weatherData['weather'] != null // Get icon
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
                          weatherData['main'] != null // Get temperature
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
                        // Get temp max
                        Icons.arrow_drop_up_outlined,
                        weatherData['main'] != null
                            ? '${weatherData['main']['temp_max']} °C'
                            : 'Loading...',
                      ),
                      _buildWeatherInfoCard(
                        // Get temp min
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
                        Icons.water, // Get humidity
                        weatherData['main'] != null
                            ? '${weatherData['main']['humidity']}%'
                            : 'Loading...',
                      ),
                      _buildWeatherInfoCard(
                        // Get wind
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
            _buildForecastSection(), // Get forecast data
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 50, 84, 132),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _changeSelectedNavBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoCard(IconData icon, String data) {
    // Function to build weather info card
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

  // Function to build forecast section
  Widget _buildForecastSection() {
    if (forecastData['list'] == null) {
      // Check if forecast data is null
      return CircularProgressIndicator(); // Return loading indicator
    }

    final now = DateTime.now(); // Mendapatkan waktu saat ini
    final today = DateFormat('EEEE', 'id_ID')
        .format(now); // Mengidentifikasi hari saat ini

    final filteredForecast = (forecastData['list'] as List).where((forecast) {
      // Filter forecast
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          forecast['dt'] * 1000); // Get date time
      final day = DateFormat('EEEE', 'id_ID').format(dateTime); // Get day
      final isTodayOrLater = dateTime.isAfter(now) ||
          dateTime
              .isAtSameMomentAs(now); // Check if date time is today or later

      return today == day && isTodayOrLater; // Return filtered forecast
    }).toList(); // Get filtered forecast

    return ListView.builder(
      itemCount: filteredForecast.length, // Set item count
      shrinkWrap: true, // Set shrink wrap
      physics: NeverScrollableScrollPhysics(), // Set physics
      itemBuilder: (context, index) {
        // Set item builder
        final forecast = filteredForecast[index]; // Get forecast
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
            forecast['dt'] * 1000); // Get date time
        final day = DateFormat('EEE', 'id_ID').format(dateTime); // Get day
        final time = DateFormat.jm('id_ID').format(dateTime); // Get time

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
                  forecast['weather'][0]['description'] ??
                      'Loading...', // Get description
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                Text(
                  '${forecast['main']['temp']} °C' ??
                      'Loading...', // Get temperature
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                if (forecast['weather'][0]['icon'] != null) // Get icon
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
