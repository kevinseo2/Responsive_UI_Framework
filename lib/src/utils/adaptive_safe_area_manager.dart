import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';

/// 적응형 안전 영역 관리자
///
/// 화면비에 따라 최적화된 안전 마진을 제공하는 유틸리티 클래스입니다.
/// TV Home 앱에서 검증된 로직을 기반으로 구현되었습니다.
class AdaptiveSafeAreaManager {
  AdaptiveSafeAreaManager._(); // 인스턴스 생성 방지

  /// 화면비에 따른 적응형 안전 마진 반환
  ///
  /// [category] 화면비 카테고리
  /// [screenSize] 현재 화면 크기
  /// [mode] 사용 모드 (tv, mobile, desktop)
  static EdgeInsets getSafeMargin(
    AspectRatioCategory category,
    Size screenSize, {
    SafeAreaMode mode = SafeAreaMode.auto,
  }) {
    final actualMode = mode == SafeAreaMode.auto ? _detectMode(category) : mode;

    switch (actualMode) {
      case SafeAreaMode.tv:
        return _getTVSafeMargin(category, screenSize);
      case SafeAreaMode.mobile:
        return _getMobileSafeMargin(category, screenSize);
      case SafeAreaMode.desktop:
        return _getDesktopSafeMargin(category, screenSize);
      case SafeAreaMode.auto:
        return _getTVSafeMargin(category, screenSize); // 기본값
    }
  }

  /// TV 특화 안전 마진 (10-foot UI 고려)
  ///
  /// TV Home 앱에서 검증된 설정을 기반으로 합니다.
  static EdgeInsets getTVSafeMargin(
    AspectRatioCategory category,
    Size screenSize,
  ) {
    return _getTVSafeMargin(category, screenSize);
  }

  /// 모바일 특화 안전 마진
  static EdgeInsets getMobileSafeMargin(
    AspectRatioCategory category,
    Size screenSize,
  ) {
    return _getMobileSafeMargin(category, screenSize);
  }

  /// 데스크톱 특화 안전 마진
  static EdgeInsets getDesktopSafeMargin(
    AspectRatioCategory category,
    Size screenSize,
  ) {
    return _getDesktopSafeMargin(category, screenSize);
  }

  /// 화면비를 기반으로 사용 모드 자동 감지
  static SafeAreaMode _detectMode(AspectRatioCategory category) {
    switch (category) {
      case AspectRatioCategory.ultraWide:
        return SafeAreaMode.tv; // 16:9는 주로 TV/자동차
      case AspectRatioCategory.wide:
        return SafeAreaMode.desktop; // 4:3은 데스크톱
      case AspectRatioCategory.square:
        return SafeAreaMode.desktop; // 1:1은 데스크톱
      case AspectRatioCategory.tall:
      case AspectRatioCategory.ultraTall:
        return SafeAreaMode.mobile; // 세로는 모바일
    }
  }

  /// TV 안전 마진 구현 (TV Home 검증 로직)
  static EdgeInsets _getTVSafeMargin(
    AspectRatioCategory category,
    Size screenSize,
  ) {
    double horizontalMargin, verticalMargin;

    switch (category) {
      case AspectRatioCategory.ultraWide:
      case AspectRatioCategory.wide:
        // 와이드 화면: JSON spec 5% 적용 (TV Home 검증됨)
        horizontalMargin = screenSize.width * 0.05;
        verticalMargin = screenSize.height * 0.05;
        break;
      case AspectRatioCategory.square:
        // 정사각형 화면: 균등한 마진
        horizontalMargin = screenSize.width * 0.06;
        verticalMargin = screenSize.height * 0.06;
        break;
      case AspectRatioCategory.tall:
      case AspectRatioCategory.ultraTall:
        // 세로 화면: 작은 마진으로 공간 효율성 확보
        horizontalMargin = screenSize.width * 0.03;
        verticalMargin = screenSize.height * 0.02;
        break;
    }

    return EdgeInsets.fromLTRB(
      horizontalMargin,
      verticalMargin,
      horizontalMargin,
      verticalMargin,
    );
  }

  /// 모바일 안전 마진 구현
  static EdgeInsets _getMobileSafeMargin(
    AspectRatioCategory category,
    Size screenSize,
  ) {
    double horizontalMargin, verticalMargin;

    switch (category) {
      case AspectRatioCategory.ultraWide:
      case AspectRatioCategory.wide:
        // 모바일 가로 모드: 작은 마진
        horizontalMargin = screenSize.width * 0.02;
        verticalMargin = screenSize.height * 0.01;
        break;
      case AspectRatioCategory.square:
        // 정사각형 화면
        horizontalMargin = screenSize.width * 0.04;
        verticalMargin = screenSize.height * 0.03;
        break;
      case AspectRatioCategory.tall:
      case AspectRatioCategory.ultraTall:
        // 모바일 세로 모드: 최소 마진
        horizontalMargin = screenSize.width * 0.04;
        verticalMargin = screenSize.height * 0.02;
        break;
    }

    return EdgeInsets.fromLTRB(
      horizontalMargin,
      verticalMargin,
      horizontalMargin,
      verticalMargin,
    );
  }

  /// 데스크톱 안전 마진 구현
  static EdgeInsets _getDesktopSafeMargin(
    AspectRatioCategory category,
    Size screenSize,
  ) {
    double horizontalMargin, verticalMargin;

    switch (category) {
      case AspectRatioCategory.ultraWide:
        // 초광각 데스크톱: 넉넉한 마진
        horizontalMargin = screenSize.width * 0.08;
        verticalMargin = screenSize.height * 0.06;
        break;
      case AspectRatioCategory.wide:
        // 표준 데스크톱: 적당한 마진
        horizontalMargin = screenSize.width * 0.06;
        verticalMargin = screenSize.height * 0.04;
        break;
      case AspectRatioCategory.square:
        // 정사각형 데스크톱: 전통적인 마진
        horizontalMargin = screenSize.width * 0.05;
        verticalMargin = screenSize.height * 0.04;
        break;
      case AspectRatioCategory.tall:
      case AspectRatioCategory.ultraTall:
        // 세로 데스크톱: 최소 마진
        horizontalMargin = screenSize.width * 0.03;
        verticalMargin = screenSize.height * 0.02;
        break;
    }

    return EdgeInsets.fromLTRB(
      horizontalMargin,
      verticalMargin,
      horizontalMargin,
      verticalMargin,
    );
  }

  /// 화면 크기에서 직접 안전 마진 계산
  static EdgeInsets getSafeMarginFromSize(
    Size screenSize, {
    SafeAreaMode mode = SafeAreaMode.auto,
  }) {
    final category = AspectRatioCategory.fromSize(screenSize);
    return getSafeMargin(category, screenSize, mode: mode);
  }

  /// Context에서 자동으로 안전 마진 계산
  static EdgeInsets getSafeMarginFromContext(
    BuildContext context, {
    SafeAreaMode mode = SafeAreaMode.auto,
  }) {
    final screenSize = MediaQuery.of(context).size;
    return getSafeMarginFromSize(screenSize, mode: mode);
  }
}

/// 안전 영역 모드
enum SafeAreaMode {
  /// 자동 감지
  auto,

  /// TV/대화면 모드 (10-foot UI)
  tv,

  /// 모바일 모드 (터치 UI)
  mobile,

  /// 데스크톱 모드 (마우스/키보드 UI)
  desktop,
}
