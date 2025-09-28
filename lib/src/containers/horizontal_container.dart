import 'package:flutter/material.dart';
import '../widgets/placeholder_list_item.dart';
import 'placeholder_config.dart';

/// 수평 컨테이너 위젯
///
/// Figma의 HORIZONTAL 레이아웃 모드를 Flutter Row로 구현합니다.
/// 자식 위젯들을 가로로 배치하며, 플레이스홀더 아이템들을 포함할 수 있습니다.
class HorizontalContainer extends StatelessWidget {
  /// 컨테이너 ID
  final String containerId;

  /// 컨테이너 이름
  final String containerName;

  /// 패딩
  final EdgeInsets? padding;

  /// 마진
  final EdgeInsets? margin;

  /// 아이템 간격
  final double itemSpacing;

  /// 메인축 정렬 (가로축)
  final MainAxisAlignment mainAxisAlignment;

  /// 교차축 정렬 (세로축)
  final CrossAxisAlignment crossAxisAlignment;

  /// 자식 위젯들
  final List<Widget>? children;

  /// 플레이스홀더 아이템 개수 (children이 null일 때 사용)
  final int placeholderItemCount;

  /// 플레이스홀더 설정
  final PlaceholderConfig? placeholderConfig;

  /// 스크롤 가능 여부
  final bool scrollable;

  /// 배경색
  final Color? backgroundColor;

  /// 보더 반경
  final BorderRadius? borderRadius;

  const HorizontalContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.padding,
    this.margin,
    this.itemSpacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.children,
    this.placeholderItemCount = 3,
    this.placeholderConfig,
    this.scrollable = false,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 자식 위젯들이 없으면 플레이스홀더 사용
    List<Widget> contentChildren = children ?? _buildPlaceholderItems();

    // 아이템 간격 추가
    List<Widget> spacedChildren = _addSpacing(contentChildren);

    Widget rowWidget = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacedChildren,
    );

    // 스크롤 가능하게 만들기
    if (scrollable) {
      rowWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: rowWidget,
      );
    }

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: rowWidget,
    );
  }

  /// 플레이스홀더 아이템들 빌드
  List<Widget> _buildPlaceholderItems() {
    final config = placeholderConfig ?? PlaceholderConfig();

    return List.generate(placeholderItemCount, (index) {
      return Flexible(
        child: PlaceholderListItem(
          index: index,
          prefix: config.customText ?? 'Item',
          color: config.backgroundColor ?? Colors.green,
          height: 80,
        ),
      );
    });
  }

  /// 아이템 간격 추가
  List<Widget> _addSpacing(List<Widget> children) {
    if (children.isEmpty || itemSpacing <= 0) return children;

    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: itemSpacing));
      }
    }
    return spacedChildren;
  }
}

/// 반응형 수평 컨테이너
///
/// 화면 크기에 따라 레이아웃이 자동 조정되는 수평 컨테이너입니다.
class ResponsiveHorizontalContainer extends StatelessWidget {
  final String containerId;
  final String containerName;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double itemSpacing;
  final List<Widget>? children;
  final int placeholderItemCount;
  final PlaceholderConfig? placeholderConfig;
  final Color? backgroundColor;

  const ResponsiveHorizontalContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.padding,
    this.margin,
    this.itemSpacing = 8.0,
    this.children,
    this.placeholderItemCount = 3,
    this.placeholderConfig,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면이 좁으면 스크롤 활성화
        bool shouldScroll = constraints.maxWidth < 600;

        return HorizontalContainer(
          containerId: containerId,
          containerName: containerName,
          padding: padding ?? EdgeInsets.all(constraints.maxWidth * 0.02),
          margin: margin,
          itemSpacing: itemSpacing,
          children: children,
          placeholderItemCount: placeholderItemCount,
          placeholderConfig: placeholderConfig,
          scrollable: shouldScroll,
          backgroundColor: backgroundColor,
        );
      },
    );
  }
}
