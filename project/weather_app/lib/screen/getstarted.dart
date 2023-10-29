import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screen/city_screen.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screenWidth * 0.5,
              height: screenWidth * 0.5,
              child: Image(image: AssetImage('assets/images/gunungfuji.png')),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Menambahkan spasi di kiri dan kanan
              child: Text(
                "Ayo Cek perkiraan cuaca terbaru di seluruh kota-kota Indonesia dengan mudah !",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CityScreen(),
                  ),
                );
              },
              child: Text(
                "Get Started",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
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
          ],
        ),
      ),
    );
  }
}
