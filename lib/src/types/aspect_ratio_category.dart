import 'package:flutter/material.dart';

/// Flutter UI Layout Coding Specification 기반 화면비 카테고리 정의
///
/// Flutter UI Layout Coding Specification v1.0.0에서 정의된
/// 5가지 화면비를 지원합니다.
enum AspectRatioCategory {
  /// 16:9 - Ultra Wide (와이드스크린 TV, 모니터, 자동차 디스플레이)
  ultraWide(16.0 / 9.0, '16:9', 'Ultra Wide'),

  /// 4:3 - Wide (일반 TV, 태블릿 가로)
  wide(4.0 / 3.0, '4:3', 'Wide'),

  /// 1:1 - Square (정사각형 디스플레이)
  square(1.0, '1:1', 'Square'),

  /// 3:4 - Tall (태블릿 세로)
  tall(3.0 / 4.0, '3:4', 'Tall'),

  /// 9:16 - Ultra Tall (모바일 세로)
  ultraTall(9.0 / 16.0, '9:16', 'Ultra Tall');

  const AspectRatioCategory(this.ratio, this.displayName, this.description);

  /// 화면비 값 (width / height)
  final double ratio;

  /// 표시용 이름 (16:9, 4:3, 1:1, 3:4, 9:16)
  final String displayName;

  /// 설명
  final String description;

  /// 세로 모드인지 확인
  bool get isPortrait => ratio < 1.0;

  /// 가로 모드인지 확인
  bool get isLandscape => ratio >= 1.0;

  /// 와이드 모드인지 확인 (16:9)
  bool get isUltraWide => this == AspectRatioCategory.ultraWide;

  /// 표준 모드인지 확인 (4:3)
  bool get isStandardWide => this == AspectRatioCategory.wide;

  /// 정사각형 모드인지 확인 (1:1)
  bool get isSquare => this == AspectRatioCategory.square;

  /// 화면 크기로부터 화면비 카테고리 결정
  static AspectRatioCategory fromSize(Size size) {
    final ratio = size.width / size.height;

    // 허용 오차를 고려한 화면비 판정
    const tolerance = 0.1;

    for (final category in AspectRatioCategory.values) {
      if ((ratio - category.ratio).abs() <= tolerance) {
        return category;
      }
    }

    // 가장 가까운 비율 반환
    return AspectRatioCategory.values.reduce(
        (a, b) => (ratio - a.ratio).abs() < (ratio - b.ratio).abs() ? a : b);
  }

  /// 화면비 문자열로부터 카테고리 결정
  static AspectRatioCategory fromString(String aspectRatio) {
    for (final category in AspectRatioCategory.values) {
      if (category.displayName == aspectRatio) {
        return category;
      }
    }
    return AspectRatioCategory.wide; // 기본값을 4:3으로 변경
  }

  /// Flutter UI Layout Coding Specification에서 지원하는 화면비 목록
  static const List<String> supportedAspectRatios = [
    '16:9',
    '4:3',
    '1:1',
    '3:4',
    '9:16'
  ];

  /// 화면비가 코딩 스펙에서 지원되는지 확인
  static bool isSupported(String aspectRatio) {
    return supportedAspectRatios.contains(aspectRatio);
  }

  /// 그리드 컬럼 수 계산 (화면비별 최적화)
  int getOptimalGridColumns() {
    switch (this) {
      case AspectRatioCategory.ultraWide: // 16:9
        return 6;
      case AspectRatioCategory.wide: // 4:3
        return 4;
      case AspectRatioCategory.square: // 1:1
        return 3;
      case AspectRatioCategory.tall: // 3:4
        return 2;
      case AspectRatioCategory.ultraTall: // 9:16
        return 1;
    }
  }

  /// 아이템 간격 계산 (화면비별 최적화)
  double getOptimalItemSpacing() {
    switch (this) {
      case AspectRatioCategory.ultraWide: // 16:9
        return 16.0;
      case AspectRatioCategory.wide: // 4:3
        return 12.0;
      case AspectRatioCategory.square: // 1:1
        return 10.0;
      case AspectRatioCategory.tall: // 3:4
        return 8.0;
      case AspectRatioCategory.ultraTall: // 9:16
        return 6.0;
    }
  }

  /// 패딩 크기 계산 (화면비별 최적화)
  double getOptimalPadding() {
    switch (this) {
      case AspectRatioCategory.ultraWide: // 16:9
        return 24.0;
      case AspectRatioCategory.wide: // 4:3
        return 20.0;
      case AspectRatioCategory.square: // 1:1
        return 16.0;
      case AspectRatioCategory.tall: // 3:4
        return 12.0;
      case AspectRatioCategory.ultraTall: // 9:16
        return 8.0;
    }
  }
}
