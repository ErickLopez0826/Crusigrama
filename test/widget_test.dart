// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App shows Hello, World!', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Crossword Builder',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.blueGrey,
            brightness: Brightness.light,
          ),
          home: Scaffold(
            body: Center(
              child: Text('Hello, World!', style: TextStyle(fontSize: 24)),
            ),
          ),
        ),
      ),
    );

    // Verify that our app shows Hello, World!
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}
