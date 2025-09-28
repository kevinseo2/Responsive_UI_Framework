# LG Responsive UI Framework v2.1

> Flutter UI Layout Coding Specification 기반 반응형 UI 프레임워크

LG Responsive UI Framework v2.1은 **Flutter UI Layout Coding Specification**에 완전히 최적화된 반응형 UI 프레임워크입니다. Figma 디자인을 Flutter 코드로 자동 변환하는데 필요한 모든 컨테이너와 플레이스홀더 시스템을 제공합니다.

## 🚀 새로운 주요 기능 (v2.1)

### 🎯 **Figma 레이아웃 모드 완전 지원**
- **BoxContainer** - Figma RECTANGLE 레이아웃 모드
- **HorizontalContainer** - Figma HORIZONTAL 레이아웃 모드  
- **VerticalContainer** - Figma VERTICAL 레이아웃 모드
- **GridContainer** - Figma GRID 레이아웃 모드

### 🔧 **플레이스홀더 위젯 시스템**
- **PlaceholderBoxItem** - 박스 형태 임시 위젯
- **PlaceholderListItem** - 리스트 아이템 임시 위젯
- **PlaceholderGridItem** - 그리드 아이템 임시 위젯
- **자동 코드 생성 지원** - 실제 위젯으로 교체 가능한 구조

### 📐 **5가지 화면비 최적화**
- **16:9** (Ultra Wide) - 와이드스크린 TV, 모니터
- **4:3** (Wide) - 일반 TV, 태블릿 가로
- **1:1** (Square) - 정사각형 디스플레이
- **3:4** (Tall) - 태블릿 세로
- **9:16** (Ultra Tall) - 모바일 세로

### 🎨 **반응형 자동 조정**
- **컬럼 수 자동 계산** - 화면 크기에 따른 최적 그리드
- **스페이싱 자동 조정** - 화면비에 맞춘 여백 계산
- **스크롤 자동 활성화** - 콘텐츠 양에 따른 스크롤 처리

## 📦 설치

### pubspec.yaml에 추가

```yaml
dependencies:
  lg_responsive_ui_framework: ^2.1.0
```

### 패키지 가져오기

```dart
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';
```

## 🎨 코딩 스펙 컨테이너 사용법

### 1. BoxContainer (RECTANGLE 레이아웃)

```dart
// 고정 크기 박스
BoxContainer(
  containerId: 'header_box',
  containerName: 'Header Section',
  width: double.infinity,
  height: 100,
  backgroundColor: Colors.blue.shade100,
  child: HeaderWidget(),
)

// 반응형 박스 (화면 크기에 자동 조정)
ResponsiveBoxContainer(
  containerId: 'content_box',
  containerName: 'Content Section',
  backgroundColor: Colors.green.shade50,
  placeholderConfig: PlaceholderConfig(
    backgroundColor: Colors.green.shade300,
    customText: 'Content Area',
  ),
)
```

### 2. HorizontalContainer (HORIZONTAL 레이아웃)

```dart
// 네비게이션 메뉴
HorizontalContainer(
  containerId: 'navigation',
  containerName: 'Main Navigation',
  itemSpacing: 16.0,
  children: [
    MenuItem('Home'),
    MenuItem('About'),
    MenuItem('Contact'),
  ],
)

// 플레이스홀더로 임시 구성
HorizontalContainer(
  containerId: 'nav_placeholder',
  containerName: 'Navigation Placeholder',
  placeholderItemCount: 5,
  placeholderConfig: PlaceholderConfig(
    backgroundColor: Colors.blue.shade300,
    customText: 'Nav',
  ),
)
```

### 3. VerticalContainer (VERTICAL 레이아웃)

```dart
// 세로 리스트
VerticalContainer(
  containerId: 'content_list',
  containerName: 'Content List',
  itemSpacing: 12.0,
  children: [
    ListItem('Item 1'),
    ListItem('Item 2'),
    ListItem('Item 3'),
  ],
)

// 스크롤 가능한 긴 리스트
VerticalContainer(
  containerId: 'long_list',
  containerName: 'Long Content List',
  scrollable: true,
  maxHeight: 300,
  placeholderItemCount: 10,
  placeholderConfig: PlaceholderConfig(
    backgroundColor: Colors.teal.shade300,
    customText: 'List Item',
  ),
)
```

### 4. GridContainer (GRID 레이아웃)

```dart
// 고정 그리드
GridContainer(
  containerId: 'photo_grid',
  containerName: 'Photo Gallery',
  crossAxisCount: 3,
  childAspectRatio: 1.0,
  itemSpacing: 8.0,
  children: [
    PhotoItem('photo1.jpg'),
    PhotoItem('photo2.jpg'),
    PhotoItem('photo3.jpg'),
  ],
)

// 반응형 그리드 (화면 크기에 따라 컬럼 수 자동 조정)
ResponsiveGridContainer(
  containerId: 'adaptive_grid',
  containerName: 'Adaptive Content Grid',
  minItemWidth: 150.0,
  placeholderItemCount: 12,
  placeholderConfig: PlaceholderConfig(
    backgroundColor: Colors.amber.shade300,
    customText: 'Card',
  ),
)
```

## 🏗️ 복합 레이아웃 구성

```dart
// 전체 앱 레이아웃 예시
BoxContainer(
  containerId: 'app_layout',
  containerName: 'Main App Layout',
  child: VerticalContainer(
    containerId: 'app_structure',
    containerName: 'App Structure',
    children: [
      // 헤더
      BoxContainer(
        containerId: 'app_header',
        containerName: 'App Header',
        height: 60,
        child: AppHeader(),
      ),
      
      // 네비게이션
      HorizontalContainer(
        containerId: 'main_nav',
        containerName: 'Main Navigation',
        placeholderItemCount: 4,
      ),
      
      // 콘텐츠 영역
      Expanded(
        child: HorizontalContainer(
          containerId: 'content_area',
          containerName: 'Content Area',
          children: [
            // 사이드바
            Container(
              width: 200,
              child: VerticalContainer(
                containerId: 'sidebar',
                containerName: 'Sidebar Menu',
                placeholderItemCount: 6,
              ),
            ),
            
            // 메인 콘텐츠
            Expanded(
              child: ResponsiveGridContainer(
                containerId: 'main_content',
                containerName: 'Main Content Grid',
                minItemWidth: 250,
                placeholderItemCount: 8,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

## 🎛️ 플레이스홀더 설정

```dart
PlaceholderConfig(
  backgroundColor: Colors.blue.shade300,    // 배경색
  borderColor: Colors.blue.shade600,        // 테두리 색
  textColor: Colors.white,                  // 텍스트 색
  icon: Icons.placeholder,                  // 아이콘
  customText: 'Custom Label',               // 커스텀 텍스트
  opacity: 0.8,                            // 투명도
)
```

## 📱 반응형 동작

### 자동 화면비 감지
```dart
ResponsiveLayoutProvider(
  child: DynamicLayoutAdapter(
    builder: (context, aspectRatio) {
      // aspectRatio에 따라 다른 레이아웃 반환
      switch(aspectRatio) {
        case AspectRatioCategory.ultraWide:  // 16:9
          return UltraWideLayout();
        case AspectRatioCategory.wide:       // 4:3
          return WideLayout();
        case AspectRatioCategory.square:     // 1:1
          return SquareLayout();
        case AspectRatioCategory.tall:       // 3:4
          return TallLayout();
        case AspectRatioCategory.ultraTall:  // 9:16
          return UltraTallLayout();
      }
    },
  ),
)
```

### 반응형 그리드 자동 조정
- **Ultra Wide (16:9)**: 최대 6컬럼
- **Wide (4:3)**: 최대 4컬럼  
- **Square (1:1)**: 최대 3컬럼
- **Tall (3:4)**: 최대 2컬럼
- **Ultra Tall (9:16)**: 1-2컬럼

## 🛠️ 개발자 도구

### 반응형 UI 시뮬레이터 (개발 중)
```dart
ResponsiveUISimulator(
  child: MyApp(),
  showControls: true,
  showInfo: true,
)
```

### 디버그 정보
각 컨테이너는 자동으로 다음 정보를 제공합니다:
- **containerId**: 고유 식별자
- **containerName**: 사람이 읽을 수 있는 이름
- **레이아웃 모드**: Box/Horizontal/Vertical/Grid
- **반응형 상태**: 현재 화면비 및 설정

## 🎯 코딩 스펙 호환성

이 프레임워크는 **Flutter UI Layout Coding Specification**과 완전히 호환됩니다:

### 지원하는 레이아웃 모드
- ✅ **RECTANGLE** → `BoxContainer`
- ✅ **HORIZONTAL** → `HorizontalContainer`  
- ✅ **VERTICAL** → `VerticalContainer`
- ✅ **GRID** → `GridContainer`

### 지원하는 화면비
- ✅ **16:9** (Ultra Wide)
- ✅ **4:3** (Wide)  
- ✅ **1:1** (Square)
- ✅ **3:4** (Tall)
- ✅ **9:16** (Ultra Tall)

### 자동 코드 생성 지원
- ✅ **플레이스홀더 시스템**: 임시 위젯을 실제 위젯으로 쉽게 교체
- ✅ **ID 기반 관리**: containerId로 위젯 추적 및 관리
- ✅ **JSON 스펙 호환**: Figma 플러그인 데이터와 직접 호환

## 📊 예제 파일

### 기본 예제
- `example/main.dart` - 기본 반응형 시스템 예제
- `example/coding_spec_demo.dart` - 새로운 컨테이너 시스템 데모

### 실행 방법
```bash
cd example
flutter run -d chrome  # 웹에서 실행 (반응형 테스트에 최적)
flutter run            # 기본 디바이스에서 실행
```

## 🔄 마이그레이션 가이드

### v2.0에서 v2.1로 업그레이드

기존 v2.0 코드는 그대로 동작하며, 새로운 컨테이너 시스템을 추가로 사용할 수 있습니다:

```dart
// 기존 방식 (계속 지원)
ResponsiveContainer(
  layoutMode: LayoutMode.vertical,
  child: MyContent(),
)

// 새로운 방식 (권장)
VerticalContainer(
  containerId: 'my_content',
  containerName: 'My Content Container', 
  child: MyContent(),
)
```

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

MIT License에 따라 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 🔗 관련 프로젝트

- **Flutter UI Layout Coding Specification** - Figma 디자인을 Flutter 코드로 변환하기 위한 완전한 사양
- **Figma to Flutter Plugin** - Figma 디자인을 이 프레임워크 코드로 자동 변환하는 플러그인

## 📞 지원 및 문의

- **이슈 리포트**: [GitHub Issues](https://github.com/lg/lg-responsive-ui-framework/issues)
- **기능 요청**: [GitHub Discussions](https://github.com/lg/lg-responsive-ui-framework/discussions)
- **문서**: [API Reference](./API_REFERENCE.md)

---

**LG Responsive UI Framework v2.1** - Figma에서 Flutter까지, 완벽한 반응형 UI 여정을 시작하세요! 🚀