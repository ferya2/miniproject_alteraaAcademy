import 'package:flutter/material.dart';
import 'package:weather_app/screen/city_screen.dart';
import 'package:weather_app/screen/getstarted.dart';
import 'package:weather_app/screen/halamancuaca.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  Intl.defaultLocale = 'id_ID';
  initializeDateFormatting().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/get_started',
      routes: {
        '/get_started': (context) => GetStarted(),
        '/select_city': (context) => CityScreen(),
        '/current_weather': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return CurrentWeatherPage(city: args['city']!);
        },
      },
    );
  }
}
