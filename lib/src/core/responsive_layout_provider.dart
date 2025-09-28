import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';
import '../types/responsive_config.dart';
import '../types/layout_mode.dart';
import 'responsive_layout_manager.dart';

/// 반응형 레이아웃 프로바이더
///
/// 하위 위젯들에게 반응형 설정을 제공하는 InheritedWidget입니다.
class ResponsiveLayoutProvider extends InheritedWidget {
  /// ResponsiveLayoutProvider 생성자
  const ResponsiveLayoutProvider({
    Key? key,
    required this.child,
    this.config,
    this.category,
    this.onConfigChanged,
  }) : super(key: key, child: child);

  /// 하위 위젯
  final Widget child;

  /// 반응형 설정 (null이면 자동 계산)
  final ResponsiveConfig? config;

  /// 화면비 카테고리 (null이면 자동 감지)
  final AspectRatioCategory? category;

  /// 설정 변경 콜백
  final void Function(ResponsiveConfig config, AspectRatioCategory category)?
      onConfigChanged;

  @override
  bool updateShouldNotify(ResponsiveLayoutProvider oldWidget) {
    return config != oldWidget.config || category != oldWidget.category;
  }

  /// 현재 반응형 설정 가져오기
  static ResponsiveConfig of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ResponsiveLayoutProvider>();
    if (provider?.config != null) {
      return provider!.config!;
    }

    // 자동 계산
    return ResponsiveLayoutManager.getConfig(context);
  }

  /// 현재 화면비 카테고리 가져오기
  static AspectRatioCategory getCategory(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ResponsiveLayoutProvider>();
    if (provider?.category != null) {
      return provider!.category!;
    }

    // 자동 감지
    final screenSize = MediaQuery.of(context).size;
    return ResponsiveLayoutManager.getAspectRatioCategory(screenSize);
  }

  /// 반응형 설정과 화면비 카테고리 모두 가져오기
  static (ResponsiveConfig config, AspectRatioCategory category)
      getConfigAndCategory(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ResponsiveLayoutProvider>();

    ResponsiveConfig config;
    AspectRatioCategory category;

    if (provider?.config != null && provider?.category != null) {
      config = provider!.config!;
      category = provider.category!;
    } else {
      // 자동 계산
      final screenSize = MediaQuery.of(context).size;
      category = ResponsiveLayoutManager.getAspectRatioCategory(screenSize);
      config = ResponsiveConfig.forAspectRatio(category);
    }

    return (config, category);
  }

  /// 반응형 설정이 존재하는지 확인
  static bool hasConfig(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ResponsiveLayoutProvider>() !=
        null;
  }
}

/// 반응형 레이아웃 컨트롤러
///
/// 반응형 설정을 동적으로 제어할 수 있는 StatefulWidget입니다.
class ResponsiveLayoutController extends StatefulWidget {
  /// ResponsiveLayoutController 생성자
  const ResponsiveLayoutController({
    super.key,
    required this.child,
    this.initialConfig,
    this.initialCategory,
    this.onConfigChanged,
  });

  /// 하위 위젯
  final Widget child;

  /// 초기 설정
  final ResponsiveConfig? initialConfig;

  /// 초기 화면비 카테고리
  final AspectRatioCategory? initialCategory;

  /// 설정 변경 콜백
  final void Function(ResponsiveConfig config, AspectRatioCategory category)?
      onConfigChanged;

  @override
  State<ResponsiveLayoutController> createState() =>
      _ResponsiveLayoutControllerState();
}

class _ResponsiveLayoutControllerState
    extends State<ResponsiveLayoutController> {
  ResponsiveConfig? _config;
  AspectRatioCategory? _category;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
    _category = widget.initialCategory;
  }

  /// 설정 업데이트
  void updateConfig(ResponsiveConfig config, AspectRatioCategory category) {
    setState(() {
      _config = config;
      _category = category;
    });
    widget.onConfigChanged?.call(config, category);
  }

  /// 설정 리셋
  void resetConfig() {
    setState(() {
      _config = null;
      _category = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutProvider(
      config: _config,
      category: _category,
      onConfigChanged: widget.onConfigChanged,
      child: widget.child,
    );
  }
}

/// 반응형 레이아웃 설정 빌더
///
/// 현재 반응형 설정을 기반으로 위젯을 빌드합니다.
class ResponsiveConfigBuilder extends StatelessWidget {
  /// ResponsiveConfigBuilder 생성자
  const ResponsiveConfigBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// 반응형 설정 기반 빌더
  final Widget Function(BuildContext context, ResponsiveConfig config,
      AspectRatioCategory category) builder;

  @override
  Widget build(BuildContext context) {
    final (config, category) =
        ResponsiveLayoutProvider.getConfigAndCategory(context);
    return builder(context, config, category);
  }
}

/// 반응형 설정 위젯
///
/// 특정 반응형 설정을 하위 위젯에 적용합니다.
class ResponsiveConfigWidget extends StatelessWidget {
  /// ResponsiveConfigWidget 생성자
  const ResponsiveConfigWidget({
    super.key,
    required this.config,
    required this.category,
    required this.child,
  });

  /// 적용할 반응형 설정
  final ResponsiveConfig config;

  /// 적용할 화면비 카테고리
  final AspectRatioCategory category;

  /// 하위 위젯
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutProvider(
      config: config,
      category: category,
      child: child,
    );
  }
}

/// 반응형 설정 오버라이드
///
/// 기존 설정을 오버라이드하여 새로운 설정을 적용합니다.
class ResponsiveConfigOverride extends StatelessWidget {
  /// ResponsiveConfigOverride 생성자
  const ResponsiveConfigOverride({
    super.key,
    required this.child,
    this.gridColumns,
    this.maxContentWidth,
    this.sidePadding,
    this.contentSpacing,
    this.layoutMode,
    this.itemSpacing,
  });

  /// 하위 위젯
  final Widget child;

  /// 오버라이드할 그리드 컬럼 수
  final int? gridColumns;

  /// 오버라이드할 최대 콘텐츠 너비
  final double? maxContentWidth;

  /// 오버라이드할 측면 패딩
  final double? sidePadding;

  /// 오버라이드할 콘텐츠 간격
  final double? contentSpacing;

  /// 오버라이드할 레이아웃 모드
  final LayoutMode? layoutMode;

  /// 오버라이드할 아이템 간격
  final double? itemSpacing;

  @override
  Widget build(BuildContext context) {
    return ResponsiveConfigBuilder(
      builder: (context, baseConfig, category) {
        final overriddenConfig = baseConfig.copyWith(
          gridColumns: gridColumns,
          maxContentWidth: maxContentWidth,
          sidePadding: sidePadding,
          contentSpacing: contentSpacing,
          layoutMode: layoutMode,
          itemSpacing: itemSpacing,
        );

        return ResponsiveConfigWidget(
          config: overriddenConfig,
          category: category,
          child: child,
        );
      },
    );
  }
}

/// 반응형 설정 리스너
///
/// 반응형 설정 변경을 감지하고 콜백을 호출합니다.
class ResponsiveConfigListener extends StatefulWidget {
  /// ResponsiveConfigListener 생성자
  const ResponsiveConfigListener({
    super.key,
    required this.child,
    required this.onConfigChanged,
  });

  /// 하위 위젯
  final Widget child;

  /// 설정 변경 콜백
  final void Function(ResponsiveConfig config, AspectRatioCategory category)
      onConfigChanged;

  @override
  State<ResponsiveConfigListener> createState() =>
      _ResponsiveConfigListenerState();
}

class _ResponsiveConfigListenerState extends State<ResponsiveConfigListener> {
  ResponsiveConfig? _previousConfig;
  AspectRatioCategory? _previousCategory;

  @override
  Widget build(BuildContext context) {
    return ResponsiveConfigBuilder(
      builder: (context, config, category) {
        // 설정이 변경된 경우 콜백 호출
        if (_previousConfig != config || _previousCategory != category) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onConfigChanged(config, category);
          });
          _previousConfig = config;
          _previousCategory = category;
        }

        return widget.child;
      },
    );
  }
}
