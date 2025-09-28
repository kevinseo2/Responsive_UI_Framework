# Design Spec 구현 가이드

> LG Responsive UI Framework에서 Design Spec을 앱별로 구현하는 방법

## 🎯 아키텍처 결정: 하이브리드 방식

### 왜 하이브리드 방식인가?

1. **프레임워크**: 핵심 타입 정의와 인터페이스만 제공
2. **앱별 구현**: 완전한 Design Spec 모델을 앱 요구사항에 맞게 구현

이 방식의 장점:
- ✅ **유연성**: 앱별 요구사항에 맞는 커스터마이징 가능
- ✅ **경량화**: 프레임워크 크기 최소화
- ✅ **확장성**: 새로운 Design Spec 확장 용이
- ✅ **호환성**: 기존 Design Spec JSON과 완벽 호환

## 🏗️ 프레임워크에서 제공하는 것

### 1. 핵심 인터페이스

```dart
abstract class IDesignSpec {
  String get layoutId;
  String get name;
  String get description;
  String get version;
  String get lastUpdated;
  List<String> get aspectRatios;
  List<IDesignContainer> get containers;
}

abstract class IDesignContainer {
  String get id;
  ContainerType get type;
  String? get description;
  IPosition get position;
  ISize get size;
  LayoutMode? get layoutMode;
  List<ResponsiveRule> get responsiveRules;
  int? get zIndex;
}
```

### 2. 반응형 타입 정의

```dart
enum ContainerType { header, footer, mainContent, sidebar, navigationBar, contentArea }
enum LayoutMode { vertical, horizontal, grid, stack, flex }
enum SizingMode { fixed, fill, fitContent, auto }
class ResponsiveRule { ... }
class ResponsiveOverrides { ... }
```

### 3. 유틸리티 도구

```dart
class DesignSpecParser {
  static ValidationResult validate(IDesignSpec spec);
}

abstract class DesignSpecBuilder<T extends IDesignSpec> {
  T createEmpty();
  T addContainer(T spec, IDesignContainer container);
  T addResponsiveRule(T spec, String containerId, ResponsiveRule rule);
}
```

## 📝 앱별 구현 방법

### 1. 기본 Design Spec 모델 구현

```dart
// lib/models/design_spec.dart
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';

class DesignSpec implements IDesignSpec {
  @override
  final String layoutId;
  
  @override
  final String name;
  
  @override
  final String description;
  
  @override
  final String version;
  
  @override
  final String lastUpdated;
  
  @override
  final List<String> aspectRatios;
  
  @override
  final List<IDesignContainer> containers;
  
  // 앱별 추가 필드
  final List<SupportedResolution> supportedResolutions;
  final SafetyMargin safetyMargin;
  final AccessibilityConfig accessibilityConfig;
  final DPadFocusConfig dpadFocusConfig;
  final GlobalStyles globalStyles;

  DesignSpec({
    required this.layoutId,
    required this.name,
    required this.description,
    required this.version,
    required this.lastUpdated,
    required this.aspectRatios,
    required this.containers,
    required this.supportedResolutions,
    required this.safetyMargin,
    required this.accessibilityConfig,
    required this.dpadFocusConfig,
    required this.globalStyles,
  });

  factory DesignSpec.fromJson(Map<String, dynamic> json) {
    return DesignSpec(
      layoutId: json['layout_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      version: json['version'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      aspectRatios: (json['aspect_ratios'] as List?)?.cast<String>() ?? [],
      containers: (json['containers'] as List?)
          ?.map((e) => DesignContainer.fromJson(e))
          .toList() ?? [],
      supportedResolutions: (json['supported_resolutions'] as List?)
          ?.map((e) => SupportedResolution.fromJson(e))
          .toList() ?? [],
      safetyMargin: SafetyMargin.fromJson(json['safety_margin'] ?? {}),
      accessibilityConfig: AccessibilityConfig.fromJson(
        json['accessibility_config'] ?? {},
      ),
      dpadFocusConfig: DPadFocusConfig.fromJson(
        json['dpad_focus_config'] ?? {},
      ),
      globalStyles: GlobalStyles.fromJson(json['global_styles'] ?? {}),
    );
  }
}
```

### 2. 컨테이너 모델 구현

```dart
class DesignContainer implements IDesignContainer {
  @override
  final String id;
  
  @override
  final ContainerType type;
  
  @override
  final String? description;
  
  @override
  final IPosition position;
  
  @override
  final ISize size;
  
  @override
  final LayoutMode? layoutMode;
  
  @override
  final List<ResponsiveRule> responsiveRules;
  
  @override
  final int? zIndex;
  
  // 앱별 추가 필드
  final String? layoutWrap;
  final String? layoutSizingHorizontal;
  final String? layoutSizingVertical;
  final String? primaryAxisAlignItems;
  final String? counterAxisAlignItems;
  final String? itemSpacing;
  final Spacing? padding;
  final Spacing? margin;
  final Constraints? constraints;

  DesignContainer({
    required this.id,
    required this.type,
    this.description,
    required this.position,
    required this.size,
    this.layoutMode,
    required this.responsiveRules,
    this.zIndex,
    this.layoutWrap,
    this.layoutSizingHorizontal,
    this.layoutSizingVertical,
    this.primaryAxisAlignItems,
    this.counterAxisAlignItems,
    this.itemSpacing,
    this.padding,
    this.margin,
    this.constraints,
  });

  factory DesignContainer.fromJson(Map<String, dynamic> json) {
    return DesignContainer(
      id: json['id'] ?? '',
      type: ContainerType.fromString(json['type'] ?? ''),
      description: json['description'],
      position: Position.fromJson(json['position'] ?? {}),
      size: Size.fromJson(json['size'] ?? {}),
      layoutMode: json['layout_mode'] != null 
          ? LayoutMode.fromString(json['layout_mode']) 
          : null,
      responsiveRules: (json['responsive_rules'] as List?)
          ?.map((e) => ResponsiveRule.fromJson(e))
          .toList() ?? [],
      zIndex: json['z_index'],
      layoutWrap: json['layout_wrap'],
      layoutSizingHorizontal: json['layout_sizing_horizontal'],
      layoutSizingVertical: json['layout_sizing_vertical'],
      primaryAxisAlignItems: json['primary_axis_align_items'],
      counterAxisAlignItems: json['counter_axis_align_items'],
      itemSpacing: json['item_spacing'],
      padding: json['padding'] != null
          ? Spacing.fromJson(json['padding'])
          : null,
      margin: json['margin'] != null 
          ? Spacing.fromJson(json['margin']) 
          : null,
      constraints: json['constraints'] != null
          ? Constraints.fromJson(json['constraints'])
          : null,
    );
  }
}
```

### 3. 위치/크기 모델 구현

```dart
class Position implements IPosition {
  @override
  final String x;
  
  @override
  final String y;

  Position({required this.x, required this.y});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: json['x'] ?? '0%',
      y: json['y'] ?? '0%',
    );
  }
}

class Size implements ISize {
  @override
  final String width;
  
  @override
  final String height;

  Size({required this.width, required this.height});

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      width: json['width'] ?? '100%',
      height: json['height'] ?? '100%',
    );
  }
}
```

### 4. 앱별 확장 모델

```dart
// TV 앱에만 필요한 모델들
class SupportedResolution {
  final String resolution;
  final String aspectRatio;
  final String category;

  SupportedResolution({
    required this.resolution,
    required this.aspectRatio,
    required this.category,
  });

  factory SupportedResolution.fromJson(Map<String, dynamic> json) {
    return SupportedResolution(
      resolution: json['resolution'] ?? '',
      aspectRatio: json['aspect_ratio'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class DPadFocusConfig {
  final bool? enableDpadNavigation;
  final bool? enableKeyboardShortcuts;
  final bool? focusWrap;
  final String? initialFocusId;
  final double? focusScaleFactor;

  DPadFocusConfig({
    this.enableDpadNavigation,
    this.enableKeyboardShortcuts,
    this.focusWrap,
    this.initialFocusId,
    this.focusScaleFactor,
  });

  factory DPadFocusConfig.fromJson(Map<String, dynamic> json) {
    return DPadFocusConfig(
      enableDpadNavigation: json['enable_dpad_navigation'],
      enableKeyboardShortcuts: json['enable_keyboard_shortcuts'],
      focusWrap: json['focus_wrap'],
      initialFocusId: json['initial_focus_id'],
      focusScaleFactor: json['focus_scale_factor']?.toDouble(),
    );
  }
}
```

## 🚀 사용법

### 1. Design Spec 로드 및 검증

```dart
import 'package:flutter/services.dart';
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';
import 'models/design_spec.dart';

class DesignSpecService {
  static Future<DesignSpec> loadDesignSpec(String assetPath) async {
    try {
      // Asset에서 JSON 로드
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      
      // 앱별 모델로 파싱
      final spec = DesignSpec.fromJson(jsonData);
      
      // 프레임워크 검증 도구 사용
      final validation = DesignSpecParser.validate(spec);
      
      if (!validation.isValid) {
        throw Exception('Invalid Design Spec: ${validation.issues.join(', ')}');
      }
      
      return spec;
    } catch (e) {
      throw Exception('Failed to load Design Spec: $e');
    }
  }
}
```

### 2. UI에서 활용

```dart
class MyTVHomeLayout extends StatelessWidget {
  final DesignSpec designSpec;

  const MyTVHomeLayout({
    Key? key,
    required this.designSpec,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicLayoutAdapter(
      builder: (context, aspectRatio) {
        return Scaffold(
          body: Stack(
            children: designSpec.containers.map((container) {
              return _buildContainer(context, container, aspectRatio);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildContainer(
    BuildContext context,
    IDesignContainer container,
    AspectRatioCategory aspectRatio,
  ) {
    // 반응형 규칙 적용
    final rule = container.responsiveRules.firstWhere(
      (rule) => rule.aspectRatio == aspectRatio,
      orElse: () => container.responsiveRules.first,
    );

    return ResponsiveContainer(
      layoutMode: rule.overrides.layoutMode ?? container.layoutMode,
      child: _buildContainerContent(container),
    );
  }
}
```

## 📋 앱별 구현 체크리스트

### ✅ 기본 구현
- [ ] `IDesignSpec` 인터페이스 구현
- [ ] `IDesignContainer` 인터페이스 구현  
- [ ] `IPosition`, `ISize` 인터페이스 구현
- [ ] JSON 파싱 로직 구현
- [ ] Design Spec 검증 활용

### ✅ 앱별 확장
- [ ] 앱 특화 필드 추가 (DPad, 접근성 등)
- [ ] 커스텀 컨테이너 타입 정의
- [ ] 앱별 반응형 규칙 확장
- [ ] 성능 최적화

### ✅ 통합 및 테스트
- [ ] Asset 로딩 구현
- [ ] 에러 처리 구현
- [ ] 반응형 UI 테스트
- [ ] Design Spec 검증 테스트

## 🎯 추천 폴더 구조

```
lib/
├── models/
│   ├── design_spec.dart          # 메인 Design Spec 모델
│   ├── design_container.dart     # 컨테이너 모델
│   ├── position.dart            # 위치 모델
│   ├── size.dart               # 크기 모델
│   └── app_specific/           # 앱별 확장 모델
│       ├── tv_config.dart
│       ├── accessibility_config.dart
│       └── dpad_focus_config.dart
├── services/
│   └── design_spec_service.dart  # Design Spec 로딩 서비스
├── widgets/
│   └── design_spec_layout.dart   # Design Spec 기반 레이아웃
└── main.dart
```

## 🔄 마이그레이션 가이드

### 기존 앱에서 새 아키텍처로 전환

1. **프레임워크 업데이트**
   ```yaml
   dependencies:
     lg_responsive_ui_framework: ^2.0.1
   ```

2. **인터페이스 구현**
   ```dart
   // 기존
   class DesignSpec { ... }
   
   // 새로운 방식
   class DesignSpec implements IDesignSpec { ... }
   ```

3. **검증 로직 활용**
   ```dart
   // 기존
   // 수동 검증
   
   // 새로운 방식
   final validation = DesignSpecParser.validate(spec);
   ```

---

**결론**: 프레임워크에는 핵심 인터페이스만 포함하고, 앱별로는 완전한 구현을 하는 하이브리드 방식이 최적입니다. 이를 통해 유연성과 확장성을 모두 확보할 수 있습니다! 🚀
