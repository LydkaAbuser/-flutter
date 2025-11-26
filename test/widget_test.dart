import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Калькулятор ускорения - Прокопенко Илья Андреевич'), findsOneWidget);
  });

  testWidgets('Input fields are present', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    
    expect(find.text('Начальная скорость (м/с)'), findsOneWidget);
    expect(find.text('Конечная скорость (м/с)'), findsOneWidget);
    expect(find.text('Время (секунды)'), findsOneWidget);
    expect(find.text('Согласен на обработку данных'), findsOneWidget);
  });
}