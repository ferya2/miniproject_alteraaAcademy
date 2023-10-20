import 'package:flutter/material.dart';

class RoundedRectangleWeatherCard extends StatelessWidget {
  final String title;
  final String value;
  final Color cardColor;
  final String imageAsset;

  RoundedRectangleWeatherCard({
    required this.title,
    required this.value,
    required this.cardColor,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [
              cardColor,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          // Menggunakan Row untuk menempatkan elemen secara horizontal
          children: <Widget>[
            Image.asset(
              imageAsset,
              width: 48,
              height: 48,
            ),
            SizedBox(width: 8.0), // Memberikan jarak horizontal antara elemen
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Menempatkan teks ke sisi kiri
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0), // Memberikan jarak vertikal antara teks
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
