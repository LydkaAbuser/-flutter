import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('AppBar contains correct name', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Лабораторная работа - Прокопенко Илья Андреевич'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Wrap contains exactly 6 containers', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(Container), findsNWidgets(6));
  });

  testWidgets('Each container has margin and icon', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Проверка, что все контейнеры имеют отступы
    final containersWithMargin = find.byWidgetPredicate(
      (widget) => widget is Container && widget.margin != null,
    );
    expect(containersWithMargin, findsNWidgets(6));

    // Проверка, что все контейнеры имеют иконки
    expect(find.byType(Icon), findsNWidgets(6));

    // Проверка конкретные иконки
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.phone), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Containers have correct colors', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Проверка цвета контейнеров
    final redContainer = find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == Colors.red,
    );
    final greenContainer = find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == Colors.green,
    );
    final blueContainer = find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == Colors.blue,
    );

    expect(redContainer, findsOneWidget);
    expect(greenContainer, findsOneWidget);
    expect(blueContainer, findsOneWidget);
  });
}