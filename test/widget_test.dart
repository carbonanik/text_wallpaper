// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:text_wallpaper/main.dart';
import 'package:text_wallpaper/providers/todo_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final todoProvider = TodoProvider();
    await tester.pumpWidget(MyApp(todoProvider: todoProvider));

    // Verify that the app builds without errors
    expect(find.text('Text Wallpaper'), findsOneWidget);
  });
}
