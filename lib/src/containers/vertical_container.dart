import 'package:flutter/material.dart';
import '../widgets/placeholder_list_item.dart';
import 'placeholder_config.dart';

/// 수직 컨테이너 위젯
///
/// Figma의 VERTICAL 레이아웃 모드를 Flutter Column으로 구현합니다.
/// 자식 위젯들을 세로로 배치하며, 플레이스홀더 아이템들을 포함할 수 있습니다.
class VerticalContainer extends StatelessWidget {
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

  /// 메인축 정렬 (세로축)
  final MainAxisAlignment mainAxisAlignment;

  /// 교차축 정렬 (가로축)
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

  /// 최대 높이
  final double? maxHeight;

  const VerticalContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.padding,
    this.margin,
    this.itemSpacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.children,
    this.placeholderItemCount = 4,
    this.placeholderConfig,
    this.scrollable = false,
    this.backgroundColor,
    this.borderRadius,
    this.maxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 자식 위젯들이 없으면 플레이스홀더 사용
    List<Widget> contentChildren = children ?? _buildPlaceholderItems();

    // 아이템 간격 추가
    List<Widget> spacedChildren = _addSpacing(contentChildren);

    Widget columnWidget = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: spacedChildren,
    );

    // 스크롤 가능하게 만들기
    if (scrollable) {
      columnWidget = SingleChildScrollView(
        child: columnWidget,
      );
    }

    // 최대 높이 제한
    if (maxHeight != null) {
      columnWidget = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: columnWidget,
      );
    }

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: columnWidget,
    );
  }

  /// 플레이스홀더 아이템들 빌드
  List<Widget> _buildPlaceholderItems() {
    final config = placeholderConfig ?? PlaceholderConfig();

    return List.generate(placeholderItemCount, (index) {
      return PlaceholderListItem(
        index: index,
        prefix: config.customText ?? 'Item',
        color: config.backgroundColor ?? Colors.green,
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
        spacedChildren.add(SizedBox(height: itemSpacing));
      }
    }
    return spacedChildren;
  }
}

/// 반응형 수직 컨테이너
///
/// 화면 크기에 따라 레이아웃이 자동 조정되는 수직 컨테이너입니다.
class ResponsiveVerticalContainer extends StatelessWidget {
  final String containerId;
  final String containerName;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double itemSpacing;
  final List<Widget>? children;
  final int placeholderItemCount;
  final PlaceholderConfig? placeholderConfig;
  final Color? backgroundColor;

  const ResponsiveVerticalContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.padding,
    this.margin,
    this.itemSpacing = 8.0,
    this.children,
    this.placeholderItemCount = 4,
    this.placeholderConfig,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면이 높으면 스크롤 활성화
        bool shouldScroll = constraints.maxHeight > 800;

        return VerticalContainer(
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
          maxHeight: shouldScroll ? null : constraints.maxHeight * 0.8,
        );
      },
    );
  }
}
