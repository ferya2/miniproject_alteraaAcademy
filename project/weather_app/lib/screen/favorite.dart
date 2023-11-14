import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/models/api/fetch_weather.dart';
import 'package:weather_app/models/indonesia_data.dart';
import 'package:weather_app/screen/halamancuaca.dart';
import 'package:weather_app/screen/news_info.dart';

class FavoritePage extends StatefulWidget {
  final String city;

  const FavoritePage({Key? key, required this.city}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> selectedCities = [];
  List<String> searchResults = [];
  List<IndonesianCity> indonesianCities = [];

  late WeatherApiClient weatherApiClient;

  @override
  void initState() {
    super.initState();
    weatherApiClient = WeatherApiClient(apiKey);
    _loadIndonesianCities();
  }

  void _loadIndonesianCities() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/city.list.min.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    indonesianCities = jsonList
        .where((city) => city['country'] == 'ID')
        .map((city) => IndonesianCity.fromJson(city))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite City",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 50, 84, 132),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddCityDialog(context);
            },
          ),
        ],
      ),
      body: _buildWeatherInfoList(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 50, 84, 132),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: 2,
        onTap: (index) {
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
          }
        },
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

  Widget _buildWeatherInfoList() {
    return ListView.builder(
      itemCount: selectedCities.length,
      itemBuilder: (context, index) {
        final cityName = selectedCities[index];
        return _buildWeatherInfoCard(cityName);
      },
    );
  }

  Widget _buildWeatherInfoCard(String cityName) {
    return FutureBuilder(
      // Get weather data from the API
      future: weatherApiClient.getCurrentWeather(cityName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for data
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Display an error message if an error occurs
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(cityName),
              subtitle: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(), // Gaya teks menggunakan Poppins
              ),
            ),
          );
        } else {
          // Build a widget with the received weather data
          final weatherData = snapshot.data as Map<String, dynamic>;
          final weatherDescription = weatherData['weather'][0]['description'];
          final weatherIconCode = weatherData['weather'][0]['icon'];
          final temperature = weatherData['main']['temp'];
          final windSpeed = weatherData['wind']['speed'];

          // Build URL ikon cuaca dari kode ikon
          final iconUrl =
              'https://openweathermap.org/img/wn/$weatherIconCode.png';

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                cityName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weather Description:",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Row(
                    children: [
                      // Display the weather icon using Image.network
                      Image.network(iconUrl, width: 30, height: 30),
                      SizedBox(width: 8),
                      Text(
                        weatherDescription,
                        style: GoogleFonts
                            .poppins(), // Gaya teks menggunakan Poppins
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Temperature: $temperature°C",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Wind Speed: $windSpeed m/s",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(cityName);
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCitySearchList() {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.6,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final result in searchResults)
              ListTile(
                title: Text(result),
                onTap: () async {
                  bool addCity = await _showConfirmationDialog(context, result);

                  if (addCity) {
                    setState(() {
                      selectedCities.add(result);
                      searchResults = [];
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String cityName) async {
    bool addCity = false;

    try {
      final weatherData = await weatherApiClient.getCurrentWeather(cityName);

      final weatherDescription = weatherData['weather'][0]['description'];
      final weatherIcon = weatherData['weather'][0]['icon'];
      final temperature = weatherData['main']['temp'];
      final windSpeed = weatherData['wind']['speed'];

      print('$weatherDescription');
      print('$weatherIcon');
      print('Temperature: $temperature');
      print('Wind Speed: $windSpeed');

      addCity = true;
    } catch (error) {
      print('Error fetching weather data: $error');
    }

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Tambah Kota"),
              content:
                  Text("Apakah Anda ingin menambahkan $cityName ke favorit?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(addCity);
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showDeleteConfirmationDialog(String cityName) async {
    bool deleteCity = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Hapus Kota"),
              content:
                  Text("Apakah Anda ingin menghapus $cityName dari favorit?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;

    if (deleteCity) {
      setState(() {
        selectedCities.remove(cityName);
      });
    }
  }

  List<String> _filterCities(String query) {
    return indonesianCities
        .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
        .map((city) => city.name)
        .toList();
  }

  void _showAddCityDialog(BuildContext context) async {
    String? selectedCity = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Tambah Kota"),
              content: Column(
                children: [
                  TextField(
                    onChanged: (query) {
                      setState(() {
                        searchResults = _filterCities(query);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Cari Kota',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  _buildCitySearchList(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Batal"),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedCity != null) {
      bool addCity = await _showConfirmationDialog(context, selectedCity);

      if (addCity) {
        setState(() {
          selectedCities.add(selectedCity);
        });
      }
    }
  }
}
