import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('All required widgets are present', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    
    expect(find.text('Начальная скорость (м/с)'), findsOneWidget);
    expect(find.text('Конечная скорость (м/с)'), findsOneWidget);
    expect(find.text('Время (секунды)'), findsOneWidget);
    expect(find.text('Согласен на обработку данных'), findsOneWidget);
    expect(find.text('Рассчитать ускорение'), findsOneWidget);
  });

  testWidgets('Navigation to results works', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    
    // Заполняем все поля
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '0');
    await tester.enterText(fields.at(1), '20');
    await tester.enterText(fields.at(2), '5');
    
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    
    await tester.tap(find.text('Рассчитать ускорение'));
    await tester.pumpAndSettle();
    
    // Проверяем что перешли на экран результатов
    expect(find.text('Результаты расчета'), findsOneWidget);
  });
}