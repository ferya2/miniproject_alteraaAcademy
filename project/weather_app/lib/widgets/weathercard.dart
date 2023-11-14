import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
