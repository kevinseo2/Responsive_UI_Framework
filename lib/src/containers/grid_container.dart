import 'package:flutter/material.dart';
import '../widgets/placeholder_grid_item.dart';
import 'placeholder_config.dart';

/// 그리드 컨테이너 위젯
///
/// Figma의 GRID 레이아웃 모드를 Flutter GridView로 구현합니다.
/// 자식 위젯들을 격자로 배치하며, 플레이스홀더 아이템들을 포함할 수 있습니다.
class GridContainer extends StatelessWidget {
  /// 컨테이너 ID
  final String containerId;

  /// 컨테이너 이름
  final String containerName;

  /// 패딩
  final EdgeInsets? padding;

  /// 마진
  final EdgeInsets? margin;

  /// 가로 컬럼 수
  final int crossAxisCount;

  /// 자식 비율 (width:height)
  final double childAspectRatio;

  /// 아이템 간격
  final double itemSpacing;

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

  const GridContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.padding,
    this.margin,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.itemSpacing = 8.0,
    this.children,
    this.placeholderItemCount = 6,
    this.placeholderConfig,
    this.scrollable = true,
    this.backgroundColor,
    this.borderRadius,
    this.maxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 자식 위젯들이 없으면 플레이스홀더 사용
    List<Widget> contentChildren = children ?? _buildPlaceholderItems();

    Widget gridWidget = GridView.builder(
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: itemSpacing,
        mainAxisSpacing: itemSpacing,
      ),
      itemCount: contentChildren.length,
      itemBuilder: (context, index) {
        return contentChildren[index];
      },
    );

    // 최대 높이 제한
    if (maxHeight != null && !scrollable) {
      gridWidget = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: gridWidget,
      );
    }

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: gridWidget,
    );
  }

  /// 플레이스홀더 아이템들 빌드
  List<Widget> _buildPlaceholderItems() {
    final config = placeholderConfig ?? PlaceholderConfig();

    return List.generate(placeholderItemCount, (index) {
      return PlaceholderGridItem(
        index: index,
        prefix: config.customText ?? 'Grid',
        color: config.backgroundColor ?? Colors.blue,
      );
    });
  }
}

/// 반응형 그리드 컨테이너
///
/// 화면 크기에 따라 컬럼 수와 레이아웃이 자동 조정되는 그리드 컨테이너입니다.
class ResponsiveGridContainer extends StatelessWidget {
  final String containerId;
  final String containerName;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double itemSpacing;
  final List<Widget>? children;
  final int placeholderItemCount;
  final PlaceholderConfig? placeholderConfig;
  final Color? backgroundColor;

  /// 최소 아이템 너비 (반응형 계산용)
  final double minItemWidth;

  const ResponsiveGridContainer({
    Key? key,
    required this.containerId,
    required this.containerName,
    this.padding,
    this.margin,
    this.itemSpacing = 8.0,
    this.children,
    this.placeholderItemCount = 6,
    this.placeholderConfig,
    this.backgroundColor,
    this.minItemWidth = 150.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 반응형 컬럼 계산
        int crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        // 화면 비율에 따른 아이템 비율 계산
        double childAspectRatio = _calculateChildAspectRatio(constraints);

        return GridContainer(
          containerId: containerId,
          containerName: containerName,
          padding: padding ?? EdgeInsets.all(constraints.maxWidth * 0.02),
          margin: margin,
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          itemSpacing: itemSpacing,
          children: children,
          placeholderItemCount: placeholderItemCount,
          placeholderConfig: placeholderConfig,
          scrollable: true,
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  /// 화면 너비에 따른 컬럼 수 계산
  int _calculateCrossAxisCount(double availableWidth) {
    // 아이템 간격을 고려한 실제 사용 가능한 너비
    double usableWidth = availableWidth - (padding?.horizontal ?? 0);

    // 최소 아이템 너비를 기준으로 컬럼 수 계산
    int columns = (usableWidth / (minItemWidth + itemSpacing)).floor();

    // 최소 1개, 최대 6개 컬럼
    return columns.clamp(1, 6);
  }

  /// 화면 비율에 따른 아이템 종횡비 계산
  double _calculateChildAspectRatio(BoxConstraints constraints) {
    double screenRatio = constraints.maxWidth / constraints.maxHeight;

    // 16:9 (가로형) → 1.2 비율
    if (screenRatio > 1.6) return 1.2;

    // 4:3 (정방형에 가까움) → 1.0 비율
    if (screenRatio > 1.2) return 1.0;

    // 세로형 → 0.8 비율
    return 0.8;
  }
}
