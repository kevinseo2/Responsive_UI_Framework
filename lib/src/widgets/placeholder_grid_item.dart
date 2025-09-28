import 'package:flutter/material.dart';

/// 그리드 아이템 플레이스홀더 위젯
///
/// Figma의 GRID 레이아웃에서 사용되는
/// 그리드 아이템을 대체하기 위한 플레이스홀더입니다.
class PlaceholderGridItem extends StatelessWidget {
  /// 그리드 아이템 인덱스
  final int index;

  /// 아이템 접두사
  final String prefix;

  /// 배경 색상
  final Color color;

  /// 종횡비
  final double? aspectRatio;

  /// 패딩
  final EdgeInsets? padding;

  /// 마진
  final EdgeInsets? margin;

  /// 아이콘
  final IconData? icon;

  /// 제목
  final String? title;

  /// 부제목
  final String? subtitle;

  /// 클릭 콜백
  final VoidCallback? onTap;

  /// 선택 상태
  final bool isSelected;

  const PlaceholderGridItem({
    Key? key,
    required this.index,
    this.prefix = 'Grid',
    this.color = Colors.purple,
    this.aspectRatio,
    this.padding,
    this.margin,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isSelected ? color : color.withOpacity(0.7);
    final displayTitle = title ?? '$prefix ${index + 1}';

    Widget child = Container(
      margin: margin ?? const EdgeInsets.all(4),
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        border: Border.all(
          color: effectiveColor.withOpacity(0.4),
          width: isSelected ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: effectiveColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          Icon(
            icon ?? Icons.grid_view,
            color: effectiveColor,
            size: 40,
          ),
          const SizedBox(height: 8),

          // 제목
          Text(
            displayTitle,
            style: TextStyle(
              color: effectiveColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // 부제목
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                color: effectiveColor.withOpacity(0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              'Placeholder',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    // 종횡비 적용
    if (aspectRatio != null) {
      child = AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }

    // 클릭 가능하게 만들기
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: child,
      );
    }

    return child;
  }
}

/// 카드 스타일 그리드 아이템 플레이스홀더
class CardStyleGridItem extends StatelessWidget {
  final int index;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback? onTap;

  const CardStyleGridItem({
    Key? key,
    required this.index,
    required this.title,
    this.subtitle,
    this.color = Colors.purple,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlaceholderGridItem(
      index: index,
      prefix: title,
      color: color,
      aspectRatio: 1.0,
      subtitle: subtitle,
      onTap: onTap,
      icon: Icons.dashboard,
    );
  }
}

/// 미디어 스타일 그리드 아이템 플레이스홀더
class MediaStyleGridItem extends StatelessWidget {
  final int index;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const MediaStyleGridItem({
    Key? key,
    required this.index,
    required this.title,
    this.color = Colors.orange,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlaceholderGridItem(
      index: index,
      prefix: title,
      color: color,
      aspectRatio: 16.0 / 9.0,
      subtitle: 'Media Item',
      onTap: onTap,
      icon: Icons.play_circle_filled,
    );
  }
}
