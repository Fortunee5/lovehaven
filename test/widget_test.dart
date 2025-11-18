// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:celvzlovehaven/main.dart';
import 'package:celvzlovehaven/providers/content_provider.dart';
import 'package:celvzlovehaven/providers/auth_provider.dart';

void main() {
  group('CELVZLOVEHAVEN App Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(MyApp());

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Verify that the app title appears somewhere
      expect(find.textContaining('CELVZLOVEHAVEN'), findsWidgets);
    });

    testWidgets('Navigation header is present', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Check for navigation elements
      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('Footer is present with copyright', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Check for footer copyright text
      expect(find.textContaining('Copyright 2025'), findsWidgets);
    });

    testWidgets('Providers are initialized', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ContentProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  // Test that providers are accessible
                  final contentProvider = Provider.of<ContentProvider>(context);
                  final authProvider = Provider.of<AuthProvider>(context);
                  
                  expect(contentProvider, isNotNull);
                  expect(authProvider, isNotNull);
                  
                  return Container();
                },
              ),
            ),
          ),
        ),
      );
    });
  });
}