import 'package:flutter/material.dart';

/// 플레이스홀더 설정 클래스
///
/// 컨테이너에서 사용할 플레이스홀더의 설정을 정의합니다.
class PlaceholderConfig {
  /// 배경색
  final Color? backgroundColor;

  /// 테두리 색상
  final Color? borderColor;

  /// 텍스트 색상
  final Color? textColor;

  /// 아이콘
  final IconData? icon;

  /// 커스텀 텍스트
  final String? customText;

  /// 투명도
  final double? opacity;

  const PlaceholderConfig({
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.icon,
    this.customText,
    this.opacity,
  });
}
