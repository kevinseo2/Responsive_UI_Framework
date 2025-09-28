import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';

void main() {
  group('Adaptive Components Tests', () {
    test('AdaptiveSafeAreaManager provides correct margins for TV mode', () {
      final margins = AdaptiveSafeAreaManager.getSafeMargin(
        AspectRatioCategory.ultraWide,
        const Size(1920, 1080),
        mode: SafeAreaMode.tv,
      );

      // TV 와이드 스크린에서는 5% 마진이 적용되어야 함
      expect(margins.left, greaterThan(90.0)); // 5% of 1920 = 96
      expect(margins.top, greaterThan(50.0)); // 5% of 1080 = 54
    });

    test('AdaptiveSafeAreaManager auto-detects correct mode', () {
      // TV 크기 (16:9)
      final tvMargins = AdaptiveSafeAreaManager.getSafeMargin(
        AspectRatioCategory.ultraWide,
        const Size(1920, 1080),
        mode: SafeAreaMode.auto,
      );

      // TV 모드가 자동 감지되어야 함
      expect(tvMargins.left, greaterThan(90)); // TV 마진은 큼

      // 모바일 크기 (9:16)
      final mobileMargins = AdaptiveSafeAreaManager.getSafeMargin(
        AspectRatioCategory.ultraTall,
        const Size(390, 844),
        mode: SafeAreaMode.auto,
      );

      // 모바일 마진은 더 작아야 함
      expect(mobileMargins.left, lessThan(30));
    });

    test('BoxContainer basic functionality works', () {
      // BoxContainer 클래스가 제대로 생성되는지 확인
      final container = BoxContainer(
        containerId: 'test-container',
        containerName: 'Test Container',
        child: Container(color: Colors.red),
      );

      expect(container, isNotNull);
      expect(container.containerId, equals('test-container'));
      expect(container.containerName, equals('Test Container'));
      expect(container.child, isNotNull);
    });

    test('GridContainer functionality works', () {
      // GridContainer 동작 확인
      final gridContainer = GridContainer(
        containerId: 'grid-container',
        containerName: 'Grid Container',
        children: [
          Container(color: Colors.red),
          Container(color: Colors.blue),
          Container(color: Colors.green),
        ],
      );

      expect(gridContainer, isNotNull);
      expect(gridContainer.children?.length, equals(3));
      expect(gridContainer.containerId, equals('grid-container'));
    });

    test('SafeAreaMode enumeration works', () {
      // SafeAreaMode 동작 확인
      expect(SafeAreaMode.tv, isNotNull);
      expect(SafeAreaMode.mobile, isNotNull);
      expect(SafeAreaMode.desktop, isNotNull);
      expect(SafeAreaMode.auto, isNotNull);
    });

    test('New AspectRatioCategory values work correctly', () {
      // 새로운 5개 aspect ratio 확인
      expect(AspectRatioCategory.ultraWide, isNotNull);
      expect(AspectRatioCategory.wide, isNotNull);
      expect(AspectRatioCategory.square, isNotNull);
      expect(AspectRatioCategory.tall, isNotNull);
      expect(AspectRatioCategory.ultraTall, isNotNull);
    });
  });
}
