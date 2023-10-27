import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:weather_app/screen/detailforecast.dart';

void main() {
  testWidgets('Judul halaman harus ...', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DetailForecast(city: '',),
    ));

    
    await tester.pump();

    expect(find.text('Detail Perkiraan Cuaca'), findsOneWidget);
    
  });
}