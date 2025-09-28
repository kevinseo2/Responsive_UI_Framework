import 'package:flutter/material.dart';
import '../widgets/placeholder_box_item.dart';
import 'placeholder_config.dart';

/// 박스 컨테이너 위젯
///
/// Figma의 RECTANGLE 레이아웃 모드를 Flutter Container로 구현합니다.
/// 단순한 박스 형태의 레이아웃을 제공하며, 플레이스홀더 위젯을 포함할 수 있습니다.
class BoxContainer extends StatelessWidget {
  /// 컨테이너 ID
  final String containerId;

  /// 컨테이너 이름
  final String containerName;

  /// 컨테이너 너비
  final double? width;

  /// 컨테이너 높이
  final double? height;

  /// 패딩
  final EdgeInsets? padding;

  /// 마진
  final EdgeInsets? margin;

  /// 배경색
  final Color? backgroundColor;

  /// 보더 반경
  final BorderRadius? borderRadius;

  /// 보더
  final Border? border;

  /// 그림자
  final List<BoxShadow>? boxShadow;

  /// 자식 위젯 (플레이스홀더 또는 실제 위젯)
  final Widget? child;

  /// 플레이스홀더 설정
  final PlaceholderConfig? placeholderConfig;

  /// 클릭 콜백
  final VoidCallback? onTap;

  const BoxContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.child,
    this.placeholderConfig,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 자식 위젯이 없으면 플레이스홀더 사용
    Widget contentChild = child ?? _buildPlaceholder();

    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: border,
        boxShadow: boxShadow,
      ),
      child: contentChild,
    );

    // 클릭 가능하게 만들기
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: container,
      );
    }

    return container;
  }

  /// 플레이스홀더 빌드
  Widget _buildPlaceholder() {
    final config = placeholderConfig ?? PlaceholderConfig();

    return PlaceholderBoxItem(
      label: config.customText ?? containerName,
      color: config.backgroundColor ?? Colors.lightBlue,
      opacity: config.opacity ?? 0.4,
      icon: config.icon,
      borderRadius: 0, // 외부 컨테이너에서 처리
      borderWidth: 0, // 외부 컨테이너에서 처리
      fillContainer: true, // BoxContainer에서는 항상 컨테이너를 채우도록 설정
    );
  }
}

/// 반응형 박스 컨테이너
///
/// 화면 크기에 따라 크기가 자동 조정되는 박스 컨테이너입니다.
class ResponsiveBoxContainer extends StatelessWidget {
  final String containerId;
  final String containerName;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Widget? child;
  final PlaceholderConfig? placeholderConfig;
  final VoidCallback? onTap;

  const ResponsiveBoxContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.widthFactor = 1.0,
    this.heightFactor = 1.0,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.child,
    this.placeholderConfig,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BoxContainer(
          containerId: containerId,
          containerName: containerName,
          width: constraints.maxWidth * widthFactor,
          height: constraints.maxHeight * heightFactor,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          child: child,
          placeholderConfig: placeholderConfig,
          onTap: onTap,
        );
      },
    );
  }
}
