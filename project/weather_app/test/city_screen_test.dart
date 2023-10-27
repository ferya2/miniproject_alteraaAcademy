import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/screen/city_screen.dart';

void main() {
  testWidgets('Judul halaman harus ...', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: CityScreen(),
    ));

    
    await tester.pump();

    expect(find.text('Pilih Kota'), findsOneWidget);
    expect(find.text('Cari Kota'), findsOneWidget);
  });
}
