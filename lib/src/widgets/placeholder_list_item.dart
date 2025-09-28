import 'package:flutter/material.dart';

/// 리스트 아이템 플레이스홀더 위젯
///
/// Figma의 VERTICAL, HORIZONTAL 레이아웃에서 사용되는
/// 리스트 아이템을 대체하기 위한 플레이스홀더입니다.
class PlaceholderListItem extends StatelessWidget {
  /// 아이템 인덱스
  final int index;

  /// 아이템 접두사
  final String prefix;

  /// 배경 색상
  final Color color;

  /// 높이 (null이면 자동)
  final double? height;

  /// 패딩
  final EdgeInsets? padding;

  /// 마진
  final EdgeInsets? margin;

  /// 아이콘
  final IconData? icon;

  /// 부제목
  final String? subtitle;

  /// 활성화 상태
  final bool isActive;

  /// 클릭 가능 여부
  final bool isClickable;

  /// 클릭 콜백
  final VoidCallback? onTap;

  const PlaceholderListItem({
    Key? key,
    required this.index,
    this.prefix = 'Item',
    this.color = Colors.green,
    this.height,
    this.padding,
    this.margin,
    this.icon,
    this.subtitle,
    this.isActive = false,
    this.isClickable = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isActive ? color : color.withOpacity(0.7);

    Widget child = Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        border: Border.all(
          color: effectiveColor.withOpacity(0.3),
          width: isActive ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: effectiveColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // 아이콘
          Icon(
            icon ?? Icons.view_list,
            color: effectiveColor,
            size: 24,
          ),
          const SizedBox(width: 12),

          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$prefix ${index + 1}',
                  style: TextStyle(
                    color: effectiveColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: effectiveColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 플레이스홀더 라벨
          Text(
            'Placeholder',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );

    if (isClickable && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: child,
      );
    }

    return child;
  }
}

/// 간단한 리스트 아이템 플레이스홀더
class SimplePlaceholderListItem extends StatelessWidget {
  final int index;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const SimplePlaceholderListItem({
    Key? key,
    required this.index,
    required this.title,
    this.color = Colors.green,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlaceholderListItem(
      index: index,
      prefix: title,
      color: color,
      height: 60,
      onTap: onTap,
    );
  }
}
