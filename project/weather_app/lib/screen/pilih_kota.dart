import 'package:flutter/material.dart';
import 'package:weather_app/db/city_db.dart';
import 'package:weather_app/models/city_data.dart';

class PilihKotaPage extends StatefulWidget {
  const PilihKotaPage({Key? key}) : super(key: key);

  @override
  _PilihKotaPageState createState() => _PilihKotaPageState();
}

class _PilihKotaPageState extends State<PilihKotaPage> {
  late List<City> _filteredCities;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCities = [];
    _loadCities();
  }

  void _loadCities() async {
    final cities = await CityDatabase.getCities();
    setState(() {
      _filteredCities = cities;
    });
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = _filteredCities.where((city) {
        return city.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Kota"),
      ),
      body: Column(
        children: <Widget>[
          // Kotak Pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _filterCities(query);
              },
              decoration: InputDecoration(
                hintText: "Cari Kota",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Daftar Kota
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                final city = _filteredCities[index];
                return ListTile(
                  title: Text(city.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
