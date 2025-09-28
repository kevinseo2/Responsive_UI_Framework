/// Flutter UI Layout Coding Specification 기반 레이아웃 모드 정의
///
/// Flutter UI Layout Coding Specification v1.0.0에서 정의된
/// 4가지 Figma 레이아웃 모드를 지원합니다.
enum LayoutMode {
  /// RECTANGLE - 박스형 배치 (Figma 기본 프레임)
  box('RECTANGLE', 'Box'),

  /// HORIZONTAL - 수평 배치 (가로 방향)
  horizontal('HORIZONTAL', 'Horizontal'),

  /// VERTICAL - 수직 배치 (세로 방향)
  vertical('VERTICAL', 'Vertical'),

  /// GRID - 격자형 배치
  grid('GRID', 'Grid');

  const LayoutMode(this.value, this.displayName);

  /// Figma Layout Mode 값
  final String value;

  /// 표시용 이름
  final String displayName;

  /// 문자열로부터 레이아웃 모드 결정
  static LayoutMode fromString(String value) {
    for (final mode in LayoutMode.values) {
      if (mode.value == value) {
        return mode;
      }
    }
    return LayoutMode.box; // 기본값을 RECTANGLE으로 변경
  }

  /// Flutter 컨테이너 클래스명 반환
  String getContainerClassName() {
    switch (this) {
      case LayoutMode.box:
        return 'BoxContainer';
      case LayoutMode.horizontal:
        return 'HorizontalContainer';
      case LayoutMode.vertical:
        return 'VerticalContainer';
      case LayoutMode.grid:
        return 'GridContainer';
    }
  }
}

/// 레이아웃 래핑 모드
enum LayoutWrap {
  /// NO_WRAP - 줄바꿈 없음
  noWrap('NO_WRAP', 'No Wrap'),

  /// WRAP - 자동 줄바꿈
  wrap('WRAP', 'Wrap'),

  /// WRAP_REVERSE - 역순 줄바꿈
  wrapReverse('WRAP_REVERSE', 'Wrap Reverse');

  const LayoutWrap(this.value, this.displayName);

  /// Design Spec 값
  final String value;

  /// 표시용 이름
  final String displayName;

  /// 문자열로부터 래핑 모드 결정
  static LayoutWrap fromString(String value) {
    for (final wrap in LayoutWrap.values) {
      if (wrap.value == value) {
        return wrap;
      }
    }
    return LayoutWrap.noWrap; // 기본값
  }
}

/// 크기 조정 모드
enum SizingMode {
  /// FIXED - 고정 크기
  fixed('FIXED', 'Fixed'),

  /// FILL - 부모 영역 채우기
  fill('FILL', 'Fill'),

  /// FIT_CONTENT - 콘텐츠에 맞춤
  fitContent('FIT_CONTENT', 'Fit Content'),

  /// AUTO - 자동 크기 조정
  auto('AUTO', 'Auto');

  const SizingMode(this.value, this.displayName);

  /// Design Spec 값
  final String value;

  /// 표시용 이름
  final String displayName;

  /// 문자열로부터 크기 조정 모드 결정
  static SizingMode fromString(String value) {
    for (final mode in SizingMode.values) {
      if (mode.value == value) {
        return mode;
      }
    }
    return SizingMode.auto; // 기본값
  }
}

/// 정렬 모드
enum AlignmentMode {
  /// START - 시작점 정렬
  start('START', 'Start'),

  /// CENTER - 중앙 정렬
  center('CENTER', 'Center'),

  /// END - 끝점 정렬
  end('END', 'End'),

  /// STRETCH - 늘림 정렬
  stretch('STRETCH', 'Stretch'),

  /// SPACE_BETWEEN - 균등 분할 (양끝 고정)
  spaceBetween('SPACE_BETWEEN', 'Space Between'),

  /// SPACE_AROUND - 균등 분할 (양끝 여백)
  spaceAround('SPACE_AROUND', 'Space Around'),

  /// SPACE_EVENLY - 균등 분할 (모든 여백 동일)
  spaceEvenly('SPACE_EVENLY', 'Space Evenly');

  const AlignmentMode(this.value, this.displayName);

  /// Design Spec 값
  final String value;

  /// 표시용 이름
  final String displayName;

  /// 문자열로부터 정렬 모드 결정
  static AlignmentMode fromString(String value) {
    for (final alignment in AlignmentMode.values) {
      if (alignment.value == value) {
        return alignment;
      }
    }
    return AlignmentMode.start; // 기본값
  }
}

/// 제약 조건 모드
enum ConstraintMode {
  /// TOP - 상단 제약
  top('TOP', 'Top'),

  /// CENTER - 중앙 제약
  center('CENTER', 'Center'),

  /// BOTTOM - 하단 제약
  bottom('BOTTOM', 'Bottom'),

  /// LEFT - 좌측 제약
  left('LEFT', 'Left'),

  /// RIGHT - 우측 제약
  right('RIGHT', 'Right'),

  /// STRETCH - 늘림 제약
  stretch('STRETCH', 'Stretch');

  const ConstraintMode(this.value, this.displayName);

  /// Design Spec 값
  final String value;

  /// 표시용 이름
  final String displayName;

  /// 문자열로부터 제약 조건 모드 결정
  static ConstraintMode fromString(String value) {
    for (final constraint in ConstraintMode.values) {
      if (constraint.value == value) {
        return constraint;
      }
    }
    return ConstraintMode.center; // 기본값
  }
}
