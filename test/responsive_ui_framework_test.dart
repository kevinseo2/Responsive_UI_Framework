import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_ui_framework/framework/responsive_layout.dart';
import 'package:responsive_ui_framework/framework/resolution_simulator.dart';

void main() {
  group('ResponsiveLayout Tests', () {
    testWidgets('renders default layout when no matching ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            child: Container(child: const Text('Default')),
            layoutBuilders: const {},
          ),
        ),
      );

      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets('renders correct layout for aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            child: Container(child: const Text('Default')),
            layoutBuilders: {
              ScreenAspectRatio.ratio16x9: (context) => 
                Container(child: const Text('16:9 Layout')),
            },
          ),
        ),
      );

      expect(find.text('16:9 Layout'), findsOneWidget);
      expect(find.text('Default'), findsNothing);
    });
  });

  group('ResolutionSimulator Tests', () {
    testWidgets('shows child when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResolutionSimulator(
            enabled: false,
            child: Container(child: const Text('Child Widget')),
          ),
        ),
      );

      expect(find.text('Child Widget'), findsOneWidget);
      expect(find.byType(Slider), findsNothing);
    });

    testWidgets('shows simulator controls when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResolutionSimulator(
            enabled: true,
            child: Container(child: const Text('Child Widget')),
          ),
        ),
      );

      expect(find.text('Child Widget'), findsOneWidget);
      expect(find.text('Aspect Ratio:'), findsOneWidget);
      expect(find.text('Width:'), findsOneWidget);
      expect(find.text('Height:'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(2));
      expect(find.byType(DropdownButton<ScreenAspectRatio>), findsOneWidget);
    });

    testWidgets('changes size on slider update', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResolutionSimulator(
            enabled: true,
            child: Container(child: const Text('Child Widget')),
          ),
        ),
      );

      final Slider widthSlider = tester.widget(find.byType(Slider).first);
      expect(widthSlider.value, equals(1920));

      await tester.drag(find.byType(Slider).first, const Offset(20.0, 0.0));
      await tester.pumpAndSettle();

      final Slider updatedWidthSlider = tester.widget(find.byType(Slider).first);
      expect(updatedWidthSlider.value, isNot(equals(1920)));
    });
  });
}
