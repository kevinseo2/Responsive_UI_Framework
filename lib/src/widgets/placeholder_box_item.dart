import 'package:flutter/material.dart';

/// 기본 박스형 플레이스홀더 위젯
///
/// Figma의 RECTANGLE 타입 컨테이너나 단순한 박스 형태의 위젯을
/// 대체하기 위한 플레이스홀더입니다.
class PlaceholderBoxItem extends StatelessWidget {
  /// 플레이스홀더에 표시될 라벨
  final String label;

  /// 플레이스홀더 크기
  final Size? size;

  /// 배경 색상
  final Color color;

  /// 투명도
  final double opacity;

  /// 커스텀 아이콘
  final IconData? icon;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  /// 보더 반경
  final double borderRadius;

  /// 보더 너비
  final double borderWidth;

  /// 패딩
  final EdgeInsets? padding;

  /// 마진
  final EdgeInsets? margin;

  /// 컨테이너 전체를 채울지 여부 (BoxContainer용)
  final bool fillContainer;

  const PlaceholderBoxItem({
    Key? key,
    required this.label,
    this.size,
    this.color = Colors.lightBlue,
    this.opacity = 0.4,
    this.icon,
    this.textStyle,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.fillContainer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // fillContainer가 true일 때는 컨테이너를 완전히 채우는 위젯 생성
    if (fillContainer) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: padding ?? const EdgeInsets.all(16.0),
        margin: margin,
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          border: borderWidth > 0
              ? Border.all(
                  color: color.withOpacity(0.8),
                  width: borderWidth,
                )
              : null,
          borderRadius:
              borderRadius > 0 ? BorderRadius.circular(borderRadius) : null,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon!,
                  color: color.withOpacity(0.8),
                  size: 32,
                ),
                const SizedBox(height: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle ??
                      TextStyle(
                        color: color.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 기존 방식 (fillContainer가 false일 때)
    Widget child = Container(
      width: size?.width,
      height: size?.height,
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        border: Border.all(
          color: color.withOpacity(0.8),
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon!,
              color: color.withOpacity(0.8),
              size: 32,
            ),
            const SizedBox(height: 8),
          ],
          Flexible(
            child: Text(
              label,
              style: textStyle ??
                  TextStyle(
                    color: color.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );

    return child;
  }
}

/// 확장 가능한 플레이스홀더 박스
///
/// 부모 컨테이너의 크기에 맞춰 확장되는 플레이스홀더입니다.
class ExpandablePlaceholderBox extends StatelessWidget {
  final String label;
  final Color color;
  final double opacity;
  final IconData? icon;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool fillContainer;

  const ExpandablePlaceholderBox({
    Key? key,
    required this.label,
    this.color = Colors.lightBlue,
    this.opacity = 0.4,
    this.icon,
    this.padding,
    this.margin,
    this.fillContainer = true, // 기본적으로 컨테이너를 채우도록 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PlaceholderBoxItem(
        label: label,
        color: color,
        opacity: opacity,
        icon: icon,
        padding: padding,
        margin: margin,
        fillContainer: fillContainer,
      ),
    );
  }
}
