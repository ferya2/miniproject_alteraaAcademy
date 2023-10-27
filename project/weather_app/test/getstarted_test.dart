import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/screen/getstarted.dart';




void main() {
  testWidgets('Nama Button harus ...', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GetStarted(),
    ));

    
    await tester.pump();

    expect(find.text('Get Started'), findsOneWidget);
    
  });
}