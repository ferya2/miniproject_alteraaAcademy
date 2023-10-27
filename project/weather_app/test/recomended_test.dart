import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



import 'package:weather_app/screen/recomended.dart';

void main() {
  testWidgets('Judul halaman harus ...', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RecomendedPage(result: '',),
    ));

    
    await tester.pump();

    expect(find.text('Rekomendasi Aktivitas (AI)'), findsOneWidget);
    
  });
}