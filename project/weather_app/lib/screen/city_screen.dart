import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/models/indonesia_data.dart';
import 'package:weather_app/screen/halamancuaca.dart';
import 'package:weather_app/utils/json_parser.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({Key? key}) : super(key: key);

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<IndonesianCity> _cities = [];
  List<IndonesianCity> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    loadIndonesianCities().then((cities) {
      setState(() {
        _cities = cities;
        _filteredCities = List.from(cities);
      });
    });
  }

  void searchCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = List.from(_cities);
      } else {
        _filteredCities = _cities
            .where(
                (city) => city.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pilih Kota",
          style: GoogleFonts.poppins(fontSize: 17, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 50, 84, 132),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                searchCities(query);
              },
              decoration: InputDecoration(
                hintText: "Cari Kota",
                hintStyle: GoogleFonts.poppins(fontSize: 15),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredCities[index].name),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrentWeatherPage(
                          city: _filteredCities[index].name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
