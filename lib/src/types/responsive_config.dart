import 'package:flutter/material.dart';
import 'aspect_ratio_category.dart';
import 'layout_mode.dart';

/// Flutter UI Layout Coding Specification 기반 반응형 설정
class ResponsiveConfig {
  const ResponsiveConfig({
    required this.gridColumns,
    required this.maxContentWidth,
    required this.sidePadding,
    required this.contentSpacing,
    required this.itemSpacing,
    this.layoutMode = LayoutMode.box,
  });

  final int gridColumns;
  final double maxContentWidth;
  final double sidePadding;
  final double contentSpacing;
  final double itemSpacing;
  final LayoutMode layoutMode;

  static const Map<AspectRatioCategory, ResponsiveConfig> _configs = {
    AspectRatioCategory.ultraWide: ResponsiveConfig(
      gridColumns: 6,
      maxContentWidth: 1920,
      sidePadding: 24,
      contentSpacing: 16,
      itemSpacing: 16,
      layoutMode: LayoutMode.horizontal,
    ),
    AspectRatioCategory.wide: ResponsiveConfig(
      gridColumns: 4,
      maxContentWidth: 1200,
      sidePadding: 20,
      contentSpacing: 12,
      itemSpacing: 12,
      layoutMode: LayoutMode.grid,
    ),
    AspectRatioCategory.square: ResponsiveConfig(
      gridColumns: 3,
      maxContentWidth: 800,
      sidePadding: 16,
      contentSpacing: 10,
      itemSpacing: 10,
      layoutMode: LayoutMode.grid,
    ),
    AspectRatioCategory.tall: ResponsiveConfig(
      gridColumns: 2,
      maxContentWidth: 600,
      sidePadding: 12,
      contentSpacing: 8,
      itemSpacing: 8,
      layoutMode: LayoutMode.vertical,
    ),
    AspectRatioCategory.ultraTall: ResponsiveConfig(
      gridColumns: 1,
      maxContentWidth: 400,
      sidePadding: 8,
      contentSpacing: 6,
      itemSpacing: 6,
      layoutMode: LayoutMode.vertical,
    ),
  };

  static ResponsiveConfig forAspectRatio(AspectRatioCategory category) {
    return _configs[category] ?? _configs[AspectRatioCategory.wide]!;
  }

  static ResponsiveConfig fromScreenSize(Size screenSize) {
    final category = AspectRatioCategory.fromSize(screenSize);
    return forAspectRatio(category);
  }

  /// 화면비별 안전 영역 계산
  EdgeInsets getSafeArea(AspectRatioCategory category) {
    switch (category) {
      case AspectRatioCategory.ultraWide:
        return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
      case AspectRatioCategory.wide:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      case AspectRatioCategory.square:
        return const EdgeInsets.all(16);
      case AspectRatioCategory.tall:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 32);
      case AspectRatioCategory.ultraTall:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 40);
    }
  }

  /// 반응형 패딩 계산
  EdgeInsets getResponsivePadding(AspectRatioCategory category) {
    return EdgeInsets.all(sidePadding);
  }

  /// 반응형 마진 계산
  EdgeInsets getResponsiveMargin(AspectRatioCategory category) {
    return EdgeInsets.all(contentSpacing);
  }

  /// 그리드 아이템 높이 계산
  double getGridItemHeight(double itemWidth) {
    // 16:9 비율 기본 적용
    return itemWidth * 9 / 16;
  }

  /// 설정 복사 생성
  ResponsiveConfig copyWith({
    int? gridColumns,
    double? maxContentWidth,
    double? sidePadding,
    double? contentSpacing,
    double? itemSpacing,
    LayoutMode? layoutMode,
  }) {
    return ResponsiveConfig(
      gridColumns: gridColumns ?? this.gridColumns,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      sidePadding: sidePadding ?? this.sidePadding,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      layoutMode: layoutMode ?? this.layoutMode,
    );
  }
}
