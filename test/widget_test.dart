// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindmap_mini/main.dart';
import 'package:mindmap_mini/services/map_manager.dart';

void main() {
  testWidgets('MindMap Mini app smoke test', (WidgetTester tester) async {
    // Create a map manager for testing
    final mapManager = MapManager();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(mapManager: mapManager));

    // Verify that the app title is displayed
    expect(find.text('MindMap Mini'), findsOneWidget);
  });
}
