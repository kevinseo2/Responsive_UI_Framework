# LG Responsive UI Framework v2.0

> Design Spec 기반 반응형 UI 프레임워크

LG Responsive UI Framework v2.0은 새로운 Design Specification에 최적화된 반응형 UI 프레임워크입니다. 화면비 기반 자동 레이아웃 조정과 반응형 UI 시뮬레이터를 제공하여 다양한 디스플레이 환경에서 일관된 사용자 경험을 보장합니다.

## 🚀 주요 기능

### ✨ Design Spec 기반 반응형 시스템
- **10가지 화면비 자동 감지**: 32:9부터 9:21까지 다양한 화면비 지원
- **자동 레이아웃 조정**: 화면비에 따른 그리드 컬럼 수, 패딩, 간격 자동 조정
- **플렉스박스 기반 레이아웃**: VERTICAL, HORIZONTAL, GRID, STACK, FLEX 레이아웃 모드
- **반응형 크기 조정**: FIXED, FILL, FIT_CONTENT, AUTO 크기 조정 모드

### 🎯 반응형 UI 시뮬레이터
- **실시간 시뮬레이션**: 개발 중 다양한 화면비와 해상도 시뮬레이션
- **화면비 선택기**: 직관적인 화면비 선택 인터페이스
- **설정 정보 표시**: 현재 반응형 설정 정보 실시간 표시
- **핫 리로드 지원**: 개발 중 실시간 변경사항 반영

### 🏗️ 모듈화된 아키텍처
- **핵심 시스템**: ResponsiveLayoutManager, DynamicLayoutAdapter, ResponsiveLayoutProvider
- **반응형 위젯**: ResponsiveContainer, AdaptiveGrid, ResponsiveItem 등
- **화면비 시뮬레이터**: AspectRatioSimulator로 10가지 화면비 실시간 테스트
- **적응형 안전 영역**: AdaptiveSafeAreaManager로 TV/모바일/데스크톱 최적화
- **타입 시스템**: AspectRatioCategory, LayoutMode, ResponsiveConfig

## 📦 설치

### pubspec.yaml에 추가

```yaml
dependencies:
  lg_responsive_ui_framework: ^2.0.0
```

### 패키지 가져오기

```dart
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';
```

## 🎨 사용 예시

### 기본 사용법

```dart
import 'package:flutter/material.dart';
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveLayoutProvider(
        child: DynamicLayoutAdapter(
          builder: (context, aspectRatio) {
            return Scaffold(
              body: ResponsiveContainer(
                layoutMode: LayoutMode.VERTICAL,
                child: Column(
                  children: [
                    HeaderContainer(
                      title: 'My App',
                      child: NavigationBar(),
                    ),
                    Expanded(
                      child: MainContentContainer(
                        child: GridLayout(
                          items: [
                            ResponsiveItem(child: ContentCard1()),
                            ResponsiveItem(child: ContentCard2()),
                          ],
                        ),
                      ),
                    ),
                    FooterContainer(
                      child: FooterContent(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### 반응형 UI 시뮬레이터 사용

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AspectRatioSimulator(
        child: MyResponsiveWidget(),
        showControls: true,
        showFullscreen: true,
      ),
    );
  }
}
```

### 적응형 안전 영역 관리

```dart
class MyResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final aspectRatio = AspectRatioCategory.fromSize(screenSize);
    final safeMargin = AdaptiveSafeAreaManager.getSafeMargin(
      aspectRatio,
      screenSize,
      mode: SafeAreaMode.tv, // TV, mobile, desktop, auto
    );

    return Container(
      margin: safeMargin,
      child: ResponsiveContainer(
        child: MyContent(),
      ),
    );
  }
}
```

### 적응형 그리드 레이아웃

```dart
class MyGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveGrid(
      mode: GridMode.tv, // tv, mobile, desktop, auto
      children: List.generate(12, (index) {
        return Card(
          child: Center(
            child: Text('Item $index'),
          ),
        );
      }),
    );
  }
}
```

### 화면비별 조건부 렌더링

```dart
class MyResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicLayoutAdapter(
      builder: (context, category) {
        final screenSize = MediaQuery.of(context).size;
        final safeMargin = AdaptiveSafeAreaManager.getSafeMargin(
          category,
          screenSize,
          mode: SafeAreaMode.auto,
        );

        return Container(
          margin: safeMargin,
          child: category.isLandscape
              ? Row(
                  children: [
                    Expanded(child: LeftPanel()),
                    Expanded(child: RightPanel()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: TopPanel()),
                    Expanded(child: BottomPanel()),
                  ],
                ),
        );
      },
    );
  }
}
```

### 반응형 그리드 레이아웃

```dart
class MyGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      layoutMode: LayoutMode.GRID,
      child: Wrap(
        children: List.generate(10, (index) {
          return ResponsiveItem(
            child: Card(
              child: Text('Item $index'),
            ),
          );
        }),
      ),
    );
  }
}
```

## 🎯 지원하는 화면비

| 화면비 | 카테고리 | 설명 | 주요 용도 |
|--------|----------|------|-----------|
| 32:9 | Ultra Super Wide | 울트라 슈퍼 와이드 | 자동차 와이드 디스플레이, 듀얼 모니터 |
| 24:9 | Ultra Wide | 울트라 와이드 | 프리미엄 대형 TV, 게이밍 모니터 |
| 21:9 | Widescreen | 시네마 와이드 | 영화 감상용 TV, 시네마 디스플레이 |
| 16:10 | Wide | 와이드 | 자동차 표준 디스플레이, 업무용 모니터 |
| 16:9 | Standard | 표준 와이드 | 일반 TV, 모니터 |
| 4:3 | Traditional | 표준 | 레거시 TV, 태블릿 |
| 1:1 | Square | 정사각형 | 특수용도 디스플레이 |
| 3:4 | Wide Portrait | 와이드 세로 | 회전 가능한 디스플레이 |
| 9:16 | Tall Portrait | 톨 세로 | 세로형 디지털 사이니지 |
| 9:21 | Ultra Tall Portrait | 울트라 톨 세로 | 세로형 울트라 와이드 디스플레이 |

## 🏗️ 아키텍처

### 핵심 컴포넌트

```
lib/
├── src/
│   ├── core/                    # 핵심 시스템
│   │   ├── responsive_layout_manager.dart
│   │   ├── dynamic_layout_adapter.dart
│   │   └── responsive_layout_provider.dart
│   ├── widgets/                 # 반응형 위젯
│   │   ├── responsive_container.dart
│   │   ├── responsive_item.dart
│   │   ├── responsive_text.dart
│   │   └── responsive_button.dart
│   ├── simulator/               # 반응형 UI 시뮬레이터
│   │   ├── responsive_ui_simulator.dart
│   │   └── aspect_ratio_selector.dart
│   ├── types/                   # 타입 정의
│   │   ├── aspect_ratio_category.dart
│   │   ├── layout_mode.dart
│   │   ├── responsive_config.dart
│   │   └── design_spec_types.dart
│   └── utils/                   # 유틸리티
│       ├── responsive_utils.dart
│       └── layout_calculator.dart
└── lg_responsive_ui_framework.dart
```

### Design Spec 지원

- **General Responsive UI Layout Specification v3.1.0**
- **Responsive Bluetooth Speaker Layout Specification v3.0.0**

## 🔧 API 참조

### ResponsiveLayoutManager

화면비별 반응형 설정을 관리하는 핵심 클래스입니다.

```dart
// 현재 화면비 카테고리 가져오기
AspectRatioCategory category = ResponsiveLayoutManager.getAspectRatioCategory(screenSize);

// 반응형 설정 가져오기
ResponsiveConfig config = ResponsiveLayoutManager.getConfig(context);

// 안전 영역 계산
EdgeInsets safeArea = ResponsiveLayoutManager.getSafeArea(context);
```

### DynamicLayoutAdapter

화면 크기 변화에 실시간으로 대응하는 위젯입니다.

```dart
DynamicLayoutAdapter(
  builder: (context, aspectRatio) {
    return MyWidget();
  },
  animationDuration: Duration(milliseconds: 300),
  enableAnimation: true,
)
```

### ResponsiveContainer

Design Spec 기반 반응형 컨테이너입니다.

```dart
ResponsiveContainer(
  layoutMode: LayoutMode.VERTICAL,
  layoutWrap: LayoutWrap.WRAP,
  horizontalSizing: SizingMode.FILL,
  verticalSizing: SizingMode.AUTO,
  child: MyContent(),
)
```

## 🎮 반응형 UI 시뮬레이터

### 기본 시뮬레이터

```dart
ResponsiveUISimulator(
  child: MyWidget(),
  showControls: true,
  showInfo: true,
)
```

### 독립 시뮬레이터 앱

```dart
ResponsiveUISimulatorApp(
  child: MyWidget(),
  title: 'My Responsive App',
)
```

### 화면비 선택기

```dart
AspectRatioSelector(
  selectedAspectRatio: AspectRatioCategory.standard,
  onAspectRatioChanged: (category) {
    // 화면비 변경 처리
  },
)
```

## 🚀 성능 최적화

### 렌더링 최적화
- **자동 크기 계산**: 화면비별 최적화된 크기 계산
- **조건부 렌더링**: 화면비별 필요한 위젯만 렌더링
- **애니메이션 최적화**: 화면비별 적절한 애니메이션 지속 시간

### 메모리 최적화
- **설정 캐싱**: 반응형 설정 자동 캐싱
- **위젯 재사용**: 공통 위젯 재사용으로 메모리 절약
- **지연 로딩**: 필요시에만 위젯 로딩

## 🔍 디버깅 및 개발

### 개발 모드 기능
- **시뮬레이터**: 다양한 화면비 실시간 시뮬레이션
- **설정 정보**: 현재 반응형 설정 정보 표시
- **핫 리로드**: 개발 중 실시간 변경사항 반영

### 디버깅 도구
- **화면비 감지**: 현재 화면비 카테고리 표시
- **설정 검증**: 반응형 설정 유효성 검사
- **성능 모니터링**: 렌더링 성능 모니터링

## 📚 추가 자료

- [API 참조 문서](API_REFERENCE.md)
- [아키텍처 가이드](ARCHITECTURE.md)
- [개발자 가이드](DEVELOPER_GUIDE.md)
- [변경 로그](CHANGELOG.md)

## 🤝 기여하기

1. 이 저장소를 포크합니다
2. 기능 브랜치를 생성합니다 (`git checkout -b feature/amazing-feature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add amazing feature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/amazing-feature`)
5. Pull Request를 생성합니다

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 📞 지원

- **이슈 리포트**: [GitHub Issues](https://github.com/lg-electronics/lg_responsive_ui_framework/issues)
- **문서**: [GitHub Wiki](https://github.com/lg-electronics/lg_responsive_ui_framework/wiki)
- **커뮤니티**: [GitHub Discussions](https://github.com/lg-electronics/lg_responsive_ui_framework/discussions)

---

**LG Responsive UI Framework v2.0** - Design Spec 기반 반응형 UI 프레임워크로 더 나은 사용자 경험을 만들어보세요! 🚀
