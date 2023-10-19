import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/models/api/fecth_kota.dart';
import 'package:weather_app/models/api/fetch_provinsi.dart';
import 'package:weather_app/models/city_data.dart';
import 'package:weather_app/models/provinci_data.dart';

class ProvinsiKotaPage extends StatefulWidget {
  const ProvinsiKotaPage({Key? key}) : super(key: key);

  @override
  _ProvinsiKotaPageState createState() => _ProvinsiKotaPageState();
}

class _ProvinsiKotaPageState extends State<ProvinsiKotaPage> {
  late List<Provinsi> _provinsiList;
  late List<City> _kotaList;
  TextEditingController _searchController = TextEditingController();
  bool _showProvinsi = true;

  @override
  void initState() {
    super.initState();
    _provinsiList = [];
    _kotaList = [];
    _loadProvinsiFromAPI();
  }

  void _loadProvinsiFromAPI() async {
    try {
      final apiKey = 'b07kQimuvVnnqKxh7L6UOYCS9yHy1W';
      final provinsiList = await fetchProvinsi(apiKey);

      setState(() {
        _provinsiList = provinsiList;
      });
    } catch (e) {
      print('Gagal mengambil data provinsi dari API: $e');
    }
  }

  void _loadKotaFromAPI(Provinsi provinsi) async {
    try {
      final apiKey = 'b07kQimuvVnnqKxh7L6UOYCS9yHy1W';
      final kotaList = await fetchKota(apiKey, provinsi.id);

      setState(() {
        _kotaList = kotaList;
        _showProvinsi = false;
      });
    } catch (e) {
      print('Gagal mengambil data kota dari API: $e');
    }
  }

  void _filterCities(String query) {
    setState(() {
      if (_showProvinsi) {
        // Jika masih menampilkan provinsi, filter daftar provinsi.
        if (query.isEmpty) {
          // Jika isian pencarian kosong, isi ulang daftar provinsi.
          _loadProvinsiFromAPI();
        } else {
          _provinsiList = _provinsiList.where((provinsi) {
            return provinsi.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
      } else {
        // Jika menampilkan kota, filter daftar kota.
        if (query.isEmpty) {
          // Jika isian pencarian kosong, isi ulang daftar kota.
          _loadKotaFromAPI(_provinsiList[
              0]); // Anda dapat menggunakan provinsi pertama sebagai referensi.
        } else {
          _kotaList = _kotaList.where((city) {
            return city.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: GoogleFonts.poppins(fontSize: 17, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 50, 84, 132),
        centerTitle: true,
        elevation: 0.0,
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
                hintText: _showProvinsi ? "Cari Provinsi" : "Cari Kota",
                hintStyle: GoogleFonts.poppins(fontSize: 15),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Daftar Provinsi/Kota
          Expanded(
            child: ListView.builder(
              itemCount:
                  _showProvinsi ? _provinsiList.length : _kotaList.length,
              itemBuilder: (context, index) {
                if (_showProvinsi) {
                  final provinsi = _provinsiList[index];
                  return ListTile(
                    title: Text(provinsi.name),
                    onTap: () {
                      _loadKotaFromAPI(provinsi);
                    },
                  );
                } else {
                  final city = _kotaList[index];
                  return ListTile(
                    title: Text(city.name),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
