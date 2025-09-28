# LG Responsive UI Framework v2.0 - API 참조

> Design Spec 기반 반응형 UI 프레임워크 API 문서

이 문서는 LG Responsive UI Framework v2.0의 모든 API를 상세히 설명합니다.

## 📋 목차

1. [핵심 시스템](#핵심-시스템)
2. [적응형 컴포넌트](#적응형-컴포넌트) 
3. [반응형 위젯](#반응형-위젯)
4. [반응형 UI 시뮬레이터](#반응형-ui-시뮬레이터)
5. [타입 정의](#타입-정의)
6. [유틸리티](#유틸리티)

## 🏗️ 핵심 시스템

### ResponsiveLayoutManager

화면비별 반응형 설정을 관리하는 핵심 클래스입니다.

#### 정적 메서드

##### `getAspectRatioCategory(Size screenSize)`
현재 화면 크기를 기반으로 화면비 카테고리를 결정합니다.

```dart
static AspectRatioCategory getAspectRatioCategory(Size screenSize)
```

**매개변수:**
- `screenSize`: 화면 크기

**반환값:**
- `AspectRatioCategory`: 화면비 카테고리

**예시:**
```dart
final screenSize = MediaQuery.of(context).size;
final category = ResponsiveLayoutManager.getAspectRatioCategory(screenSize);
```

##### `getConfig(BuildContext context)`
현재 화면비에 해당하는 반응형 설정을 반환합니다.

```dart
static ResponsiveConfig getConfig(BuildContext context)
```

**매개변수:**
- `context`: BuildContext

**반환값:**
- `ResponsiveConfig`: 반응형 설정

**예시:**
```dart
final config = ResponsiveLayoutManager.getConfig(context);
print('Grid columns: ${config.gridColumns}');
```

##### `getSafeArea(BuildContext context)`
화면비별 안전 영역을 계산합니다.

```dart
static EdgeInsets getSafeArea(BuildContext context)
```

**매개변수:**
- `context`: BuildContext

**반환값:**
- `EdgeInsets`: 안전 영역

**예시:**
```dart
final safeArea = ResponsiveLayoutManager.getSafeArea(context);
```

##### `getResponsiveFontSize(BuildContext context, {required double baseFontSize})`
반응형 폰트 크기를 계산합니다.

```dart
static double getResponsiveFontSize(BuildContext context, {required double baseFontSize})
```

**매개변수:**
- `context`: BuildContext
- `baseFontSize`: 기본 폰트 크기

**반환값:**
- `double`: 반응형 폰트 크기

**예시:**
```dart
final fontSize = ResponsiveLayoutManager.getResponsiveFontSize(
  context,
  baseFontSize: 16,
);
```

##### `getResponsiveSpacing(BuildContext context, {required double baseSpacing})`
반응형 간격을 계산합니다.

```dart
static double getResponsiveSpacing(BuildContext context, {required double baseSpacing})
```

**매개변수:**
- `context`: BuildContext
- `baseSpacing`: 기본 간격

**반환값:**
- `double`: 반응형 간격

**예시:**
```dart
final spacing = ResponsiveLayoutManager.getResponsiveSpacing(
  context,
  baseSpacing: 8,
);
```

##### `isBreakpoint(BuildContext context, {required AspectRatioCategory breakpoint, bool isGreaterThan = true})`
반응형 브레이크포인트를 확인합니다.

```dart
static bool isBreakpoint(BuildContext context, {required AspectRatioCategory breakpoint, bool isGreaterThan = true})
```

**매개변수:**
- `context`: BuildContext
- `breakpoint`: 브레이크포인트 화면비
- `isGreaterThan`: 이상/이하 여부

**반환값:**
- `bool`: 브레이크포인트 조건 만족 여부

**예시:**
```dart
final isWideScreen = ResponsiveLayoutManager.isBreakpoint(
  context,
  breakpoint: AspectRatioCategory.widescreen,
);
```

### DynamicLayoutAdapter

화면 크기 변화에 실시간으로 대응하는 위젯입니다.

#### 생성자

```dart
const DynamicLayoutAdapter({
  Key? key,
  required Widget Function(BuildContext context, AspectRatioCategory category) builder,
  Duration animationDuration = const Duration(milliseconds: 300),
  Curve animationCurve = Curves.easeInOut,
  bool enableAnimation = true,
  void Function(AspectRatioCategory category)? onAspectRatioChanged,
})
```

**매개변수:**
- `builder`: 화면비별 위젯 빌더
- `animationDuration`: 애니메이션 지속 시간
- `animationCurve`: 애니메이션 커브
- `enableAnimation`: 애니메이션 활성화 여부
- `onAspectRatioChanged`: 화면비 변경 콜백

**예시:**
```dart
DynamicLayoutAdapter(
  builder: (context, aspectRatio) {
    return MyWidget();
  },
  animationDuration: Duration(milliseconds: 500),
  enableAnimation: true,
  onAspectRatioChanged: (category) {
    print('Aspect ratio changed to: ${category.displayName}');
  },
)
```

### ResponsiveLayoutProvider

하위 위젯들에게 반응형 설정을 제공하는 InheritedWidget입니다.

#### 생성자

```dart
const ResponsiveLayoutProvider({
  Key? key,
  required Widget child,
  ResponsiveConfig? config,
  AspectRatioCategory? category,
  void Function(ResponsiveConfig config, AspectRatioCategory category)? onConfigChanged,
})
```

**매개변수:**
- `child`: 하위 위젯
- `config`: 반응형 설정 (null이면 자동 계산)
- `category`: 화면비 카테고리 (null이면 자동 감지)
- `onConfigChanged`: 설정 변경 콜백

#### 정적 메서드

##### `of(BuildContext context)`
현재 반응형 설정을 가져옵니다.

```dart
static ResponsiveConfig of(BuildContext context)
```

**매개변수:**
- `context`: BuildContext

**반환값:**
- `ResponsiveConfig`: 반응형 설정

**예시:**
```dart
final config = ResponsiveLayoutProvider.of(context);
```

##### `getCategory(BuildContext context)`
현재 화면비 카테고리를 가져옵니다.

```dart
static AspectRatioCategory getCategory(BuildContext context)
```

**매개변수:**
- `context`: BuildContext

**반환값:**
- `AspectRatioCategory`: 화면비 카테고리

**예시:**
```dart
final category = ResponsiveLayoutProvider.getCategory(context);
```

##### `getConfigAndCategory(BuildContext context)`
반응형 설정과 화면비 카테고리를 모두 가져옵니다.

```dart
static (ResponsiveConfig config, AspectRatioCategory category) getConfigAndCategory(BuildContext context)
```

**매개변수:**
- `context`: BuildContext

**반환값:**
- `(ResponsiveConfig, AspectRatioCategory)`: 반응형 설정과 화면비 카테고리

**예시:**
```dart
final (config, category) = ResponsiveLayoutProvider.getConfigAndCategory(context);
```

## � 적응형 컴포넌트

### AdaptiveSafeAreaManager

화면비별 안전 영역을 관리하는 핵심 유틸리티 클래스입니다.

#### 정적 메서드

##### `getSafeMargin(AspectRatioCategory category, Size screenSize, {SafeAreaMode mode = SafeAreaMode.auto})`
화면비와 디바이스 타입에 맞는 안전 마진을 계산합니다.

```dart
static EdgeInsets getSafeMargin(
  AspectRatioCategory category, 
  Size screenSize, {
  SafeAreaMode mode = SafeAreaMode.auto,
})
```

**매개변수:**
- `category`: 화면비 카테고리
- `screenSize`: 현재 화면 크기
- `mode`: 안전 영역 모드 (tv, mobile, desktop, auto)

**반환값:**
- `EdgeInsets`: 계산된 안전 마진

**예시:**
```dart
final screenSize = MediaQuery.of(context).size;
final aspectRatio = AspectRatioCategory.fromSize(screenSize);
final safeMargin = AdaptiveSafeAreaManager.getSafeMargin(
  aspectRatio,
  screenSize,
  mode: SafeAreaMode.tv,
);

Widget build(BuildContext context) {
  return Container(
    margin: safeMargin,
    child: MyContent(),
  );
}
```

##### `getTVSafeArea(AspectRatioCategory category, Size screenSize)`
TV 전용 안전 영역을 계산합니다.

```dart
static EdgeInsets getTVSafeArea(AspectRatioCategory category, Size screenSize)
```

##### `getMobileSafeArea(AspectRatioCategory category, Size screenSize)`
모바일 전용 안전 영역을 계산합니다.

```dart
static EdgeInsets getMobileSafeArea(AspectRatioCategory category, Size screenSize)
```

##### `getDesktopSafeArea(AspectRatioCategory category, Size screenSize)`
데스크톱 전용 안전 영역을 계산합니다.

```dart
static EdgeInsets getDesktopSafeArea(AspectRatioCategory category, Size screenSize)
```

### AdaptiveGrid

화면비에 따라 자동으로 그리드 레이아웃을 조정하는 위젯입니다.

#### 생성자

```dart
const AdaptiveGrid({
  Key? key,
  required List<Widget> children,
  GridMode mode = GridMode.auto,
  AspectRatioCategory? category,
  int? customColumns,
  double? customSpacing,
  double? customRunSpacing,
  double? customAspectRatio,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  EdgeInsetsGeometry? padding,
  bool shrinkWrap = false,
  ScrollPhysics? physics,
})
```

**매개변수:**
- `children`: 그리드에 배치할 위젯 목록
- `mode`: 그리드 모드 (tv, mobile, desktop, auto)
- `category`: 화면비 카테고리 (null이면 자동 감지)
- `customColumns`: 사용자 정의 컬럼 수
- `customSpacing`: 사용자 정의 간격
- `customRunSpacing`: 사용자 정의 행 간격
- `customAspectRatio`: 사용자 정의 종횡비
- `crossAxisAlignment`: 교차축 정렬
- `mainAxisAlignment`: 주축 정렬
- `padding`: 패딩
- `shrinkWrap`: 내용에 맞게 크기 조정
- `physics`: 스크롤 물리

**예시:**
```dart
AdaptiveGrid(
  mode: GridMode.tv,
  children: List.generate(12, (index) => 
    Card(
      child: Center(
        child: Text('Item $index'),
      ),
    ),
  ),
)
```

### AspectRatioSimulator

개발 중 다양한 화면비를 시뮬레이션할 수 있는 고급 도구입니다.

#### 생성자

```dart
const AspectRatioSimulator({
  Key? key,
  required Widget child,
  AspectRatioCategory initialAspectRatio = AspectRatioCategory.standard,
  bool showControls = true,
  bool showDebugInfo = true,
  bool enableHotReload = true,
  bool enableKeyboardShortcuts = true,
  SimulatorTheme theme = SimulatorTheme.dark,
  List<AspectRatioCategory>? supportedRatios,
  void Function(AspectRatioCategory category)? onAspectRatioChanged,
  void Function(Size size)? onSizeChanged,
})
```

**매개변수:**
- `child`: 시뮬레이션할 위젯
- `initialAspectRatio`: 초기 화면비
- `showControls`: 컨트롤 UI 표시 여부
- `showDebugInfo`: 디버그 정보 표시 여부
- `enableHotReload`: 핫 리로드 지원
- `enableKeyboardShortcuts`: 키보드 단축키 지원
- `theme`: 시뮬레이터 테마
- `supportedRatios`: 지원하는 화면비 목록
- `onAspectRatioChanged`: 화면비 변경 콜백
- `onSizeChanged`: 크기 변경 콜백

**키보드 단축키:**
- `1-9`: 화면비 빠른 변경
- `Space`: 컨트롤 토글
- `D`: 디버그 정보 토글
- `F`: 전체화면 토글

**예시:**
```dart
AspectRatioSimulator(
  child: MyResponsiveApp(),
  showControls: true,
  showDebugInfo: true,
  theme: SimulatorTheme.dark,
  supportedRatios: [
    AspectRatioCategory.ultraWide,
    AspectRatioCategory.standard,
    AspectRatioCategory.tallPortrait,
  ],
  onAspectRatioChanged: (category) {
    print('Changed to: ${category.displayName}');
  },
)
```

## �🎨 반응형 위젯

### ResponsiveContainer

Design Spec 기반 반응형 컨테이너입니다.

#### 생성자

```dart
const ResponsiveContainer({
  Key? key,
  required Widget child,
  LayoutMode? layoutMode,
  LayoutWrap? layoutWrap,
  SizingMode? horizontalSizing,
  SizingMode? verticalSizing,
  SizingMode? counterAxisSizing,
  SizingMode? primaryAxisSizing,
  AlignmentMode? counterAxisAlignment,
  AlignmentMode? primaryAxisAlignment,
  double? itemSpacing,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Decoration? decoration,
  double? width,
  double? height,
  AlignmentGeometry? alignment,
  BoxConstraints? constraints,
  bool enableSafeArea = true,
  Clip clipBehavior = Clip.none,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  List<BoxShadow>? boxShadow,
  Border? border,
  Gradient? gradient,
  Matrix4? transform,
})
```

**주요 매개변수:**
- `child`: 내부에 배치할 위젯
- `layoutMode`: 레이아웃 모드
- `layoutWrap`: 레이아웃 래핑
- `horizontalSizing`: 수평 크기 조정 모드
- `verticalSizing`: 수직 크기 조정 모드
- `counterAxisSizing`: 교차축 크기 조정 모드
- `primaryAxisSizing`: 주축 크기 조정 모드
- `counterAxisAlignment`: 교차축 정렬
- `primaryAxisAlignment`: 주축 정렬
- `itemSpacing`: 아이템 간격
- `enableSafeArea`: 안전 영역 적용 여부

**예시:**
```dart
ResponsiveContainer(
  layoutMode: LayoutMode.VERTICAL,
  backgroundColor: Colors.blue.shade50,
  borderRadius: BorderRadius.circular(8),
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('Responsive Container'),
      SizedBox(height: 16),
      Text('This adapts to different aspect ratios'),
    ],
  ),
)
```

### ResponsiveLayoutBuilder

현재 반응형 설정을 기반으로 위젯을 빌드합니다.

#### 생성자

```dart
const ResponsiveLayoutBuilder({
  Key? key,
  required Widget Function(BuildContext context, ResponsiveConfig config, AspectRatioCategory category) builder,
})
```

**매개변수:**
- `builder`: 반응형 설정 기반 빌더

**예시:**
```dart
ResponsiveLayoutBuilder(
  builder: (context, config, category) {
    if (category.isLandscape) {
      return Row(
        children: [
          Expanded(child: LeftPanel()),
          Expanded(child: RightPanel()),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(child: TopPanel()),
          Expanded(child: BottomPanel()),
        ],
      );
    }
  },
)
```

### ResponsiveBreakpoint

특정 화면비 이상에서만 표시되는 위젯입니다.

#### 생성자

```dart
const ResponsiveBreakpoint({
  Key? key,
  required AspectRatioCategory breakpoint,
  required Widget child,
  Widget? fallback,
  bool isGreaterThan = true,
})
```

**매개변수:**
- `breakpoint`: 브레이크포인트 화면비
- `child`: 표시할 위젯
- `fallback`: 대체 위젯
- `isGreaterThan`: 브레이크포인트 이상에서 표시할지 여부

**예시:**
```dart
ResponsiveBreakpoint(
  breakpoint: AspectRatioCategory.widescreen,
  child: WideScreenLayout(),
  fallback: StandardLayout(),
)
```

### ResponsiveConfigOverride

기존 설정을 오버라이드하여 새로운 설정을 적용합니다.

#### 생성자

```dart
const ResponsiveConfigOverride({
  Key? key,
  required Widget child,
  int? gridColumns,
  double? maxContentWidth,
  double? sidePadding,
  double? contentSpacing,
  LayoutMode? layoutMode,
  LayoutWrap? layoutWrap,
  SizingMode? horizontalSizing,
  SizingMode? verticalSizing,
  SizingMode? counterAxisSizing,
  SizingMode? primaryAxisSizing,
  AlignmentMode? counterAxisAlignment,
  AlignmentMode? primaryAxisAlignment,
  double? itemSpacing,
})
```

**매개변수:**
- `child`: 하위 위젯
- `gridColumns`: 오버라이드할 그리드 컬럼 수
- `maxContentWidth`: 오버라이드할 최대 콘텐츠 너비
- `sidePadding`: 오버라이드할 측면 패딩
- `contentSpacing`: 오버라이드할 콘텐츠 간격
- 기타 설정들...

**예시:**
```dart
ResponsiveConfigOverride(
  gridColumns: 8,
  maxContentWidth: 1200,
  sidePadding: 60,
  child: ResponsiveContainer(
    layoutMode: LayoutMode.GRID,
    child: MyGridContent(),
  ),
)
```

## 🎮 반응형 UI 시뮬레이터

### ResponsiveUISimulator

개발 중에 다양한 화면비와 해상도를 시뮬레이션할 수 있는 도구입니다.

#### 생성자

```dart
const ResponsiveUISimulator({
  Key? key,
  required Widget child,
  AspectRatioCategory initialAspectRatio = AspectRatioCategory.standard,
  bool showControls = true,
  bool showInfo = true,
  bool enableHotReload = true,
  void Function(AspectRatioCategory category)? onAspectRatioChanged,
})
```

**매개변수:**
- `child`: 시뮬레이션할 위젯
- `initialAspectRatio`: 초기 화면비
- `showControls`: 컨트롤 표시 여부
- `showInfo`: 정보 표시 여부
- `enableHotReload`: 핫 리로드 활성화 여부
- `onAspectRatioChanged`: 화면비 변경 콜백

**예시:**
```dart
ResponsiveUISimulator(
  child: MyResponsiveWidget(),
  showControls: true,
  showInfo: true,
  onAspectRatioChanged: (category) {
    print('Aspect ratio changed to: ${category.displayName}');
  },
)
```

### AspectRatioSelector

다양한 화면비를 선택할 수 있는 UI 컴포넌트입니다.

#### 생성자

```dart
const AspectRatioSelector({
  Key? key,
  required AspectRatioCategory selectedAspectRatio,
  required ValueChanged<AspectRatioCategory> onAspectRatioChanged,
  bool compact = false,
  bool showLabels = true,
  bool showDescriptions = false,
})
```

**매개변수:**
- `selectedAspectRatio`: 현재 선택된 화면비
- `onAspectRatioChanged`: 화면비 변경 콜백
- `compact`: 컴팩트 모드
- `showLabels`: 라벨 표시 여부
- `showDescriptions`: 설명 표시 여부

**예시:**
```dart
AspectRatioSelector(
  selectedAspectRatio: AspectRatioCategory.standard,
  onAspectRatioChanged: (category) {
    setState(() {
      _selectedAspectRatio = category;
    });
  },
  showDescriptions: true,
)
```

## 🏷️ 타입 정의

### AspectRatioCategory

화면비 카테고리를 정의하는 열거형입니다.

```dart
enum AspectRatioCategory {
  ultraSuperWide,    // 32:9
  ultraWide,         // 24:9
  widescreen,        // 21:9
  wide,              // 16:10
  standard,          // 16:9
  traditional,       // 4:3
  square,            // 1:1
  widePortrait,      // 3:4
  tallPortrait,      // 9:16
  ultraTallPortrait, // 9:21
}
```

#### 속성

- `ratio`: 화면비 값 (width / height)
- `displayName`: 표시용 이름
- `description`: 설명
- `isPortrait`: 세로 모드인지 확인
- `isLandscape`: 가로 모드인지 확인
- `isUltraWide`: 울트라 와이드 모드인지 확인
- `isStandardWide`: 표준 와이드 모드인지 확인
- `isPortraitMode`: 세로 모드인지 확인

#### 정적 메서드

##### `fromSize(Size size)`
화면 크기로부터 화면비 카테고리를 결정합니다.

```dart
static AspectRatioCategory fromSize(Size size)
```

##### `fromString(String aspectRatio)`
화면비 문자열로부터 카테고리를 결정합니다.

```dart
static AspectRatioCategory fromString(String aspectRatio)
```

##### `isSupported(String aspectRatio)`
화면비가 Design Spec에서 지원되는지 확인합니다.

```dart
static bool isSupported(String aspectRatio)
```

### LayoutMode

레이아웃 모드를 정의하는 열거형입니다.

```dart
enum LayoutMode {
  vertical,    // VERTICAL - 수직 배치
  horizontal,  // HORIZONTAL - 수평 배치
  grid,        // GRID - 격자형 배치
  stack,       // STACK - 스택형 배치
  flex,        // FLEX - 유연한 배치
}
```

#### 정적 메서드

##### `fromString(String value)`
문자열로부터 레이아웃 모드를 결정합니다.

```dart
static LayoutMode fromString(String value)
```

### SizingMode

크기 조정 모드를 정의하는 열거형입니다.

```dart
enum SizingMode {
  fixed,       // FIXED - 고정 크기
  fill,        // FILL - 부모 영역 채우기
  fitContent,  // FIT_CONTENT - 콘텐츠에 맞춤
  auto,        // AUTO - 자동 크기 조정
}
```

#### 정적 메서드

##### `fromString(String value)`
문자열로부터 크기 조정 모드를 결정합니다.

```dart
static SizingMode fromString(String value)
```

### SafeAreaMode

안전 영역 적용 모드를 정의하는 열거형입니다.

```dart
enum SafeAreaMode {
  tv,        // TV용 안전 영역
  mobile,    // 모바일용 안전 영역  
  desktop,   // 데스크톱용 안전 영역
  auto,      // 자동 감지
}
```

#### 정적 메서드

##### `fromString(String value)`
문자열로부터 안전 영역 모드를 결정합니다.

```dart
static SafeAreaMode fromString(String value)
```

### GridMode

그리드 레이아웃 모드를 정의하는 열거형입니다.

```dart
enum GridMode {
  tv,        // TV 최적화 그리드
  mobile,    // 모바일 최적화 그리드
  desktop,   // 데스크톱 최적화 그리드
  auto,      // 자동 감지
}
```

#### 정적 메서드

##### `fromString(String value)`
문자열로부터 그리드 모드를 결정합니다.

```dart
static GridMode fromString(String value)
```

### SimulatorTheme

시뮬레이터 테마를 정의하는 열거형입니다.

```dart
enum SimulatorTheme {
  light,     // 라이트 테마
  dark,      // 다크 테마
  auto,      // 시스템 테마 따름
}
```

#### 정적 메서드

##### `fromString(String value)`
문자열로부터 시뮬레이터 테마를 결정합니다.

```dart
static SimulatorTheme fromString(String value)
```

### ResponsiveConfig

반응형 설정을 정의하는 클래스입니다.

#### 생성자

```dart
const ResponsiveConfig({
  required int gridColumns,
  required double maxContentWidth,
  required double sidePadding,
  required double contentSpacing,
  LayoutMode layoutMode = LayoutMode.vertical,
  LayoutWrap layoutWrap = LayoutWrap.noWrap,
  SizingMode horizontalSizing = SizingMode.auto,
  SizingMode verticalSizing = SizingMode.auto,
  SizingMode counterAxisSizing = SizingMode.auto,
  SizingMode primaryAxisSizing = SizingMode.auto,
  AlignmentMode counterAxisAlignment = AlignmentMode.center,
  AlignmentMode primaryAxisAlignment = AlignmentMode.start,
  double itemSpacing = 16.0,
})
```

#### 속성

- `gridColumns`: 그리드 컬럼 수
- `maxContentWidth`: 최대 콘텐츠 너비
- `sidePadding`: 측면 패딩
- `contentSpacing`: 콘텐츠 간격
- `layoutMode`: 레이아웃 모드
- `layoutWrap`: 레이아웃 래핑
- `horizontalSizing`: 수평 크기 조정 모드
- `verticalSizing`: 수직 크기 조정 모드
- `counterAxisSizing`: 교차축 크기 조정 모드
- `primaryAxisSizing`: 주축 크기 조정 모드
- `counterAxisAlignment`: 교차축 정렬
- `primaryAxisAlignment`: 주축 정렬
- `itemSpacing`: 아이템 간격

#### 정적 메서드

##### `forAspectRatio(AspectRatioCategory category)`
화면비에 해당하는 반응형 설정을 반환합니다.

```dart
static ResponsiveConfig forAspectRatio(AspectRatioCategory category)
```

##### `fromSize(Size size)`
화면 크기로부터 반응형 설정을 반환합니다.

```dart
static ResponsiveConfig fromSize(Size size)
```

#### 인스턴스 메서드

##### `getSafeArea(AspectRatioCategory category)`
안전 영역을 계산합니다.

```dart
EdgeInsets getSafeArea(AspectRatioCategory category)
```

##### `getResponsivePadding(AspectRatioCategory category)`
반응형 패딩을 계산합니다.

```dart
EdgeInsets getResponsivePadding(AspectRatioCategory category)
```

##### `getResponsiveMargin(AspectRatioCategory category)`
반응형 마진을 계산합니다.

```dart
EdgeInsets getResponsiveMargin(AspectRatioCategory category)
```

##### `getGridItemWidth(double containerWidth)`
그리드 아이템 너비를 계산합니다.

```dart
double getGridItemWidth(double containerWidth)
```

##### `getGridItemHeight(double itemWidth)`
그리드 아이템 높이를 계산합니다.

```dart
double getGridItemHeight(double itemWidth)
```

##### `copyWith(...)`
복사본을 생성합니다.

```dart
ResponsiveConfig copyWith({...})
```

## 🛠️ 유틸리티

### ResponsiveUtils

반응형 UI 개발을 위한 다양한 헬퍼 메서드를 제공합니다.

#### 정적 메서드

##### `detectAspectRatioCategory(Size screenSize)`
화면비 카테고리를 감지합니다.

```dart
static AspectRatioCategory detectAspectRatioCategory(Size screenSize)
```

##### `getResponsivePadding(BuildContext context, double baseSpacing)`
반응형 패딩을 계산합니다.

```dart
static EdgeInsets getResponsivePadding(BuildContext context, double baseSpacing)
```

##### `getResponsiveMargin(BuildContext context, double baseSpacing)`
반응형 마진을 계산합니다.

```dart
static EdgeInsets getResponsiveMargin(BuildContext context, double baseSpacing)
```

##### `getResponsiveFontSize(BuildContext context, double baseFontSize)`
반응형 폰트 크기를 계산합니다.

```dart
static double getResponsiveFontSize(BuildContext context, double baseFontSize)
```

##### `getResponsiveIconSize(BuildContext context, double baseIconSize)`
반응형 아이콘 크기를 계산합니다.

```dart
static double getResponsiveIconSize(BuildContext context, double baseIconSize)
```

##### `getResponsiveSpacing(BuildContext context, double baseSpacing)`
반응형 간격을 계산합니다.

```dart
static double getResponsiveSpacing(BuildContext context, double baseSpacing)
```

##### `getResponsiveBorderRadius(BuildContext context, double baseBorderRadius)`
반응형 보더 반지름을 계산합니다.

```dart
static double getResponsiveBorderRadius(BuildContext context, double baseBorderRadius)
```

##### `getResponsiveBoxShadow(BuildContext context, BoxShadow baseShadow)`
반응형 그림자를 계산합니다.

```dart
static List<BoxShadow> getResponsiveBoxShadow(BuildContext context, BoxShadow baseShadow)
```

##### `getResponsiveAnimationDuration(BuildContext context, Duration baseDuration)`
반응형 애니메이션 지속 시간을 계산합니다.

```dart
static Duration getResponsiveAnimationDuration(BuildContext context, Duration baseDuration)
```

##### `isBreakpoint(BuildContext context, AspectRatioCategory breakpoint, {bool isGreaterThan = true})`
반응형 브레이크포인트를 확인합니다.

```dart
static bool isBreakpoint(BuildContext context, AspectRatioCategory breakpoint, {bool isGreaterThan = true})
```

##### `buildResponsive(BuildContext context, Widget Function(BuildContext context, AspectRatioCategory category) builder)`
반응형 조건부 위젯을 빌드합니다.

```dart
static Widget buildResponsive(BuildContext context, Widget Function(BuildContext context, AspectRatioCategory category) builder)
```

##### `buildResponsiveWithBreakpoint(BuildContext context, {required AspectRatioCategory breakpoint, required Widget Function(BuildContext context) builder, Widget? fallback})`
반응형 조건부 위젯을 빌드합니다 (브레이크포인트 기반).

```dart
static Widget buildResponsiveWithBreakpoint(BuildContext context, {required AspectRatioCategory breakpoint, required Widget Function(BuildContext context) builder, Widget? fallback})
```

### LayoutCalculator

Design Spec 기반 레이아웃 계산을 위한 유틸리티 클래스입니다.

#### 정적 메서드

##### `calculateGridLayout(...)`
그리드 레이아웃을 계산합니다.

```dart
static GridLayoutResult calculateGridLayout({
  required Size containerSize,
  required int itemCount,
  required int columns,
  required double spacing,
  required double runSpacing,
})
```

##### `calculateFlexLayout(...)`
플렉스 레이아웃을 계산합니다.

```dart
static FlexLayoutResult calculateFlexLayout({
  required Size containerSize,
  required List<FlexItem> items,
  required Axis direction,
  required MainAxisAlignment mainAxisAlignment,
  required CrossAxisAlignment crossAxisAlignment,
  required double spacing,
})
```

##### `calculateStackLayout(...)`
스택 레이아웃을 계산합니다.

```dart
static StackLayoutResult calculateStackLayout({
  required Size containerSize,
  required List<StackItem> items,
  required Alignment alignment,
})
```

##### `calculateResponsiveGridLayout(...)`
반응형 그리드 레이아웃을 계산합니다.

```dart
static ResponsiveGridLayoutResult calculateResponsiveGridLayout({
  required Size screenSize,
  required int itemCount,
  required AspectRatioCategory aspectRatio,
  int? customColumns,
  double? customSpacing,
})
```

##### `calculateResponsiveFlexLayout(...)`
반응형 플렉스 레이아웃을 계산합니다.

```dart
static ResponsiveFlexLayoutResult calculateResponsiveFlexLayout({
  required Size screenSize,
  required List<FlexItem> items,
  required AspectRatioCategory aspectRatio,
  Axis? customDirection,
  double? customSpacing,
})
```

##### `calculateResponsiveStackLayout(...)`
반응형 스택 레이아웃을 계산합니다.

```dart
static ResponsiveStackLayoutResult calculateResponsiveStackLayout({
  required Size screenSize,
  required List<StackItem> items,
  required AspectRatioCategory aspectRatio,
  Alignment? customAlignment,
})
```

### AdaptiveLayoutUtils

적응형 레이아웃을 위한 고급 유틸리티 클래스입니다.

#### 정적 메서드

##### `calculateOptimalColumns(Size screenSize, {GridMode mode = GridMode.auto})`
화면 크기에 최적화된 그리드 컬럼 수를 계산합니다.

```dart
static int calculateOptimalColumns(Size screenSize, {GridMode mode = GridMode.auto})
```

**매개변수:**
- `screenSize`: 화면 크기
- `mode`: 그리드 모드

**반환값:**
- `int`: 최적 컬럼 수

**예시:**
```dart
final screenSize = MediaQuery.of(context).size;
final columns = AdaptiveLayoutUtils.calculateOptimalColumns(
  screenSize,
  mode: GridMode.tv,
);
```

##### `calculateOptimalSpacing(Size screenSize, AspectRatioCategory category)`
화면비에 최적화된 간격을 계산합니다.

```dart
static double calculateOptimalSpacing(Size screenSize, AspectRatioCategory category)
```

##### `getRecommendedAspectRatio(GridMode mode)`
그리드 모드에 따른 권장 종횡비를 반환합니다.

```dart
static double getRecommendedAspectRatio(GridMode mode)
```

##### `calculateSafeContentArea(Size screenSize, AspectRatioCategory category, SafeAreaMode mode)`
안전한 콘텐츠 영역을 계산합니다.

```dart
static Rect calculateSafeContentArea(Size screenSize, AspectRatioCategory category, SafeAreaMode mode)
```

##### `isOptimalForTV(AspectRatioCategory category)`
TV에 최적화된 화면비인지 확인합니다.

```dart
static bool isOptimalForTV(AspectRatioCategory category)
```

##### `isOptimalForMobile(AspectRatioCategory category)`
모바일에 최적화된 화면비인지 확인합니다.

```dart
static bool isOptimalForMobile(AspectRatioCategory category)
```

##### `getPerformanceMetrics(Size screenSize, int widgetCount)`
성능 메트릭을 계산합니다.

```dart
static AdaptivePerformanceMetrics getPerformanceMetrics(Size screenSize, int widgetCount)
```

### SimulatorUtils

시뮬레이터 관련 유틸리티 클래스입니다.

#### 정적 메서드

##### `getAllSupportedRatios()`
지원하는 모든 화면비를 반환합니다.

```dart
static List<AspectRatioCategory> getAllSupportedRatios()
```

##### `getPopularRatios()`
인기 있는 화면비들을 반환합니다.

```dart
static List<AspectRatioCategory> getPopularRatios()
```

##### `getTVRatios()`
TV용 화면비들을 반환합니다.

```dart
static List<AspectRatioCategory> getTVRatios()
```

##### `getMobileRatios()`
모바일용 화면비들을 반환합니다.

```dart
static List<AspectRatioCategory> getMobileRatios()
```

##### `generateTestSizes(AspectRatioCategory category)`
테스트용 화면 크기들을 생성합니다.

```dart
static List<Size> generateTestSizes(AspectRatioCategory category)
```

##### `calculateSimulatorSize(Size originalSize, Size containerSize)`
시뮬레이터에 맞는 크기를 계산합니다.

```dart
static Size calculateSimulatorSize(Size originalSize, Size containerSize)
```

### ValidationUtils

레이아웃 검증을 위한 유틸리티 클래스입니다.

#### 정적 메서드

##### `validateResponsiveLayout(Widget widget, List<AspectRatioCategory> testRatios)`
반응형 레이아웃을 검증합니다.

```dart
static Future<ValidationResult> validateResponsiveLayout(Widget widget, List<AspectRatioCategory> testRatios)
```

##### `checkAccessibility(Widget widget, AspectRatioCategory category)`
접근성을 확인합니다.

```dart
static AccessibilityReport checkAccessibility(Widget widget, AspectRatioCategory category)
```

##### `analyzePerformance(Widget widget, Size screenSize)`
성능을 분석합니다.

```dart
static PerformanceReport analyzePerformance(Widget widget, Size screenSize)
```

##### `validateSafeArea(Widget widget, AspectRatioCategory category)`
안전 영역 준수를 확인합니다.

```dart
static SafeAreaReport validateSafeArea(Widget widget, AspectRatioCategory category)
```

## 📊 성능 및 분석

### AdaptivePerformanceMetrics

적응형 레이아웃의 성능 메트릭을 담는 클래스입니다.

#### 속성

```dart
class AdaptivePerformanceMetrics {
  final int estimatedRenderObjects;
  final double estimatedMemoryUsage;
  final Duration estimatedBuildTime;
  final PerformanceLevel performanceLevel;
  final List<String> recommendations;
}
```

### ValidationResult

레이아웃 검증 결과를 담는 클래스입니다.

#### 속성

```dart
class ValidationResult {
  final bool isValid;
  final List<ValidationIssue> issues;
  final List<String> recommendations;
  final double score;
}
```

### AccessibilityReport

접근성 보고서를 담는 클래스입니다.

#### 속성

```dart
class AccessibilityReport {
  final bool meetsWCAGAA;
  final bool meetsWCAGAAA;
  final List<AccessibilityIssue> issues;
  final List<String> recommendations;
}
```

## � v2.0 새로운 기능

### 주요 추가 기능

#### 1. 적응형 안전 영역 관리
- **AdaptiveSafeAreaManager**: TV, 모바일, 데스크톱에 최적화된 안전 영역 자동 계산
- **SafeAreaMode**: 플랫폼별 안전 영역 적용 모드

#### 2. 고급 그리드 시스템
- **AdaptiveGrid**: 화면비별 자동 그리드 레이아웃 조정
- **GridMode**: TV, 모바일, 데스크톱 최적화 그리드 모드

#### 3. 실시간 화면비 시뮬레이터
- **AspectRatioSimulator**: 10가지 화면비 실시간 시뮬레이션
- **키보드 단축키**: 빠른 화면비 전환 및 디버깅
- **SimulatorTheme**: 라이트/다크 테마 지원

#### 4. 성능 최적화
- **DynamicLayoutAdapter**: 화면 변화에 최적화된 실시간 적응
- **AdaptiveLayoutUtils**: 성능 메트릭 및 최적화 도구
- **ValidationUtils**: 레이아웃 검증 및 접근성 검사

### 마이그레이션 가이드 (v1.x → v2.0)

#### 1. 기본 반응형 컨테이너

**v1.x:**
```dart
ResponsiveContainer(
  child: MyWidget(),
)
```

**v2.0:**
```dart
DynamicLayoutAdapter(
  builder: (context, category) {
    final safeMargin = AdaptiveSafeAreaManager.getSafeMargin(
      category,
      MediaQuery.of(context).size,
    );
    
    return Container(
      margin: safeMargin,
      child: ResponsiveContainer(
        child: MyWidget(),
      ),
    );
  },
)
```

#### 2. 그리드 레이아웃

**v1.x:**
```dart
ResponsiveContainer(
  layoutMode: LayoutMode.grid,
  child: GridView.builder(...),
)
```

**v2.0:**
```dart
AdaptiveGrid(
  mode: GridMode.auto,
  children: myWidgets,
)
```

#### 3. 화면비 감지

**v1.x:**
```dart
final category = ResponsiveLayoutManager.getAspectRatioCategory(
  MediaQuery.of(context).size
);
```

**v2.0:**
```dart
DynamicLayoutAdapter(
  builder: (context, category) {
    // category가 자동으로 제공됨
    return MyWidget();
  },
)
```

#### 4. 안전 영역 적용

**v1.x:**
```dart
final safeArea = ResponsiveLayoutManager.getSafeArea(context);
```

**v2.0:**
```dart
final safeMargin = AdaptiveSafeAreaManager.getSafeMargin(
  category,
  screenSize,
  mode: SafeAreaMode.auto, // TV/모바일/데스크톱 자동 감지
);
```

### 호환성 정보

- **최소 Flutter 버전**: 3.9.0
- **최소 Dart 버전**: 3.0.0
- **v1.x API**: 완전 호환 (deprecated 경고 포함)
- **새로운 API**: v2.0 전용 기능

### 업그레이드 체크리스트

- [ ] Flutter 3.9.0+ 업그레이드
- [ ] `AdaptiveSafeAreaManager` 도입
- [ ] `DynamicLayoutAdapter`로 마이그레이션
- [ ] `AdaptiveGrid` 활용
- [ ] `AspectRatioSimulator`로 테스트
- [ ] 성능 최적화 적용
- [ ] 접근성 검증 실행

## �📚 추가 자료

- [개발자 가이드](DEVELOPER_GUIDE.md)
- [아키텍처 가이드](ARCHITECTURE.md)
- [변경 로그](CHANGELOG.md)

---

**LG Responsive UI Framework v2.0** API 참조 문서입니다. 더 자세한 정보는 [개발자 가이드](DEVELOPER_GUIDE.md)를 참조하세요.
