import 'layout_mode.dart';
import 'design_spec_types.dart';

/// Design Specification의 기본 인터페이스
///
/// 앱별로 이 인터페이스를 구현하여 자신만의 Design Spec 모델을 만들 수 있습니다.
abstract class IDesignSpec {
  /// 레이아웃 ID
  String get layoutId;

  /// 이름
  String get name;

  /// 설명
  String get description;

  /// 버전
  String get version;

  /// 마지막 업데이트 날짜
  String get lastUpdated;

  /// 지원하는 화면비 목록
  List<String> get aspectRatios;

  /// 컨테이너 목록
  List<IDesignContainer> get containers;
}

/// Design Container의 기본 인터페이스
///
/// 앱별로 이 인터페이스를 구현하여 자신만의 Container 모델을 만들 수 있습니다.
abstract class IDesignContainer {
  /// 컨테이너 ID
  String get id;

  /// 컨테이너 타입
  ContainerType get type;

  /// 설명
  String? get description;

  /// 위치 정보
  IPosition get position;

  /// 크기 정보
  ISize get size;

  /// 레이아웃 모드
  LayoutMode? get layoutMode;

  /// 반응형 규칙 목록
  List<ResponsiveRule> get responsiveRules;

  /// Z-Index
  int? get zIndex;
}

/// Position의 기본 인터페이스
abstract class IPosition {
  /// X 좌표 (%, px, auto 등)
  String get x;

  /// Y 좌표 (%, px, auto 등)
  String get y;
}

/// Size의 기본 인터페이스
abstract class ISize {
  /// 너비 (%, px, auto, fill 등)
  String get width;

  /// 높이 (%, px, auto, fill 등)
  String get height;
}

/// 안전 영역의 기본 인터페이스
abstract class ISafetyMargin {
  /// 상단 마진
  String get top;

  /// 하단 마진
  String get bottom;

  /// 좌측 마진
  String get left;

  /// 우측 마진
  String get right;
}

/// 접근성 설정의 기본 인터페이스
abstract class IAccessibilityConfig {
  /// 고대비 모드
  bool get highContrastMode;

  /// 큰 글씨 모드
  bool get largeFontMode;

  /// 향상된 포커스 표시기
  bool get enhancedFocusIndicator;

  /// TV 확대 비율
  double? get tvScaleFactor;
}

/// Design Spec 파서 유틸리티
class DesignSpecParser {
  /// JSON 파일로부터 Design Spec 로드
  static Future<T> loadFromAsset<T extends IDesignSpec>(
    String assetPath,
    T Function(Map<String, dynamic>) factory,
  ) async {
    // 구현은 앱별로 다를 수 있음
    throw UnimplementedError('앱별로 구현 필요');
  }

  /// JSON 문자열로부터 Design Spec 파싱
  static T parseFromJson<T extends IDesignSpec>(
    String jsonString,
    T Function(Map<String, dynamic>) factory,
  ) {
    // 구현은 앱별로 다를 수 있음
    throw UnimplementedError('앱별로 구현 필요');
  }

  /// Design Spec 검증
  static ValidationResult validate(IDesignSpec spec) {
    final issues = <String>[];

    // 기본 검증 로직
    if (spec.layoutId.isEmpty) {
      issues.add('layout_id는 필수입니다');
    }

    if (spec.containers.isEmpty) {
      issues.add('최소 하나의 컨테이너가 필요합니다');
    }

    // 컨테이너 ID 중복 검사
    final ids = spec.containers.map((c) => c.id).toList();
    final uniqueIds = ids.toSet();
    if (ids.length != uniqueIds.length) {
      issues.add('컨테이너 ID가 중복됩니다');
    }

    return ValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }
}

/// Design Spec 검증 결과
class ValidationResult {
  const ValidationResult({
    required this.isValid,
    required this.issues,
  });

  /// 유효성 여부
  final bool isValid;

  /// 이슈 목록
  final List<String> issues;
}

/// Design Spec 빌더 (앱별 구현을 위한 헬퍼)
abstract class DesignSpecBuilder<T extends IDesignSpec> {
  /// 빈 Design Spec 생성
  T createEmpty();

  /// 컨테이너 추가
  T addContainer(T spec, IDesignContainer container);

  /// 반응형 규칙 추가
  T addResponsiveRule(T spec, String containerId, ResponsiveRule rule);

  /// Design Spec 복사
  T copyWith(
    T spec, {
    String? layoutId,
    String? name,
    String? description,
    List<IDesignContainer>? containers,
  });
}
