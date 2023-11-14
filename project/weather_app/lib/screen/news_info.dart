import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/screen/favorite.dart';
import 'package:weather_app/screen/halamancuaca.dart';

class BeritaGempa extends StatefulWidget {
  final String city;

  const BeritaGempa({Key? key, required this.city}) : super(key: key);

  @override
  _BeritaGempaState createState() => _BeritaGempaState();
}

class _BeritaGempaState extends State<BeritaGempa> {
  Map<String, dynamic>? _beritaGempa;

  @override
  void initState() {
    super.initState();
    _fetchBeritaGempa();
  }

  Future<void> _fetchBeritaGempa() async {
    try {
      final response = await http
          .get(Uri.parse('https://cuaca-gempa-rest-api.vercel.app/quake'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        setState(() {
          _beritaGempa = data;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Berita Gempa",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 50, 84, 132),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _beritaGempa == null
          ? Center(child: CircularProgressIndicator())
          : _buildBeritaGempaCard(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 50, 84, 132),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: 1,
        onTap: (index) {
          // Tambahkan logika untuk menangani perpindahan halaman jika diperlukan
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
            currentIndex:
            1;
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritePage(
                  city: widget.city,
                ),
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

  Widget _buildBeritaGempaCard() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                "Gempa pada ${_beritaGempa!['tanggal']} ${_beritaGempa!['jam']} WIB",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Kedalaman: ${_beritaGempa!['kedalaman']}",
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            ListTile(
              title: Text(
                "Magnitude: ${_beritaGempa!['magnitude']}",
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                "Koordinat: ${_beritaGempa!['lintang']}, ${_beritaGempa!['bujur']}",
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            ListTile(
              title: Text(
                "Wilayah: ${_beritaGempa!['wilayah']}",
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                "Dirasakan: ${_beritaGempa!['dirasakan']}",
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            ListTile(
              title: Text(
                "Potensi: ${_beritaGempa!['potensi']}",
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            if (_beritaGempa!['shakemap'] != null)
              Image.network(_beritaGempa!['shakemap']),
          ],
        ),
      ),
    );
  }
}
