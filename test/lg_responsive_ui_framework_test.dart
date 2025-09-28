import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';

void main() {
  group('LG Responsive UI Framework Tests', () {
    testWidgets('ResponsiveContainer renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayoutProvider(
            child: BoxContainer(
              containerId: 'test-container',
              containerName: 'Test Container',
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('AspectRatioCategory detection works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayoutProvider(
            child: ResponsiveConfigBuilder(
              builder: (context, config, category) {
                return Text('Category: ${category.displayName}');
              },
            ),
          ),
        ),
      );

      expect(find.textContaining('Category:'), findsOneWidget);
    });

    testWidgets('ResponsiveUISimulator renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveUISimulator(
            child: const Text('Simulator Test'),
          ),
        ),
      );

      expect(find.text('Simulator Test'), findsOneWidget);
    });

    testWidgets('AspectRatioSelector renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AspectRatioSelector(
              selectedAspectRatio: AspectRatioCategory.wide,
              onAspectRatioChanged: (category) {},
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatioSelector), findsOneWidget);
    });
  });

  group('AspectRatioCategory Tests', () {
    test('fromSize returns correct category for 16:9', () {
      final size = Size(1920, 1080);
      final category = AspectRatioCategory.fromSize(size);
      expect(category, AspectRatioCategory.ultraWide);
    });

    test('fromSize returns correct category for 21:9', () {
      final size = Size(2560, 1080);
      final category = AspectRatioCategory.fromSize(size);
      expect(category, AspectRatioCategory.ultraWide);
    });

    test('fromString returns correct category', () {
      final category = AspectRatioCategory.fromString('16:9');
      expect(category, AspectRatioCategory.ultraWide);
    });

    test('isSupported returns true for valid aspect ratios', () {
      expect(AspectRatioCategory.isSupported('16:9'), isTrue);
      expect(AspectRatioCategory.isSupported('21:9'), isTrue);
      expect(AspectRatioCategory.isSupported('32:9'), isTrue);
    });

    test('isSupported returns false for invalid aspect ratios', () {
      expect(AspectRatioCategory.isSupported('15:9'), isFalse);
      expect(AspectRatioCategory.isSupported('invalid'), isFalse);
    });

    test('isPortrait returns correct values', () {
      expect(AspectRatioCategory.wide.isPortrait, isFalse);
      expect(AspectRatioCategory.ultraTall.isPortrait, isTrue);
      expect(AspectRatioCategory.square.isPortrait, isFalse);
    });

    test('isLandscape returns correct values', () {
      expect(AspectRatioCategory.wide.isLandscape, isTrue);
      expect(AspectRatioCategory.ultraTall.isLandscape, isFalse);
      expect(AspectRatioCategory.square.isLandscape, isTrue); // 1:1은 가로 모드
    });
  });

  group('ResponsiveConfig Tests', () {
    test('forAspectRatio returns correct config for wide', () {
      final config = ResponsiveConfig.forAspectRatio(AspectRatioCategory.wide);
      expect(config.gridColumns, 6);
      expect(config.maxContentWidth, 1440);
      expect(config.sidePadding, 80);
      expect(config.contentSpacing, 24);
    });

    test('forAspectRatio returns correct config for ultraWide', () {
      final config =
          ResponsiveConfig.forAspectRatio(AspectRatioCategory.ultraWide);
      expect(config.gridColumns, 10);
      expect(config.maxContentWidth, 2400);
      expect(config.sidePadding, 120);
      expect(config.contentSpacing, 32);
    });

    test('copyWith creates new config with modified values', () {
      final originalConfig =
          ResponsiveConfig.forAspectRatio(AspectRatioCategory.wide);
      final newConfig = originalConfig.copyWith(
        gridColumns: 8,
        sidePadding: 100,
      );

      expect(newConfig.gridColumns, 8);
      expect(newConfig.sidePadding, 100);
      expect(newConfig.maxContentWidth, originalConfig.maxContentWidth);
      expect(newConfig.contentSpacing, originalConfig.contentSpacing);
    });
  });

  group('LayoutMode Tests', () {
    test('fromString returns correct layout mode', () {
      expect(LayoutMode.fromString('VERTICAL'), LayoutMode.vertical);
      expect(LayoutMode.fromString('HORIZONTAL'), LayoutMode.horizontal);
      expect(LayoutMode.fromString('GRID'), LayoutMode.grid);
      expect(LayoutMode.fromString('BOX'), LayoutMode.box);
    });

    test('fromString returns default for invalid string', () {
      expect(LayoutMode.fromString('INVALID'), LayoutMode.vertical);
    });
  });

  group('SizingMode Tests', () {
    test('fromString returns correct sizing mode', () {
      expect(SizingMode.fromString('FIXED'), SizingMode.fixed);
      expect(SizingMode.fromString('FILL'), SizingMode.fill);
      expect(SizingMode.fromString('FIT_CONTENT'), SizingMode.fitContent);
      expect(SizingMode.fromString('AUTO'), SizingMode.auto);
    });

    test('fromString returns default for invalid string', () {
      expect(SizingMode.fromString('INVALID'), SizingMode.auto);
    });
  });

  group('ResponsiveUtils Tests', () {
    test('detectAspectRatioCategory returns correct category', () {
      final size = Size(1920, 1080);
      final category = ResponsiveUtils.detectAspectRatioCategory(size);
      expect(category, AspectRatioCategory.wide);
    });

    test('getResponsiveConfig returns correct config', () {
      final size = Size(1920, 1080);
      final config = ResponsiveUtils.getResponsiveConfig(size);
      expect(config.gridColumns, 6);
      expect(config.maxContentWidth, 1440);
    });

    test('getSafeArea returns correct safe area', () {
      final size = Size(1920, 1080);
      final safeArea = ResponsiveUtils.getSafeArea(size);
      expect(safeArea.left, 80);
      expect(safeArea.right, 80);
      expect(safeArea.top, 64);
      expect(safeArea.bottom, 64);
    });
  });

  group('LayoutCalculator Tests', () {
    test('calculateGridLayout returns correct result', () {
      final result = LayoutCalculator.calculateGridLayout(
        containerSize: Size(1200, 800),
        itemCount: 12,
        columns: 4,
        spacing: 16,
        runSpacing: 16,
      );

      expect(result.columns, 4);
      expect(result.rows, 3);
      expect(result.itemPositions.length, 12);
      expect(result.itemSize.width, greaterThan(0));
      expect(result.itemSize.height, greaterThan(0));
    });

    test('calculateFlexLayout returns correct result', () {
      final items = [
        FlexItem(width: 100, height: 50),
        FlexItem(width: 100, height: 50),
        FlexItem(width: 100, height: 50),
      ];

      final result = LayoutCalculator.calculateFlexLayout(
        containerSize: Size(400, 200),
        items: items,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
      );

      expect(result.itemSizes.length, 3);
      expect(result.itemPositions.length, 3);
      expect(result.direction, Axis.horizontal);
    });
  });
}
