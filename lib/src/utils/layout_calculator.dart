import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';
import '../types/responsive_config.dart';

/// 레이아웃 계산기
/// 
/// Design Spec 기반 레이아웃 계산을 위한 유틸리티 클래스입니다.
class LayoutCalculator {
  LayoutCalculator._(); // 인스턴스 생성 방지

  /// 그리드 레이아웃 계산
  static GridLayoutResult calculateGridLayout({
    required Size containerSize,
    required int itemCount,
    required int columns,
    required double spacing,
    required double runSpacing,
  }) {
    final availableWidth = containerSize.width;
    
    // 아이템 너비 계산
    final itemWidth = (availableWidth - (spacing * (columns - 1))) / columns;
    
    // 행 수 계산
    final rows = (itemCount / columns).ceil();
    
    // 아이템 높이 계산 (16:9 비율 기준)
    final itemHeight = itemWidth * (9 / 16);
    
    // 총 높이 계산
    final totalHeight = (itemHeight * rows) + (runSpacing * (rows - 1));
    
    // 아이템 위치 계산
    final itemPositions = <Offset>[];
    for (int i = 0; i < itemCount; i++) {
      final row = i ~/ columns;
      final col = i % columns;
      
      final x = col * (itemWidth + spacing);
      final y = row * (itemHeight + runSpacing);
      
      itemPositions.add(Offset(x, y));
    }
    
    return GridLayoutResult(
      itemSize: Size(itemWidth, itemHeight),
      itemPositions: itemPositions,
      totalSize: Size(availableWidth, totalHeight),
      rows: rows,
      columns: columns,
    );
  }

  /// 플렉스 레이아웃 계산
  static FlexLayoutResult calculateFlexLayout({
    required Size containerSize,
    required List<FlexItem> items,
    required Axis direction,
    required MainAxisAlignment mainAxisAlignment,
    required CrossAxisAlignment crossAxisAlignment,
    required double spacing,
  }) {
    final availableWidth = containerSize.width;
    final availableHeight = containerSize.height;
    
    // 아이템 크기 계산
    final itemSizes = <Size>[];
    for (final item in items) {
      final size = _calculateFlexItemSize(item, availableWidth, availableHeight, direction);
      itemSizes.add(size);
    }
    
    // 총 크기 계산
    double totalMainSize = 0;
    double maxCrossSize = 0;
    
    for (int i = 0; i < items.length; i++) {
      final size = itemSizes[i];
      if (direction == Axis.horizontal) {
        totalMainSize += size.width;
        maxCrossSize = maxCrossSize > size.height ? maxCrossSize : size.height;
      } else {
        totalMainSize += size.height;
        maxCrossSize = maxCrossSize > size.width ? maxCrossSize : size.width;
      }
      
      // 간격 추가 (마지막 아이템 제외)
      if (i < items.length - 1) {
        totalMainSize += spacing;
      }
    }
    
    // 아이템 위치 계산
    final itemPositions = <Offset>[];
    double currentMainPosition = 0;
    
    for (int i = 0; i < items.length; i++) {
      final size = itemSizes[i];
      
      double x, y;
      if (direction == Axis.horizontal) {
        x = currentMainPosition;
        y = _calculateCrossPosition(crossAxisAlignment, availableHeight, size.height);
        currentMainPosition += size.width + spacing;
      } else {
        x = _calculateCrossPosition(crossAxisAlignment, availableWidth, size.width);
        y = currentMainPosition;
        currentMainPosition += size.height + spacing;
      }
      
      itemPositions.add(Offset(x, y));
    }
    
    // 메인 정렬 조정
    _adjustMainAlignment(itemPositions, mainAxisAlignment, availableWidth, availableHeight, totalMainSize, direction);
    
    return FlexLayoutResult(
      itemSizes: itemSizes,
      itemPositions: itemPositions,
      totalSize: Size(availableWidth, availableHeight),
      direction: direction,
    );
  }

  /// 스택 레이아웃 계산
  static StackLayoutResult calculateStackLayout({
    required Size containerSize,
    required List<StackItem> items,
    required Alignment alignment,
  }) {
    final availableWidth = containerSize.width;
    final availableHeight = containerSize.height;
    
    // 아이템 크기 계산
    final itemSizes = <Size>[];
    for (final item in items) {
      final size = _calculateStackItemSize(item, availableWidth, availableHeight);
      itemSizes.add(size);
    }
    
    // 아이템 위치 계산
    final itemPositions = <Offset>[];
    for (int i = 0; i < items.length; i++) {
      final size = itemSizes[i];
      final position = _calculateStackItemPosition(size, availableWidth, availableHeight, alignment);
      itemPositions.add(position);
    }
    
    return StackLayoutResult(
      itemSizes: itemSizes,
      itemPositions: itemPositions,
      totalSize: Size(availableWidth, availableHeight),
      alignment: alignment,
    );
  }

  /// 반응형 그리드 레이아웃 계산
  static ResponsiveGridLayoutResult calculateResponsiveGridLayout({
    required Size screenSize,
    required int itemCount,
    required AspectRatioCategory aspectRatio,
    int? customColumns,
    double? customSpacing,
  }) {
    final config = ResponsiveConfig.forAspectRatio(aspectRatio);
    final columns = customColumns ?? config.gridColumns;
    final spacing = customSpacing ?? config.contentSpacing;
    
    final result = calculateGridLayout(
      containerSize: screenSize,
      itemCount: itemCount,
      columns: columns,
      spacing: spacing,
      runSpacing: spacing,
    );
    
    return ResponsiveGridLayoutResult(
      gridResult: result,
      aspectRatio: aspectRatio,
      config: config,
    );
  }

  /// 반응형 플렉스 레이아웃 계산
  static ResponsiveFlexLayoutResult calculateResponsiveFlexLayout({
    required Size screenSize,
    required List<FlexItem> items,
    required AspectRatioCategory aspectRatio,
    Axis? customDirection,
    double? customSpacing,
  }) {
    final config = ResponsiveConfig.forAspectRatio(aspectRatio);
    final direction = customDirection ?? (aspectRatio.isLandscape ? Axis.horizontal : Axis.vertical);
    final spacing = customSpacing ?? config.contentSpacing;
    
    final result = calculateFlexLayout(
      containerSize: screenSize,
      items: items,
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing,
    );
    
    return ResponsiveFlexLayoutResult(
      flexResult: result,
      aspectRatio: aspectRatio,
      config: config,
    );
  }

  /// 반응형 스택 레이아웃 계산
  static ResponsiveStackLayoutResult calculateResponsiveStackLayout({
    required Size screenSize,
    required List<StackItem> items,
    required AspectRatioCategory aspectRatio,
    Alignment? customAlignment,
  }) {
    final config = ResponsiveConfig.forAspectRatio(aspectRatio);
    final alignment = customAlignment ?? Alignment.center;
    
    final result = calculateStackLayout(
      containerSize: screenSize,
      items: items,
      alignment: alignment,
    );
    
    return ResponsiveStackLayoutResult(
      stackResult: result,
      aspectRatio: aspectRatio,
      config: config,
    );
  }

  /// 플렉스 아이템 크기 계산
  static Size _calculateFlexItemSize(FlexItem item, double availableWidth, double availableHeight, Axis direction) {
    double width, height;
    
    if (direction == Axis.horizontal) {
      width = item.width ?? (availableWidth / 3); // 기본값
      height = item.height ?? (width * (9 / 16)); // 16:9 비율
    } else {
      height = item.height ?? (availableHeight / 3); // 기본값
      width = item.width ?? (height * (16 / 9)); // 16:9 비율
    }
    
    return Size(width, height);
  }

  /// 스택 아이템 크기 계산
  static Size _calculateStackItemSize(StackItem item, double availableWidth, double availableHeight) {
    final width = item.width ?? availableWidth;
    final height = item.height ?? availableHeight;
    return Size(width, height);
  }

  /// 교차축 위치 계산
  static double _calculateCrossPosition(CrossAxisAlignment alignment, double availableSize, double itemSize) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return 0;
      case CrossAxisAlignment.center:
        return (availableSize - itemSize) / 2;
      case CrossAxisAlignment.end:
        return availableSize - itemSize;
      case CrossAxisAlignment.stretch:
        return 0;
      case CrossAxisAlignment.baseline:
        return 0; // 기본값
    }
  }

  /// 메인 정렬 조정
  static void _adjustMainAlignment(
    List<Offset> positions,
    MainAxisAlignment alignment,
    double availableWidth,
    double availableHeight,
    double totalSize,
    Axis direction,
  ) {
    double offset = 0;
    
    switch (alignment) {
      case MainAxisAlignment.start:
        offset = 0;
        break;
      case MainAxisAlignment.center:
        offset = direction == Axis.horizontal
            ? (availableWidth - totalSize) / 2
            : (availableHeight - totalSize) / 2;
        break;
      case MainAxisAlignment.end:
        offset = direction == Axis.horizontal
            ? availableWidth - totalSize
            : availableHeight - totalSize;
        break;
      case MainAxisAlignment.spaceBetween:
        // 구현 필요
        break;
      case MainAxisAlignment.spaceAround:
        // 구현 필요
        break;
      case MainAxisAlignment.spaceEvenly:
        // 구현 필요
        break;
    }
    
    // 위치 조정
    for (int i = 0; i < positions.length; i++) {
      final position = positions[i];
      if (direction == Axis.horizontal) {
        positions[i] = Offset(position.dx + offset, position.dy);
      } else {
        positions[i] = Offset(position.dx, position.dy + offset);
      }
    }
  }

  /// 스택 아이템 위치 계산
  static Offset _calculateStackItemPosition(Size itemSize, double availableWidth, double availableHeight, Alignment alignment) {
    final x = alignment.x * (availableWidth - itemSize.width) / 2 + availableWidth / 2;
    final y = alignment.y * (availableHeight - itemSize.height) / 2 + availableHeight / 2;
    return Offset(x, y);
  }
}

/// 그리드 레이아웃 결과
class GridLayoutResult {
  const GridLayoutResult({
    required this.itemSize,
    required this.itemPositions,
    required this.totalSize,
    required this.rows,
    required this.columns,
  });

  final Size itemSize;
  final List<Offset> itemPositions;
  final Size totalSize;
  final int rows;
  final int columns;
}

/// 플렉스 레이아웃 결과
class FlexLayoutResult {
  const FlexLayoutResult({
    required this.itemSizes,
    required this.itemPositions,
    required this.totalSize,
    required this.direction,
  });

  final List<Size> itemSizes;
  final List<Offset> itemPositions;
  final Size totalSize;
  final Axis direction;
}

/// 스택 레이아웃 결과
class StackLayoutResult {
  const StackLayoutResult({
    required this.itemSizes,
    required this.itemPositions,
    required this.totalSize,
    required this.alignment,
  });

  final List<Size> itemSizes;
  final List<Offset> itemPositions;
  final Size totalSize;
  final Alignment alignment;
}

/// 반응형 그리드 레이아웃 결과
class ResponsiveGridLayoutResult {
  const ResponsiveGridLayoutResult({
    required this.gridResult,
    required this.aspectRatio,
    required this.config,
  });

  final GridLayoutResult gridResult;
  final AspectRatioCategory aspectRatio;
  final ResponsiveConfig config;
}

/// 반응형 플렉스 레이아웃 결과
class ResponsiveFlexLayoutResult {
  const ResponsiveFlexLayoutResult({
    required this.flexResult,
    required this.aspectRatio,
    required this.config,
  });

  final FlexLayoutResult flexResult;
  final AspectRatioCategory aspectRatio;
  final ResponsiveConfig config;
}

/// 반응형 스택 레이아웃 결과
class ResponsiveStackLayoutResult {
  const ResponsiveStackLayoutResult({
    required this.stackResult,
    required this.aspectRatio,
    required this.config,
  });

  final StackLayoutResult stackResult;
  final AspectRatioCategory aspectRatio;
  final ResponsiveConfig config;
}

/// 플렉스 아이템
class FlexItem {
  const FlexItem({
    this.width,
    this.height,
    this.flex,
  });

  final double? width;
  final double? height;
  final int? flex;
}

/// 스택 아이템
class StackItem {
  const StackItem({
    this.width,
    this.height,
    this.alignment,
  });

  final double? width;
  final double? height;
  final Alignment? alignment;
}
