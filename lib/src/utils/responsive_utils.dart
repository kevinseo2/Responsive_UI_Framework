import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';
import '../types/responsive_config.dart';
import '../core/responsive_layout_manager.dart';
import '../core/responsive_layout_provider.dart';

/// 반응형 유틸리티 클래스
///
/// 반응형 UI 개발을 위한 다양한 헬퍼 메서드를 제공합니다.
class ResponsiveUtils {
  ResponsiveUtils._(); // 인스턴스 생성 방지

  /// 화면비 카테고리 감지
  static AspectRatioCategory detectAspectRatioCategory(Size screenSize) {
    return ResponsiveLayoutManager.getAspectRatioCategory(screenSize);
  }

  /// 반응형 패딩 계산
  static EdgeInsets getResponsivePadding(
      BuildContext context, double baseSpacing) {
    final spacing = getResponsiveSpacing(context, baseSpacing);
    return EdgeInsets.all(spacing);
  }

  /// 반응형 마진 계산
  static EdgeInsets getResponsiveMargin(
      BuildContext context, double baseSpacing) {
    final spacing = getResponsiveSpacing(context, baseSpacing);
    return EdgeInsets.all(spacing);
  }

  /// 반응형 폰트 크기 계산
  static double getResponsiveFontSize(
      BuildContext context, double baseFontSize) {
    return ResponsiveLayoutManager.getResponsiveFontSize(
      context,
      baseFontSize: baseFontSize,
    );
  }

  /// 반응형 아이콘 크기 계산
  static double getResponsiveIconSize(
      BuildContext context, double baseIconSize) {
    return ResponsiveLayoutManager.getResponsiveIconSize(
      context,
      baseIconSize: baseIconSize,
    );
  }

  /// 반응형 간격 계산
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    return ResponsiveLayoutManager.getResponsiveSpacing(
      context,
      baseSpacing: baseSpacing,
    );
  }

  /// 반응형 보더 반지름 계산
  static double getResponsiveBorderRadius(
      BuildContext context, double baseBorderRadius) {
    return ResponsiveLayoutManager.getResponsiveBorderRadius(
      context,
      baseBorderRadius: baseBorderRadius,
    );
  }

  /// 반응형 그림자 계산
  static List<BoxShadow> getResponsiveBoxShadow(
      BuildContext context, BoxShadow baseShadow) {
    return ResponsiveLayoutManager.getResponsiveBoxShadow(
      context,
      baseShadow: baseShadow,
    );
  }

  /// 반응형 애니메이션 지속 시간 계산
  static Duration getResponsiveAnimationDuration(
      BuildContext context, Duration baseDuration) {
    return ResponsiveLayoutManager.getResponsiveAnimationDuration(
      context,
      baseDuration: baseDuration,
    );
  }

  /// 반응형 브레이크포인트 확인
  static bool isBreakpoint(BuildContext context, AspectRatioCategory breakpoint,
      {bool isGreaterThan = true}) {
    return ResponsiveLayoutManager.isBreakpoint(
      context,
      breakpoint: breakpoint,
      isGreaterThan: isGreaterThan,
    );
  }

  /// 반응형 조건부 위젯 빌더
  static Widget buildResponsive(
      BuildContext context,
      Widget Function(BuildContext context, AspectRatioCategory category)
          builder) {
    return ResponsiveLayoutManager.buildResponsive(context, builder: builder);
  }

  /// 반응형 조건부 위젯 빌더 (브레이크포인트 기반)
  static Widget buildResponsiveWithBreakpoint(
    BuildContext context, {
    required AspectRatioCategory breakpoint,
    required Widget Function(BuildContext context) builder,
    Widget? fallback,
  }) {
    return ResponsiveLayoutManager.buildResponsiveWithBreakpoint(
      context,
      breakpoint: breakpoint,
      builder: builder,
      fallback: fallback,
    );
  }

  /// 화면 크기 기반 반응형 설정 가져오기
  static ResponsiveConfig getResponsiveConfig(Size screenSize) {
    final category = detectAspectRatioCategory(screenSize);
    return ResponsiveConfig.forAspectRatio(category);
  }

  /// 화면 크기 기반 안전 영역 계산
  static EdgeInsets getSafeArea(Size screenSize) {
    final category = detectAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return config.getSafeArea(category);
  }

  /// 화면 크기 기반 반응형 패딩 계산
  static EdgeInsets getResponsivePaddingFromSize(
      Size screenSize, double baseSpacing) {
    final category = detectAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return config.getResponsivePadding(category);
  }

  /// 화면 크기 기반 반응형 마진 계산
  static EdgeInsets getResponsiveMarginFromSize(
      Size screenSize, double baseSpacing) {
    final category = detectAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return config.getResponsiveMargin(category);
  }

  /// 화면 크기 기반 그리드 아이템 크기 계산
  static Size getGridItemSize(Size screenSize, {int? columns}) {
    final category = detectAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);

    final effectiveColumns = columns ?? config.gridColumns;
    final availableWidth = screenSize.width - (config.sidePadding * 2);
    final itemWidth =
        (availableWidth - (config.contentSpacing * (effectiveColumns - 1))) /
            effectiveColumns;
    final itemHeight = config.getGridItemHeight(itemWidth);

    return Size(itemWidth, itemHeight);
  }

  /// 화면 크기 기반 컨테이너 크기 계산
  static Size getContainerSize(
    Size screenSize, {
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
  }) {
    final config = getResponsiveConfig(screenSize);

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

  /// 화면 크기 기반 반응형 폰트 크기 계산
  static double getResponsiveFontSizeFromSize(
      Size screenSize, double baseFontSize) {
    final category = detectAspectRatioCategory(screenSize);

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

    return baseFontSize * factor;
  }

  /// 화면 크기 기반 반응형 간격 계산
  static double getResponsiveSpacingFromSize(
      Size screenSize, double baseSpacing) {
    final category = detectAspectRatioCategory(screenSize);

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

  /// 화면 크기 기반 반응형 애니메이션 지속 시간 계산
  static Duration getResponsiveAnimationDurationFromSize(
      Size screenSize, Duration baseDuration) {
    final category = detectAspectRatioCategory(screenSize);

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

  /// 화면 크기 기반 반응형 브레이크포인트 확인
  static bool isBreakpointFromSize(
      Size screenSize, AspectRatioCategory breakpoint,
      {bool isGreaterThan = true}) {
    final currentCategory = detectAspectRatioCategory(screenSize);
    final currentIndex = AspectRatioCategory.values.indexOf(currentCategory);
    final breakpointIndex = AspectRatioCategory.values.indexOf(breakpoint);

    if (isGreaterThan) {
      return currentIndex >= breakpointIndex;
    } else {
      return currentIndex <= breakpointIndex;
    }
  }

  /// 화면 크기 기반 반응형 조건부 위젯 빌더
  static Widget buildResponsiveFromSize(
      Size screenSize, Widget Function(AspectRatioCategory category) builder) {
    final category = detectAspectRatioCategory(screenSize);
    return builder(category);
  }

  /// 화면 크기 기반 반응형 조건부 위젯 빌더 (브레이크포인트 기반)
  static Widget buildResponsiveWithBreakpointFromSize(
    Size screenSize, {
    required AspectRatioCategory breakpoint,
    required Widget Function() builder,
    Widget? fallback,
  }) {
    if (isBreakpointFromSize(screenSize, breakpoint)) {
      return builder();
    }
    return fallback ?? const SizedBox.shrink();
  }

  /// 화면 크기 기반 반응형 설정과 화면비 카테고리 모두 가져오기
  static (ResponsiveConfig config, AspectRatioCategory category)
      getConfigAndCategory(Size screenSize) {
    final category = detectAspectRatioCategory(screenSize);
    final config = ResponsiveConfig.forAspectRatio(category);
    return (config, category);
  }

  /// 화면 크기 기반 반응형 설정과 화면비 카테고리 모두 가져오기 (컨텍스트 기반)
  static (ResponsiveConfig config, AspectRatioCategory category)
      getConfigAndCategoryFromContext(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return getConfigAndCategory(screenSize);
  }

  /// 화면 크기 기반 반응형 설정과 화면비 카테고리 모두 가져오기 (컨텍스트 기반, 프로바이더 우선)
  static (ResponsiveConfig config, AspectRatioCategory category)
      getConfigAndCategoryFromContextWithProvider(BuildContext context) {
    // 프로바이더에서 설정 가져오기 시도
    try {
      final provider = context
          .dependOnInheritedWidgetOfExactType<ResponsiveLayoutProvider>();
      if (provider != null &&
          provider.config != null &&
          provider.category != null) {
        return (provider.config!, provider.category!);
      }
    } catch (e) {
      // 프로바이더가 없는 경우 자동 계산
    }

    // 자동 계산
    return getConfigAndCategoryFromContext(context);
  }
}
