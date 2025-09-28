import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';
import '../types/responsive_config.dart';

/// Design Spec 기반 반응형 레이아웃 관리자
///
/// 화면비별 최적화된 레이아웃 설정을 제공하고,
/// Design Specification에 따른 반응형 동작을 관리합니다.
class ResponsiveLayoutManager {
  ResponsiveLayoutManager._(); // 인스턴스 생성 방지

  /// 현재 화면 크기를 기반으로 화면비 카테고리를 결정
  static AspectRatioCategory getAspectRatioCategory(Size screenSize) {
    return AspectRatioCategory.fromSize(screenSize);
  }

  /// 현재 화면비에 해당하는 반응형 설정 반환
  static ResponsiveConfig getConfig(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);
    return ResponsiveConfig.forAspectRatio(category);
  }

  /// 화면비별 안전 영역 계산
  static EdgeInsets getSafeArea(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return config.getSafeArea(category);
  }

  /// 반응형 패딩 계산
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return config.getResponsivePadding(category);
  }

  /// 반응형 마진 계산
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return config.getResponsiveMargin(category);
  }

  /// 그리드 아이템 크기 계산
  static Size getGridItemSize(BuildContext context, {int? columns}) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);

    final effectiveColumns = columns ?? config.gridColumns;
    final availableWidth = screenSize.width - (config.sidePadding * 2);
    final itemWidth =
        (availableWidth - (config.contentSpacing * (effectiveColumns - 1))) /
            effectiveColumns;
    final itemHeight = config.getGridItemHeight(itemWidth);

    return Size(itemWidth, itemHeight);
  }

  /// 컨테이너 크기 계산
  static Size getContainerSize(
    BuildContext context, {
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final config = getConfig(context);

    double effectiveWidth = width ?? screenSize.width;
    double effectiveHeight = height ?? screenSize.height;

    if (maxWidth != null && effectiveWidth > maxWidth) {
      effectiveWidth = maxWidth;
    }
    if (maxHeight != null && effectiveHeight > maxHeight) {
      effectiveHeight = maxHeight;
    }

    // 최대 콘텐츠 너비 제한
    if (effectiveWidth > config.maxContentWidth) {
      effectiveWidth = config.maxContentWidth;
    }

    return Size(effectiveWidth, effectiveHeight);
  }

  /// 반응형 폰트 크기 계산
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseFontSize,
    double? scaleFactor,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);

    // 화면비별 폰트 크기 조정
    double factor = 1.0;
    switch (category) {
      case AspectRatioCategory.ultraWide:
        factor = 1.3;
        break;
      case AspectRatioCategory.wide:
        factor = 1.1;
        break;
      case AspectRatioCategory.square:
        factor = 1.0;
        break;
      case AspectRatioCategory.tall:
        factor = 0.9;
        break;
      case AspectRatioCategory.ultraTall:
        factor = 0.8;
        break;
    }

    final effectiveScaleFactor = scaleFactor ?? factor;
    return baseFontSize * effectiveScaleFactor;
  }

  /// 반응형 아이콘 크기 계산
  static double getResponsiveIconSize(
    BuildContext context, {
    required double baseIconSize,
  }) {
    return getResponsiveFontSize(
      context,
      baseFontSize: baseIconSize,
    );
  }

  /// 반응형 간격 계산
  static double getResponsiveSpacing(
    BuildContext context, {
    required double baseSpacing,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);

    // 화면비별 간격 조정
    double factor = 1.0;
    switch (category) {
      case AspectRatioCategory.ultraWide:
        factor = 1.3;
        break;
      case AspectRatioCategory.wide:
        factor = 1.1;
        break;
      case AspectRatioCategory.square:
        factor = 1.0;
        break;
      case AspectRatioCategory.tall:
        factor = 0.9;
        break;
      case AspectRatioCategory.ultraTall:
        factor = 0.8;
        break;
    }

    return baseSpacing * factor;
  }

  /// 반응형 보더 반지름 계산
  static double getResponsiveBorderRadius(
    BuildContext context, {
    required double baseBorderRadius,
  }) {
    return getResponsiveSpacing(
      context,
      baseSpacing: baseBorderRadius,
    );
  }

  /// 반응형 그림자 계산
  static List<BoxShadow> getResponsiveBoxShadow(
    BuildContext context, {
    required BoxShadow baseShadow,
  }) {
    final blurRadius = getResponsiveSpacing(
      context,
      baseSpacing: baseShadow.blurRadius,
    );
    final spreadRadius = getResponsiveSpacing(
      context,
      baseSpacing: baseShadow.spreadRadius,
    );
    final offset = Offset(
      getResponsiveSpacing(context, baseSpacing: baseShadow.offset.dx),
      getResponsiveSpacing(context, baseSpacing: baseShadow.offset.dy),
    );

    return [
      BoxShadow(
        color: baseShadow.color,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: offset,
      ),
    ];
  }

  /// 반응형 애니메이션 지속 시간 계산
  static Duration getResponsiveAnimationDuration(
    BuildContext context, {
    required Duration baseDuration,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final category = getAspectRatioCategory(screenSize);

    // 화면비별 애니메이션 지속 시간 조정
    double factor = 1.0;
    switch (category) {
      case AspectRatioCategory.ultraWide:
        factor = 1.2;
        break;
      case AspectRatioCategory.wide:
        factor = 1.1;
        break;
      case AspectRatioCategory.square:
        factor = 1.0;
        break;
      case AspectRatioCategory.tall:
        factor = 0.9;
        break;
      case AspectRatioCategory.ultraTall:
        factor = 0.8;
        break;
    }

    return Duration(
      milliseconds: (baseDuration.inMilliseconds * factor).round(),
    );
  }

  /// 반응형 브레이크포인트 확인
  static bool isBreakpoint(
    BuildContext context, {
    required AspectRatioCategory breakpoint,
    bool isGreaterThan = true,
  }) {
    final currentCategory = getAspectRatioCategory(MediaQuery.of(context).size);
    final currentIndex = AspectRatioCategory.values.indexOf(currentCategory);
    final breakpointIndex = AspectRatioCategory.values.indexOf(breakpoint);

    if (isGreaterThan) {
      return currentIndex >= breakpointIndex;
    } else {
      return currentIndex <= breakpointIndex;
    }
  }

  /// 반응형 조건부 위젯 빌더
  static Widget buildResponsive(
    BuildContext context, {
    required Widget Function(BuildContext context, AspectRatioCategory category)
        builder,
  }) {
    final category = getAspectRatioCategory(MediaQuery.of(context).size);
    return builder(context, category);
  }

  /// 반응형 조건부 위젯 빌더 (브레이크포인트 기반)
  static Widget buildResponsiveWithBreakpoint(
    BuildContext context, {
    required AspectRatioCategory breakpoint,
    required Widget Function(BuildContext context) builder,
    Widget? fallback,
  }) {
    if (isBreakpoint(context, breakpoint: breakpoint)) {
      return builder(context);
    }
    return fallback ?? const SizedBox.shrink();
  }
}
