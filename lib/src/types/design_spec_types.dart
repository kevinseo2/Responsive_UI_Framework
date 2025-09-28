import 'package:flutter/material.dart';
import 'aspect_ratio_category.dart';
import 'layout_mode.dart';

/// Design Spec 기반 컨테이너 타입
enum ContainerType {
  /// Header - 상단 영역 (제목, 검색, 사용자 정보, 네비게이션)
  header('Header', 'Header'),
  
  /// Footer - 하단 영역 (저작권, 추가 정보, 도움말)
  footer('Footer', 'Footer'),
  
  /// MainContent - 메인 콘텐츠 영역 (유연한 레이아웃 구조)
  mainContent('MainContent', 'Main Content'),
  
  /// Sidebar - 사이드바 영역 (메뉴, 필터, 추가 정보)
  sidebar('Sidebar', 'Sidebar'),
  
  /// NavigationBar - 네비게이션 바 (탭, 메뉴, 브레드크럼)
  navigationBar('NavigationBar', 'Navigation Bar'),
  
  /// ContentArea - 콘텐츠 영역 (리스트, 그리드, 카드 등)
  contentArea('ContentArea', 'Content Area');

  const ContainerType(this.value, this.displayName);

  /// Design Spec 값
  final String value;
  
  /// 표시용 이름
  final String displayName;

  /// 문자열로부터 컨테이너 타입 결정
  static ContainerType fromString(String value) {
    for (final type in ContainerType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return ContainerType.mainContent; // 기본값
  }
}

/// 반응형 규칙 정의
class ResponsiveRule {
  /// ResponsiveRule 생성자
  const ResponsiveRule({
    required this.aspectRatio,
    required this.overrides,
    this.description,
    this.resolutionOverrides,
  });

  /// 대상 화면비
  final AspectRatioCategory aspectRatio;
  
  /// 기본 오버라이드 설정
  final ResponsiveOverrides overrides;
  
  /// 규칙 설명
  final String? description;
  
  /// 해상도별 선택적 오버라이드
  final Map<String, ResponsiveOverrides>? resolutionOverrides;

  /// JSON으로부터 ResponsiveRule 생성
  factory ResponsiveRule.fromJson(Map<String, dynamic> json) {
    return ResponsiveRule(
      aspectRatio: AspectRatioCategory.fromString(json['aspect_ratio']),
      overrides: ResponsiveOverrides.fromJson(json['overrides']),
      description: json['description'],
      resolutionOverrides: json['resolution_overrides']?.map(
        (key, value) => MapEntry(key, ResponsiveOverrides.fromJson(value)),
      ),
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'aspect_ratio': aspectRatio.displayName,
      'overrides': overrides.toJson(),
      if (description != null) 'description': description,
      if (resolutionOverrides != null)
        'resolution_overrides': resolutionOverrides!.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
    };
  }
}

/// 반응형 오버라이드 설정
class ResponsiveOverrides {
  /// ResponsiveOverrides 생성자
  const ResponsiveOverrides({
    this.position,
    this.size,
    this.layoutMode,
    this.layoutWrap,
    this.horizontalSizing,
    this.verticalSizing,
    this.counterAxisSizing,
    this.primaryAxisSizing,
    this.counterAxisAlignment,
    this.primaryAxisAlignment,
    this.itemSpacing,
    this.padding,
    this.margin,
    this.constraints,
  });

  /// 위치 오버라이드
  final PositionOverride? position;
  
  /// 크기 오버라이드
  final SizeOverride? size;
  
  /// 레이아웃 모드 오버라이드
  final LayoutMode? layoutMode;
  
  /// 레이아웃 래핑 오버라이드
  final LayoutWrap? layoutWrap;
  
  /// 수평 크기 조정 오버라이드
  final SizingMode? horizontalSizing;
  
  /// 수직 크기 조정 오버라이드
  final SizingMode? verticalSizing;
  
  /// 교차축 크기 조정 오버라이드
  final SizingMode? counterAxisSizing;
  
  /// 주축 크기 조정 오버라이드
  final SizingMode? primaryAxisSizing;
  
  /// 교차축 정렬 오버라이드
  final AlignmentMode? counterAxisAlignment;
  
  /// 주축 정렬 오버라이드
  final AlignmentMode? primaryAxisAlignment;
  
  /// 아이템 간격 오버라이드
  final double? itemSpacing;
  
  /// 패딩 오버라이드
  final EdgeInsets? padding;
  
  /// 마진 오버라이드
  final EdgeInsets? margin;
  
  /// 제약 조건 오버라이드
  final ConstraintsOverride? constraints;

  /// JSON으로부터 ResponsiveOverrides 생성
  factory ResponsiveOverrides.fromJson(Map<String, dynamic> json) {
    return ResponsiveOverrides(
      position: json['position'] != null 
          ? PositionOverride.fromJson(json['position']) 
          : null,
      size: json['size'] != null 
          ? SizeOverride.fromJson(json['size']) 
          : null,
      layoutMode: json['layout_mode'] != null 
          ? LayoutMode.fromString(json['layout_mode']) 
          : null,
      layoutWrap: json['layout_wrap'] != null 
          ? LayoutWrap.fromString(json['layout_wrap']) 
          : null,
      horizontalSizing: json['layout_sizing_horizontal'] != null 
          ? SizingMode.fromString(json['layout_sizing_horizontal']) 
          : null,
      verticalSizing: json['layout_sizing_vertical'] != null 
          ? SizingMode.fromString(json['layout_sizing_vertical']) 
          : null,
      counterAxisSizing: json['counter_axis_sizing_mode'] != null 
          ? SizingMode.fromString(json['counter_axis_sizing_mode']) 
          : null,
      primaryAxisSizing: json['primary_axis_sizing_mode'] != null 
          ? SizingMode.fromString(json['primary_axis_sizing_mode']) 
          : null,
      counterAxisAlignment: json['counter_axis_align_items'] != null 
          ? AlignmentMode.fromString(json['counter_axis_align_items']) 
          : null,
      primaryAxisAlignment: json['primary_axis_align_items'] != null 
          ? AlignmentMode.fromString(json['primary_axis_align_items']) 
          : null,
      itemSpacing: json['item_spacing']?.toDouble(),
      padding: json['padding'] != null 
          ? EdgeInsets.fromLTRB(
              json['padding']['left']?.toDouble() ?? 0,
              json['padding']['top']?.toDouble() ?? 0,
              json['padding']['right']?.toDouble() ?? 0,
              json['padding']['bottom']?.toDouble() ?? 0,
            )
          : null,
      margin: json['margin'] != null 
          ? EdgeInsets.fromLTRB(
              json['margin']['left']?.toDouble() ?? 0,
              json['margin']['top']?.toDouble() ?? 0,
              json['margin']['right']?.toDouble() ?? 0,
              json['margin']['bottom']?.toDouble() ?? 0,
            )
          : null,
      constraints: json['constraints'] != null 
          ? ConstraintsOverride.fromJson(json['constraints']) 
          : null,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (position != null) 'position': position!.toJson(),
      if (size != null) 'size': size!.toJson(),
      if (layoutMode != null) 'layout_mode': layoutMode!.value,
      if (layoutWrap != null) 'layout_wrap': layoutWrap!.value,
      if (horizontalSizing != null) 'layout_sizing_horizontal': horizontalSizing!.value,
      if (verticalSizing != null) 'layout_sizing_vertical': verticalSizing!.value,
      if (counterAxisSizing != null) 'counter_axis_sizing_mode': counterAxisSizing!.value,
      if (primaryAxisSizing != null) 'primary_axis_sizing_mode': primaryAxisSizing!.value,
      if (counterAxisAlignment != null) 'counter_axis_align_items': counterAxisAlignment!.value,
      if (primaryAxisAlignment != null) 'primary_axis_align_items': primaryAxisAlignment!.value,
      if (itemSpacing != null) 'item_spacing': itemSpacing,
      if (padding != null) 'padding': {
        'left': padding!.left,
        'top': padding!.top,
        'right': padding!.right,
        'bottom': padding!.bottom,
      },
      if (margin != null) 'margin': {
        'left': margin!.left,
        'top': margin!.top,
        'right': margin!.right,
        'bottom': margin!.bottom,
      },
      if (constraints != null) 'constraints': constraints!.toJson(),
    };
  }
}

/// 위치 오버라이드
class PositionOverride {
  /// PositionOverride 생성자
  const PositionOverride({
    required this.x,
    required this.y,
  });

  /// X 좌표
  final String x;
  
  /// Y 좌표
  final String y;

  /// JSON으로부터 PositionOverride 생성
  factory PositionOverride.fromJson(Map<String, dynamic> json) {
    return PositionOverride(
      x: json['x'] ?? '0%',
      y: json['y'] ?? '0%',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}

/// 크기 오버라이드
class SizeOverride {
  /// SizeOverride 생성자
  const SizeOverride({
    required this.width,
    required this.height,
  });

  /// 너비
  final String width;
  
  /// 높이
  final String height;

  /// JSON으로부터 SizeOverride 생성
  factory SizeOverride.fromJson(Map<String, dynamic> json) {
    return SizeOverride(
      width: json['width'] ?? '100%',
      height: json['height'] ?? '100%',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}

/// 제약 조건 오버라이드
class ConstraintsOverride {
  /// ConstraintsOverride 생성자
  const ConstraintsOverride({
    this.vertical,
    this.horizontal,
  });

  /// 수직 제약 조건
  final ConstraintMode? vertical;
  
  /// 수평 제약 조건
  final ConstraintMode? horizontal;

  /// JSON으로부터 ConstraintsOverride 생성
  factory ConstraintsOverride.fromJson(Map<String, dynamic> json) {
    return ConstraintsOverride(
      vertical: json['vertical'] != null 
          ? ConstraintMode.fromString(json['vertical']) 
          : null,
      horizontal: json['horizontal'] != null 
          ? ConstraintMode.fromString(json['horizontal']) 
          : null,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (vertical != null) 'vertical': vertical!.value,
      if (horizontal != null) 'horizontal': horizontal!.value,
    };
  }
}
