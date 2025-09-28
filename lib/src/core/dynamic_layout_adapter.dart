import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';
import '../types/responsive_config.dart';
import 'responsive_layout_manager.dart';

/// 동적 레이아웃 어댑터
///
/// 화면 크기 변화에 실시간으로 대응하며,
/// Design Spec 기반 반응형 레이아웃을 제공합니다.
class DynamicLayoutAdapter extends StatefulWidget {
  /// DynamicLayoutAdapter 생성자
  const DynamicLayoutAdapter({
    super.key,
    required this.builder,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.enableAnimation = true,
    this.onAspectRatioChanged,
  });

  /// 화면비별 위젯 빌더
  final Widget Function(BuildContext context, AspectRatioCategory category)
      builder;

  /// 애니메이션 지속 시간
  final Duration animationDuration;

  /// 애니메이션 커브
  final Curve animationCurve;

  /// 애니메이션 활성화 여부
  final bool enableAnimation;

  /// 화면비 변경 콜백
  final void Function(AspectRatioCategory category)? onAspectRatioChanged;

  @override
  State<DynamicLayoutAdapter> createState() => _DynamicLayoutAdapterState();
}

class _DynamicLayoutAdapterState extends State<DynamicLayoutAdapter>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  AspectRatioCategory? _previousCategory;
  AspectRatioCategory? _currentCategory;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _animationController = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        final currentCategory =
            ResponsiveLayoutManager.getAspectRatioCategory(screenSize);

        // 화면비가 변경된 경우
        if (_currentCategory != currentCategory) {
          _previousCategory = _currentCategory;
          _currentCategory = currentCategory;

          // 콜백을 다음 프레임에서 호출하여 빌드 중 setState 방지
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onAspectRatioChanged?.call(currentCategory);
          });

          // 애니메이션 실행
          if (widget.enableAnimation && _previousCategory != null) {
            _animationController.reset();
            _animationController.forward();
          }
        }

        final child = widget.builder(context, currentCategory);

        if (!widget.enableAnimation) {
          return child;
        }

        return AnimatedBuilder(
          animation: _fadeAnimation,
          child: child,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
        );
      },
    );
  }
}

/// 반응형 레이아웃 빌더
///
/// 화면비에 따른 조건부 위젯 빌딩을 제공합니다.
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// ResponsiveLayoutBuilder 생성자
  const ResponsiveLayoutBuilder({
    super.key,
    required this.builder,
    this.fallback,
  });

  /// 화면비별 위젯 빌더
  final Widget Function(BuildContext context, AspectRatioCategory category)
      builder;

  /// 기본 위젯 (화면비 감지 실패 시)
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        try {
          final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
          final category =
              ResponsiveLayoutManager.getAspectRatioCategory(screenSize);
          return builder(context, category);
        } catch (e) {
          return fallback ?? const SizedBox.shrink();
        }
      },
    );
  }
}

/// 반응형 조건부 위젯
///
/// 특정 화면비에서만 표시되는 위젯을 제공합니다.
class ResponsiveConditional extends StatelessWidget {
  /// ResponsiveConditional 생성자
  const ResponsiveConditional({
    super.key,
    required this.condition,
    required this.child,
    this.fallback,
  });

  /// 표시 조건 (화면비별)
  final bool Function(AspectRatioCategory category) condition;

  /// 조건이 참일 때 표시할 위젯
  final Widget child;

  /// 조건이 거짓일 때 표시할 위젯
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, category) {
        if (condition(category)) {
          return child;
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

/// 반응형 브레이크포인트 위젯
///
/// 특정 화면비 이상에서만 표시되는 위젯을 제공합니다.
class ResponsiveBreakpoint extends StatelessWidget {
  /// ResponsiveBreakpoint 생성자
  const ResponsiveBreakpoint({
    super.key,
    required this.breakpoint,
    required this.child,
    this.fallback,
    this.isGreaterThan = true,
  });

  /// 브레이크포인트 화면비
  final AspectRatioCategory breakpoint;

  /// 표시할 위젯
  final Widget child;

  /// 대체 위젯
  final Widget? fallback;

  /// 브레이크포인트 이상에서 표시할지 여부
  final bool isGreaterThan;

  @override
  Widget build(BuildContext context) {
    return ResponsiveConditional(
      condition: (category) {
        final currentIndex = AspectRatioCategory.values.indexOf(category);
        final breakpointIndex = AspectRatioCategory.values.indexOf(breakpoint);

        if (isGreaterThan) {
          return currentIndex >= breakpointIndex;
        } else {
          return currentIndex <= breakpointIndex;
        }
      },
      child: child,
      fallback: fallback,
    );
  }
}

/// 반응형 그리드 어댑터
///
/// 화면비에 따라 그리드 컬럼 수를 자동 조정합니다.
class ResponsiveGridAdapter extends StatelessWidget {
  /// ResponsiveGridAdapter 생성자
  const ResponsiveGridAdapter({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.maxColumns,
    this.minColumns = 1,
  });

  /// 그리드 아이템들
  final List<Widget> children;

  /// 아이템 간 간격
  final double spacing;

  /// 행 간 간격
  final double runSpacing;

  /// 최대 컬럼 수
  final int? maxColumns;

  /// 최소 컬럼 수
  final int minColumns;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, category) {
        final config = ResponsiveConfig.forAspectRatio(category);
        final columns = _calculateColumns(config, category);

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: _calculateItemWidth(context, columns),
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  int _calculateColumns(ResponsiveConfig config, AspectRatioCategory category) {
    int columns = config.gridColumns;

    if (maxColumns != null && columns > maxColumns!) {
      columns = maxColumns!;
    }

    if (columns < minColumns) {
      columns = minColumns;
    }

    return columns;
  }

  double _calculateItemWidth(BuildContext context, int columns) {
    final screenWidth = MediaQuery.of(context).size.width;
    final config = ResponsiveConfig.forAspectRatio(
        ResponsiveLayoutManager.getAspectRatioCategory(
            MediaQuery.of(context).size));

    final availableWidth = screenWidth - (config.sidePadding * 2);
    final totalSpacing = spacing * (columns - 1);
    return (availableWidth - totalSpacing) / columns;
  }
}

/// 반응형 플렉스 어댑터
///
/// 화면비에 따라 플렉스 방향을 자동 조정합니다.
class ResponsiveFlexAdapter extends StatelessWidget {
  /// ResponsiveFlexAdapter 생성자
  const ResponsiveFlexAdapter({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.forceDirection,
  });

  /// 플렉스 아이템들
  final List<Widget> children;

  /// 아이템 간 간격
  final double spacing;

  /// 주축 정렬
  final MainAxisAlignment mainAxisAlignment;

  /// 교차축 정렬
  final CrossAxisAlignment crossAxisAlignment;

  /// 강제 방향 (null이면 자동 결정)
  final Axis? forceDirection;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, category) {
        final direction = forceDirection ?? _getOptimalDirection(category);

        if (direction == Axis.horizontal) {
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _buildChildrenWithSpacing(),
          );
        } else {
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _buildChildrenWithSpacing(),
          );
        }
      },
    );
  }

  Axis _getOptimalDirection(AspectRatioCategory category) {
    if (category.isLandscape) {
      return Axis.horizontal;
    } else {
      return Axis.vertical;
    }
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];

    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(
          width: spacing,
          height: spacing,
        ));
      }
    }
    return result;
  }
}
