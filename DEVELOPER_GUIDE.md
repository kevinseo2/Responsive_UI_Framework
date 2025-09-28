# LG Responsive UI Framework v2.0 - 개발자 가이드

> Design Spec 기반 반응형 UI 프레임워크 개발 가이드

이 가이드는 LG Responsive UI Framework v2.0을 사용하여 반응형 UI를 개발하는 방법을 설명합니다.

## 📋 목차

1. [시작하기](#시작하기)
2. [핵심 개념](#핵심-개념)
3. [기본 사용법](#기본-사용법)
4. [적응형 컴포넌트](#적응형-컴포넌트)
5. [고급 사용법](#고급-사용법)
6. [반응형 UI 시뮬레이터](#반응형-ui-시뮬레이터)
7. [성능 최적화](#성능-최적화)
8. [디버깅 및 문제 해결](#디버깅-및-문제-해결)
9. [모범 사례](#모범-사례)

## 🚀 시작하기

### 프로젝트 설정

1. **pubspec.yaml에 의존성 추가**

```yaml
dependencies:
  flutter:
    sdk: flutter
  lg_responsive_ui_framework: ^2.0.0
```

2. **패키지 가져오기**

```dart
import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';
```

3. **기본 앱 구조 설정**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive UI Demo',
      home: ResponsiveLayoutProvider(
        child: MyHomePage(),
      ),
    );
  }
}
```

## 🎯 핵심 개념

### 1. 화면비 카테고리 (AspectRatioCategory)

프레임워크는 10가지 화면비를 지원합니다:

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

### 2. 레이아웃 모드 (LayoutMode)

```dart
enum LayoutMode {
  vertical,    // VERTICAL - 수직 배치
  horizontal,  // HORIZONTAL - 수평 배치
  grid,        // GRID - 격자형 배치
  stack,       // STACK - 스택형 배치
  flex,        // FLEX - 유연한 배치
}
```

### 3. 크기 조정 모드 (SizingMode)

```dart
enum SizingMode {
  fixed,       // FIXED - 고정 크기
  fill,        // FILL - 부모 영역 채우기
  fitContent,  // FIT_CONTENT - 콘텐츠에 맞춤
  auto,        // AUTO - 자동 크기 조정
}
```

### 4. 반응형 설정 (ResponsiveConfig)

각 화면비별로 최적화된 설정을 제공합니다:

```dart
class ResponsiveConfig {
  final int gridColumns;        // 그리드 컬럼 수
  final double maxContentWidth; // 최대 콘텐츠 너비
  final double sidePadding;     // 측면 패딩
  final double contentSpacing;  // 콘텐츠 간격
  final LayoutMode layoutMode;  // 레이아웃 모드
  // ... 기타 설정
}
```

## 🎨 기본 사용법

### 1. 반응형 컨테이너 사용

```dart
class MyResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      layoutMode: LayoutMode.VERTICAL,
      backgroundColor: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Responsive Container'),
          SizedBox(height: 16),
          ResponsiveContainer(
            layoutMode: LayoutMode.HORIZONTAL,
            child: Row(
              children: [
                Expanded(child: Text('Left')),
                Expanded(child: Text('Right')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 2. 화면비별 조건부 렌더링

```dart
class MyConditionalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        if (category.isLandscape) {
          return _buildLandscapeLayout();
        } else {
          return _buildPortraitLayout();
        }
      },
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(child: LeftPanel()),
        Expanded(child: RightPanel()),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        Expanded(child: TopPanel()),
        Expanded(child: BottomPanel()),
      ],
    );
  }
}
```

### 3. 반응형 그리드 레이아웃

```dart
class MyGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      layoutMode: LayoutMode.GRID,
      child: Wrap(
        children: List.generate(12, (index) {
          return ResponsiveItem(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Item $index'),
              ),
            ),
          );
        }),
      ),
    );
  }
}
```

## 🧩 적응형 컴포넌트

### 1. AdaptiveSafeAreaManager

화면비에 따라 자동으로 여백을 계산하는 적응형 세이프 에어리어 관리자입니다.

```dart
class MyAdaptivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveSafeAreaManager(
        mode: SafeAreaMode.auto, // 자동 감지
        child: Column(
          children: [
            Text('헤더 콘텐츠'),
            Expanded(
              child: Center(
                child: Text('메인 콘텐츠'),
              ),
            ),
            Text('푸터 콘텐츠'),
          ],
        ),
      ),
    );
  }
}
```

**지원하는 SafeAreaMode:**
- `auto`: 화면비에 따라 자동 여백 적용
- `tv`: TV 최적화 여백 (와이드 스크린: 5%, 기타: 2%)
- `mobile`: 모바일 최적화 여백 (2-4%)
- `desktop`: 데스크톱 최적화 여백 (3-8%)
- `none`: 여백 없음

**TV 최적화 여백:**
- 와이드 스크린 (21:9, 24:9, 32:9): 5%
- 표준 스크린 (16:9, 16:10): 2%
- 포트레이트 모드: 기본 시스템 SafeArea 사용

### 2. AdaptiveGrid

화면비에 따라 그리드 설정이 자동으로 조정되는 적응형 그리드입니다.

```dart
class MyAdaptiveGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveSafeAreaManager(
        child: AdaptiveGrid(
          mode: GridMode.tv, // TV 최적화 설정
          children: List.generate(12, (index) {
            return Card(
              child: Container(
                height: 120,
                child: Center(
                  child: Text('Item $index'),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
```

**지원하는 GridMode:**
- `auto`: 화면비에 따라 자동 설정
- `tv`: TV 최적화 (3컬럼, 2.5 비율, 20px 간격)
- `mobile`: 모바일 최적화 (2컬럼, 1.5 비율, 12px 간격)
- `desktop`: 데스크톱 최적화 (4컬럼, 1.2 비율, 16px 간격)

**TV 최적화 그리드 설정:**
- 컬럼 수: 3개
- 가로세로 비율: 2.5
- 간격: 20px (mainAxisSpacing, crossAxisSpacing)

### 3. 적응형 컴포넌트 조합 사용

```dart
class TvHomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: AdaptiveSafeAreaManager(
        mode: SafeAreaMode.tv,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'TV Home',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // 그리드 콘텐츠
            Expanded(
              child: AdaptiveGrid(
                mode: GridMode.tv,
                children: List.generate(9, (index) {
                  return Card(
                    color: Colors.blue[100 * ((index % 9) + 1)],
                    child: Container(
                      child: Center(
                        child: Text(
                          'App ${index + 1}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔧 고급 사용법

### 1. 커스텀 반응형 설정

```dart
class MyCustomResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveConfigOverride(
      gridColumns: 8,
      maxContentWidth: 1200,
      sidePadding: 60,
      contentSpacing: 20,
      child: ResponsiveContainer(
        layoutMode: LayoutMode.GRID,
        child: MyGridContent(),
      ),
    );
  }
}
```

### 2. 적응형 컴포넌트 커스터마이징

```dart
class MyCustomAdaptiveGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveGrid(
      mode: GridMode.auto,
      // 커스텀 설정 오버라이드
      customColumns: 5,
      customAspectRatio: 1.8,
      customSpacing: 24,
      children: _buildGridItems(),
    );
  }

  List<Widget> _buildGridItems() {
    return List.generate(15, (index) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.primaries[index % Colors.primaries.length],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Custom Item $index',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
```

### 3. 세이프 에어리어 커스텀 모드

```dart
class MyCustomSafeArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.none, // 기본 여백 비활성화
      customPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08, // 8% 가로 여백
        vertical: 24, // 고정 세로 여백
      ),
      child: MyContent(),
    );
  }
}
```

### 4. 반응형 애니메이션

```dart
class MyAnimatedWidget extends StatefulWidget {
  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ResponsiveLayoutManager.getResponsiveAnimationDuration(
        context,
        Duration(milliseconds: 300),
      ),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: MyContent(),
    );
  }
}
```

### 5. 조건부 적응형 레이아웃

```dart
class MyConditionalAdaptiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // TV 화면비에서는 적응형 그리드 사용
        if (category == AspectRatioCategory.standard || 
            category == AspectRatioCategory.widescreen ||
            category == AspectRatioCategory.ultraWide) {
          return AdaptiveSafeAreaManager(
            mode: SafeAreaMode.tv,
            child: AdaptiveGrid(
              mode: GridMode.tv,
              children: _buildTvItems(),
            ),
          );
        }
        
        // 모바일 화면비에서는 리스트뷰 사용
        else if (category.isPortrait) {
          return AdaptiveSafeAreaManager(
            mode: SafeAreaMode.mobile,
            child: ListView(
              children: _buildMobileItems(),
            ),
          );
        }
        
        // 기타 화면비에서는 표준 그리드
        else {
          return AdaptiveSafeAreaManager(
            mode: SafeAreaMode.auto,
            child: AdaptiveGrid(
              mode: GridMode.auto,
              children: _buildStandardItems(),
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildTvItems() {
    return List.generate(9, (index) {
      return Card(
        color: Colors.blue[100 * ((index % 9) + 1)],
        child: Center(child: Text('TV Item $index')),
      );
    });
  }

  List<Widget> _buildMobileItems() {
    return List.generate(20, (index) {
      return ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text('Mobile Item $index'),
        subtitle: Text('Mobile optimized layout'),
      );
    });
  }

  List<Widget> _buildStandardItems() {
    return List.generate(12, (index) {
      return Card(
        child: Center(child: Text('Standard Item $index')),
      );
    });
  }
}
```

### 6. 반응형 폰트 및 간격

```dart
class MyResponsiveText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        final fontSize = ResponsiveLayoutManager.getResponsiveFontSize(
          context,
          baseFontSize: 16,
        );
        final spacing = ResponsiveLayoutManager.getResponsiveSpacing(
          context,
          baseSpacing: 8,
        );

        return Column(
          children: [
            Text(
              'Responsive Text',
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(height: spacing),
            Text(
              'This text adapts to different aspect ratios',
              style: TextStyle(fontSize: fontSize * 0.8),
            ),
          ],
        );
      },
    );
  }
}
```

## 🎮 반응형 UI 시뮬레이터

### 1. 기본 시뮬레이터 사용

```dart
class MySimulatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveUISimulator(
        child: MyResponsiveWidget(),
        showControls: true,
        showInfo: true,
        onAspectRatioChanged: (category) {
          print('Aspect ratio changed to: ${category.displayName}');
        },
      ),
    );
  }
}
```

### 2. 독립 시뮬레이터 앱

```dart
class MySimulatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveUISimulatorApp(
      child: MyResponsiveWidget(),
      title: 'My Responsive App',
      initialAspectRatio: AspectRatioCategory.standard,
    );
  }
}
```

### 3. 화면비 선택기

```dart
class MyAspectRatioSelector extends StatefulWidget {
  @override
  _MyAspectRatioSelectorState createState() => _MyAspectRatioSelectorState();
}

class _MyAspectRatioSelectorState extends State<MyAspectRatioSelector> {
  AspectRatioCategory _selectedAspectRatio = AspectRatioCategory.standard;

  @override
  Widget build(BuildContext context) {
    return AspectRatioSelector(
      selectedAspectRatio: _selectedAspectRatio,
      onAspectRatioChanged: (category) {
        setState(() {
          _selectedAspectRatio = category;
        });
      },
      showDescriptions: true,
    );
  }
}
```

## ⚡ 성능 최적화

### 1. 적응형 컴포넌트 최적화

```dart
class MyOptimizedAdaptiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 화면비에 따라 최적화된 컴포넌트 선택
        if (category.isLandscape) {
          return AdaptiveGrid(
            mode: GridMode.tv, // TV에 최적화된 모드
            children: _buildOptimizedGridItems(),
          );
        } else {
          return ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) => _buildOptimizedListItem(index),
          );
        }
      },
    );
  }

  List<Widget> _buildOptimizedGridItems() {
    // 필요시에만 위젯 생성
    return _items.map((item) => _buildGridItem(item)).toList();
  }

  Widget _buildOptimizedListItem(int index) {
    // 인덱스 기반 최적화된 아이템 생성
    return ListTile(
      key: ValueKey(_items[index].id),
      title: Text(_items[index].title),
    );
  }
}
```

### 2. 위젯 재사용 및 캐싱

```dart
class MyOptimizedWidget extends StatelessWidget {
  // 정적 위젯 캐싱
  static final Widget _cachedHeader = Container(
    height: 60,
    child: Text('Cached Header'),
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 설정이 변경될 때만 재빌드
        return _buildContent(config, category);
      },
    );
  }

  Widget _buildContent(ResponsiveConfig config, AspectRatioCategory category) {
    return Column(
      children: [
        _cachedHeader, // 캐시된 위젯 재사용
        Expanded(
          child: AdaptiveSafeAreaManager(
            mode: _getSafeAreaMode(category),
            child: _buildMainContent(category),
          ),
        ),
      ],
    );
  }

  SafeAreaMode _getSafeAreaMode(AspectRatioCategory category) {
    switch (category) {
      case AspectRatioCategory.standard:
      case AspectRatioCategory.widescreen:
        return SafeAreaMode.tv;
      case AspectRatioCategory.tallPortrait:
      case AspectRatioCategory.widePortrait:
        return SafeAreaMode.mobile;
      default:
        return SafeAreaMode.auto;
    }
  }

  Widget _buildMainContent(AspectRatioCategory category) {
    // 화면비별 최적화된 콘텐츠
    if (category.isLandscape) {
      return AdaptiveGrid(
        mode: GridMode.tv,
        children: _buildGridItems(),
      );
    } else {
      return ListView(children: _buildListItems());
    }
  }
}
```

### 3. 조건부 렌더링 최적화

```dart
class MyOptimizedConditionalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoint(
      breakpoint: AspectRatioCategory.widescreen,
      builder: (context) => _buildWideScreenLayout(),
      fallback: _buildStandardLayout(),
    );
  }

  Widget _buildWideScreenLayout() {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.tv,
      child: AdaptiveGrid(
        mode: GridMode.tv,
        children: _buildTvOptimizedItems(),
      ),
    );
  }

  Widget _buildStandardLayout() {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.auto,
      child: AdaptiveGrid(
        mode: GridMode.auto,
        children: _buildStandardItems(),
      ),
    );
  }

  List<Widget> _buildTvOptimizedItems() {
    // TV에 최적화된 아이템들 (더 큰 터치 영역, 큰 폰트)
    return List.generate(9, (index) {
      return Card(
        child: Container(
          height: 120,
          child: Center(
            child: Text(
              'TV Item $index',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildStandardItems() {
    // 표준 아이템들
    return List.generate(12, (index) {
      return Card(
        child: Container(
          height: 80,
          child: Center(child: Text('Item $index')),
        ),
      );
    });
  }
}
```

### 4. 메모리 최적화

```dart
class MyMemoryOptimizedWidget extends StatefulWidget {
  @override
  _MyMemoryOptimizedWidgetState createState() => _MyMemoryOptimizedWidgetState();
}

class _MyMemoryOptimizedWidgetState extends State<MyMemoryOptimizedWidget> {
  ResponsiveConfig? _cachedConfig;
  AspectRatioCategory? _cachedCategory;
  SafeAreaMode? _cachedSafeAreaMode;
  GridMode? _cachedGridMode;

  @override
  Widget build(BuildContext context) {
    final (config, category) = ResponsiveLayoutProvider.getConfigAndCategory(context);
    
    // 설정이 변경된 경우에만 캐시 업데이트
    if (_cachedConfig != config || _cachedCategory != category) {
      _cachedConfig = config;
      _cachedCategory = category;
      _cachedSafeAreaMode = _calculateSafeAreaMode(category);
      _cachedGridMode = _calculateGridMode(category);
    }

    return _buildContent(_cachedConfig!, _cachedCategory!, _cachedSafeAreaMode!, _cachedGridMode!);
  }

  SafeAreaMode _calculateSafeAreaMode(AspectRatioCategory category) {
    if (category.isLandscape && 
        (category == AspectRatioCategory.standard || 
         category == AspectRatioCategory.widescreen ||
         category == AspectRatioCategory.ultraWide)) {
      return SafeAreaMode.tv;
    } else if (category.isPortrait) {
      return SafeAreaMode.mobile;
    } else {
      return SafeAreaMode.auto;
    }
  }

  GridMode _calculateGridMode(AspectRatioCategory category) {
    if (category.isLandscape) {
      return GridMode.tv;
    } else if (category.isPortrait) {
      return GridMode.mobile;
    } else {
      return GridMode.auto;
    }
  }

  Widget _buildContent(ResponsiveConfig config, AspectRatioCategory category, 
                      SafeAreaMode safeAreaMode, GridMode gridMode) {
    // 캐시된 설정 사용
    return AdaptiveSafeAreaManager(
      mode: safeAreaMode,
      child: AdaptiveGrid(
        mode: gridMode,
        children: _buildCachedItems(),
      ),
    );
  }

  List<Widget> _buildCachedItems() {
    // 아이템도 캐싱하여 성능 향상
    return _itemCache ??= _generateItems();
  }

  List<Widget>? _itemCache;
  
  List<Widget> _generateItems() {
    return List.generate(12, (index) {
      return Card(
        key: ValueKey('item_$index'),
        child: Center(child: Text('Cached Item $index')),
      );
    });
  }

  @override
  void dispose() {
    // 메모리 정리
    _itemCache = null;
    super.dispose();
  }
}
```

### 5. 적응형 컴포넌트 성능 모니터링

```dart
class MyPerformanceMonitoredWidget extends StatefulWidget {
  @override
  _MyPerformanceMonitoredWidgetState createState() => _MyPerformanceMonitoredWidgetState();
}

class _MyPerformanceMonitoredWidgetState extends State<MyPerformanceMonitoredWidget> {
  int _buildCount = 0;
  DateTime? _lastBuildTime;
  AspectRatioCategory? _lastCategory;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    final currentTime = DateTime.now();
    
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 화면비 변경 감지
        if (_lastCategory != category) {
          print('Aspect ratio changed from $_lastCategory to $category');
          _lastCategory = category;
        }

        // 빌드 성능 모니터링
        if (_lastBuildTime != null) {
          final timeDiff = currentTime.difference(_lastBuildTime!);
          print('Build time difference: ${timeDiff.inMilliseconds}ms');
        }
        _lastBuildTime = currentTime;
        
        print('Build count: $_buildCount for category: ${category.displayName}');
        
        return AdaptiveSafeAreaManager(
          mode: SafeAreaMode.auto,
          child: AdaptiveGrid(
            mode: GridMode.auto,
            children: _buildMonitoredItems(),
          ),
        );
      },
    );
  }

  List<Widget> _buildMonitoredItems() {
    final startTime = DateTime.now();
    
    final items = List.generate(12, (index) {
      return Card(
        child: Center(child: Text('Monitored Item $index')),
      );
    });
    
    final endTime = DateTime.now();
    final buildDuration = endTime.difference(startTime);
    print('Items build duration: ${buildDuration.inMicroseconds}μs');
    
    return items;
  }
}
```

## 🔍 디버깅 및 문제 해결

### 1. 적응형 컴포넌트 디버깅

```dart
class MyDebugAdaptiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 적응형 컴포넌트 상태 디버깅
        print('=== Adaptive Component Debug Info ===');
        print('Current aspect ratio: ${category.displayName}');
        print('Is landscape: ${category.isLandscape}');
        print('Is portrait: ${category.isPortrait}');
        print('Grid columns: ${config.gridColumns}');
        print('Max content width: ${config.maxContentWidth}');
        
        return AdaptiveSafeAreaManager(
          mode: SafeAreaMode.auto,
          child: Builder(
            builder: (context) {
              // SafeArea 여백 정보 출력
              final mediaQuery = MediaQuery.of(context);
              final padding = mediaQuery.padding;
              print('SafeArea padding: $padding');
              print('Screen size: ${mediaQuery.size}');
              
              return AdaptiveGrid(
                mode: GridMode.auto,
                children: _buildDebugItems(category),
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildDebugItems(AspectRatioCategory category) {
    return List.generate(6, (index) {
      return Card(
        color: category.isLandscape ? Colors.blue[100] : Colors.green[100],
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Item $index'),
              Text(
                category.displayName,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      );
    });
  }
}
```

### 2. 화면비 감지 디버깅

```dart
class MyAspectRatioDebugWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final screenHeight = mediaQuery.size.height;
        final actualRatio = screenWidth / screenHeight;
        
        // 상세한 화면비 정보 출력
        print('=== Aspect Ratio Debug ===');
        print('Screen size: ${screenWidth}x$screenHeight');
        print('Actual ratio: ${actualRatio.toStringAsFixed(3)}');
        print('Detected category: ${category.displayName}');
        print('Category ratio: ${category.aspectRatio.toStringAsFixed(3)}');
        print('Is landscape: ${category.isLandscape}');
        print('===========================');
        
        return Container(
          color: Colors.grey[100],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Debug: ${category.displayName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('Screen: ${screenWidth.toInt()}x${screenHeight.toInt()}'),
                Text('Actual Ratio: ${actualRatio.toStringAsFixed(3)}'),
                Text('Category Ratio: ${category.aspectRatio.toStringAsFixed(3)}'),
                SizedBox(height: 20),
                AdaptiveGrid(
                  mode: GridMode.auto,
                  children: [
                    _buildDebugCard('Landscape', category.isLandscape),
                    _buildDebugCard('Portrait', category.isPortrait),
                    _buildDebugCard('Wide', category.isWide),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDebugCard(String label, bool isActive) {
    return Card(
      color: isActive ? Colors.green[200] : Colors.red[200],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              isActive ? Icons.check : Icons.close,
              color: isActive ? Colors.green : Colors.red,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
```

### 3. 적응형 컴포넌트 설정 검증

```dart
class MyAdaptiveConfigValidator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 적응형 컴포넌트 설정 검증
        _validateAdaptiveSettings(config, category);
        
        return AdaptiveSafeAreaManager(
          mode: SafeAreaMode.auto,
          child: Builder(
            builder: (context) {
              _validateSafeAreaSettings(context, category);
              
              return AdaptiveGrid(
                mode: GridMode.auto,
                children: _buildValidatedItems(),
              );
            },
          ),
        );
      },
    );
  }

  void _validateAdaptiveSettings(ResponsiveConfig config, AspectRatioCategory category) {
    // 기본 설정 검증
    assert(config.gridColumns > 0, 'Grid columns must be positive');
    assert(config.maxContentWidth > 0, 'Max content width must be positive');
    assert(config.sidePadding >= 0, 'Side padding must be non-negative');
    
    // 화면비별 권장 설정 검증
    if (category.isLandscape) {
      if (config.gridColumns < 3) {
        print('Warning: TV landscape layouts typically work better with 3+ columns');
      }
    } else if (category.isPortrait) {
      if (config.gridColumns > 2) {
        print('Warning: Mobile portrait layouts typically work better with 2 or fewer columns');
      }
    }
    
    print('✅ Adaptive settings validation passed');
  }

  void _validateSafeAreaSettings(BuildContext context, AspectRatioCategory category) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    
    // SafeArea 설정 검증
    if (category.isLandscape && padding.horizontal < 20) {
      print('Warning: TV layouts may need more horizontal padding for optimal viewing');
    }
    
    if (category.isPortrait && padding.vertical < 10) {
      print('Warning: Mobile layouts may need more vertical padding for safe area');
    }
    
    print('✅ SafeArea settings validation passed');
  }

  List<Widget> _buildValidatedItems() {
    return List.generate(6, (index) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.verified, color: Colors.green),
                Text('Validated Item $index'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
```

### 4. 성능 모니터링 및 디버깅

```dart
class MyPerformanceDebugWidget extends StatefulWidget {
  @override
  _MyPerformanceDebugWidgetState createState() => _MyPerformanceDebugWidgetState();
}

class _MyPerformanceDebugWidgetState extends State<MyPerformanceDebugWidget> {
  int _buildCount = 0;
  DateTime? _lastBuildTime;
  Map<String, int> _componentBuildCounts = {};

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    final currentTime = DateTime.now();
    
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 빌드 성능 모니터링
        if (_lastBuildTime != null) {
          final timeDiff = currentTime.difference(_lastBuildTime!);
          print('Build time difference: ${timeDiff.inMilliseconds}ms');
          
          if (timeDiff.inMilliseconds > 16) { // 60fps 기준
            print('⚠️ Warning: Build time exceeds 16ms threshold');
          }
        }
        _lastBuildTime = currentTime;
        
        // 컴포넌트별 빌드 횟수 추적
        final componentKey = '${category.displayName}_adaptive';
        _componentBuildCounts[componentKey] = 
            (_componentBuildCounts[componentKey] ?? 0) + 1;
        
        print('=== Performance Debug ===');
        print('Total builds: $_buildCount');
        print('Component builds: $_componentBuildCounts');
        print('Current category: ${category.displayName}');
        print('========================');
        
        return AdaptiveSafeAreaManager(
          mode: SafeAreaMode.auto,
          child: AdaptiveGrid(
            mode: GridMode.auto,
            children: _buildPerformanceItems(),
          ),
        );
      },
    );
  }

  List<Widget> _buildPerformanceItems() {
    final startTime = DateTime.now();
    
    final items = List.generate(9, (index) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.speed),
              Text('Perf Item $index'),
              Text(
                'Builds: $_buildCount',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      );
    });
    
    final endTime = DateTime.now();
    final buildDuration = endTime.difference(startTime);
    
    if (buildDuration.inMicroseconds > 1000) { // 1ms 기준
      print('⚠️ Warning: Items build took ${buildDuration.inMicroseconds}μs');
    }
    
    return items;
  }

  @override
  void dispose() {
    print('=== Final Performance Report ===');
    print('Total builds during lifecycle: $_buildCount');
    print('Component build counts: $_componentBuildCounts');
    print('===============================');
    super.dispose();
  }
}
```

### 5. 일반적인 문제 해결

#### 문제 1: AdaptiveGrid가 예상대로 작동하지 않음

```dart
// ❌ 잘못된 예: ResponsiveContainer 내부에서 사용
ResponsiveContainer(
  child: AdaptiveGrid(...), // 충돌 가능성
)

// ✅ 올바른 예: 직접 사용
AdaptiveGrid(
  mode: GridMode.auto,
  children: [...],
)
```

#### 문제 2: SafeArea 여백이 적용되지 않음

```dart
// ❌ 잘못된 예: Scaffold 외부에서 사용
AdaptiveSafeAreaManager(...)

// ✅ 올바른 예: Scaffold body 내부에서 사용
Scaffold(
  body: AdaptiveSafeAreaManager(
    mode: SafeAreaMode.auto,
    child: ...,
  ),
)
```

#### 문제 3: 과도한 리빌드 발생

```dart
// ✅ 해결책: 조건부 빌드로 최적화
ResponsiveLayoutBuilder(
  builder: (context, config, category) {
    // 화면비에 따라 다른 컴포넌트 사용
    if (category.isLandscape) {
      return _landscapeLayout;
    } else {
      return _portraitLayout;
    }
  },
)
```

## 📚 모범 사례

### 1. 적응형 컴포넌트 설계 원칙

#### TV 최적화 설계
```dart
// ✅ 좋은 예: TV 환경에 최적화된 레이아웃
class TvOptimizedLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // TV 화면비에서는 전용 최적화 적용
        if (category == AspectRatioCategory.standard || 
            category == AspectRatioCategory.widescreen) {
          return AdaptiveSafeAreaManager(
            mode: SafeAreaMode.tv, // TV 전용 여백
            child: AdaptiveGrid(
              mode: GridMode.tv, // TV 전용 그리드 설정
              children: _buildTvItems(),
            ),
          );
        }
        
        // 기타 화면비에서는 자동 최적화
        return AdaptiveSafeAreaManager(
          mode: SafeAreaMode.auto,
          child: AdaptiveGrid(
            mode: GridMode.auto,
            children: _buildStandardItems(),
          ),
        );
      },
    );
  }

  List<Widget> _buildTvItems() {
    // TV에 최적화된 아이템: 큰 터치 영역, 명확한 포커스
    return List.generate(9, (index) {
      return Card(
        elevation: 4,
        child: Container(
          height: 120, // TV에 적합한 높이
          child: Center(
            child: Text(
              'TV App ${index + 1}',
              style: TextStyle(
                fontSize: 18, // TV에 적합한 큰 폰트
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildStandardItems() {
    return List.generate(12, (index) {
      return Card(
        child: Center(child: Text('Item $index')),
      );
    });
  }
}
```

#### 모바일 우선 설계
```dart
// ✅ 좋은 예: 모바일 우선 접근법
class MobileFirstLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 기본은 모바일 레이아웃
        Widget layout = _buildMobileLayout();
        
        // 화면이 커질수록 기능 추가
        if (category.isLandscape) {
          layout = _enhanceForLandscape(layout);
        }
        
        if (category == AspectRatioCategory.widescreen ||
            category == AspectRatioCategory.ultraWide) {
          layout = _enhanceForWideScreen(layout);
        }
        
        return layout;
      },
    );
  }

  Widget _buildMobileLayout() {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.mobile,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _enhanceForLandscape(Widget mobileLayout) {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.auto,
      child: Row(
        children: [
          Container(width: 200, child: _buildSidebar()),
          Expanded(child: mobileLayout),
        ],
      ),
    );
  }

  Widget _enhanceForWideScreen(Widget landscapeLayout) {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.tv,
      child: Row(
        children: [
          Container(width: 250, child: _buildExtendedSidebar()),
          Expanded(child: landscapeLayout),
          Container(width: 200, child: _buildRightPanel()),
        ],
      ),
    );
  }
}
```

### 2. 코드 구조 및 아키텍처

#### 계층적 레이아웃 구조
```dart
// ✅ 좋은 예: 명확한 계층 구조
class MyResponsivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayoutProvider(
        child: _ResponsivePageContent(),
      ),
    );
  }
}

class _ResponsivePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        return AdaptiveSafeAreaManager(
          mode: _getSafeAreaMode(category),
          child: _buildMainContent(category),
        );
      },
    );
  }

  SafeAreaMode _getSafeAreaMode(AspectRatioCategory category) {
    if (category.isLandscape && 
        (category == AspectRatioCategory.standard || 
         category == AspectRatioCategory.widescreen)) {
      return SafeAreaMode.tv;
    } else if (category.isPortrait) {
      return SafeAreaMode.mobile;
    } else {
      return SafeAreaMode.auto;
    }
  }

  Widget _buildMainContent(AspectRatioCategory category) {
    if (category.isLandscape) {
      return _buildLandscapeContent();
    } else {
      return _buildPortraitContent();
    }
  }

  Widget _buildLandscapeContent() {
    return AdaptiveGrid(
      mode: GridMode.tv,
      children: _buildGridItems(),
    );
  }

  Widget _buildPortraitContent() {
    return AdaptiveGrid(
      mode: GridMode.mobile,
      children: _buildGridItems(),
    );
  }

  List<Widget> _buildGridItems() {
    return List.generate(12, (index) {
      return _ResponsiveGridItem(index: index);
    });
  }
}

class _ResponsiveGridItem extends StatelessWidget {
  final int index;
  
  const _ResponsiveGridItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        final isLandscape = category.isLandscape;
        
        return Card(
          elevation: isLandscape ? 4 : 2,
          child: Container(
            padding: EdgeInsets.all(isLandscape ? 16 : 8),
            child: Center(
              child: Text(
                'Item $index',
                style: TextStyle(
                  fontSize: isLandscape ? 16 : 14,
                  fontWeight: isLandscape ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

### 3. 성능 및 최적화

#### 지연 로딩 및 조건부 렌더링
```dart
// ✅ 좋은 예: 성능 최적화된 조건부 렌더링
class OptimizedResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        // 필요한 경우에만 복잡한 위젯 생성
        if (category.isLandscape) {
          return _buildLandscapeOptimized(category);
        } else {
          return _buildPortraitOptimized(category);
        }
      },
    );
  }

  Widget _buildLandscapeOptimized(AspectRatioCategory category) {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.tv,
      child: AdaptiveGrid(
        mode: GridMode.tv,
        children: _buildLazyGridItems(9), // TV에 최적화된 개수
      ),
    );
  }

  Widget _buildPortraitOptimized(AspectRatioCategory category) {
    return AdaptiveSafeAreaManager(
      mode: SafeAreaMode.mobile,
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => _buildLazyListItem(index),
      ),
    );
  }

  List<Widget> _buildLazyGridItems(int count) {
    // 지연 생성으로 성능 향상
    return List.generate(count, (index) {
      return _LazyGridItem(index: index);
    });
  }

  Widget _buildLazyListItem(int index) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text('Mobile Item $index'),
      subtitle: Text('Optimized for mobile'),
    );
  }
}

class _LazyGridItem extends StatelessWidget {
  final int index;
  
  const _LazyGridItem({required this.index});

  @override
  Widget build(BuildContext context) {
    // 실제 필요할 때만 위젯 생성
    return Card(
      key: ValueKey('grid_item_$index'),
      child: Container(
        child: Center(
          child: Text('Lazy Item $index'),
        ),
      ),
    );
  }
}
```

### 4. 접근성 및 사용성

#### 키보드 내비게이션 최적화 (TV용)
```dart
// ✅ 좋은 예: TV 환경을 위한 키보드 내비게이션
class TvAccessibleLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        final isTvMode = category == AspectRatioCategory.standard ||
                        category == AspectRatioCategory.widescreen;
        
        return AdaptiveSafeAreaManager(
          mode: isTvMode ? SafeAreaMode.tv : SafeAreaMode.auto,
          child: AdaptiveGrid(
            mode: isTvMode ? GridMode.tv : GridMode.auto,
            children: _buildAccessibleItems(isTvMode),
          ),
        );
      },
    );
  }

  List<Widget> _buildAccessibleItems(bool isTvMode) {
    return List.generate(9, (index) {
      return Focus(
        child: Builder(
          builder: (context) {
            final isFocused = Focus.of(context).hasFocus;
            
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: isFocused 
                    ? Border.all(color: Colors.blue, width: 3)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Card(
                child: InkWell(
                  onTap: () => _onItemSelected(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: isTvMode ? 120 : 80,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apps,
                            size: isTvMode ? 32 : 24,
                            color: isFocused ? Colors.blue : null,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'App ${index + 1}',
                            style: TextStyle(
                              fontSize: isTvMode ? 16 : 14,
                              fontWeight: isFocused 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                              color: isFocused ? Colors.blue : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _onItemSelected(int index) {
    print('Selected app $index');
    // 앱 실행 로직
  }
}
```

### 5. 테스트 및 품질 보증

#### 적응형 컴포넌트 테스트
```dart
// ✅ 좋은 예: 적응형 컴포넌트 테스트
class TestableResponsiveWidget extends StatelessWidget {
  final AspectRatioCategory? forcedAspectRatio; // 테스트용
  
  const TestableResponsiveWidget({this.forcedAspectRatio});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, config, category) {
        final actualCategory = forcedAspectRatio ?? category;
        
        return AdaptiveSafeAreaManager(
          mode: _getSafeAreaMode(actualCategory),
          child: AdaptiveGrid(
            mode: _getGridMode(actualCategory),
            children: _buildTestableItems(actualCategory),
          ),
        );
      },
    );
  }

  SafeAreaMode _getSafeAreaMode(AspectRatioCategory category) {
    if (category.isLandscape) {
      return SafeAreaMode.tv;
    } else if (category.isPortrait) {
      return SafeAreaMode.mobile;
    } else {
      return SafeAreaMode.auto;
    }
  }

  GridMode _getGridMode(AspectRatioCategory category) {
    if (category.isLandscape) {
      return GridMode.tv;
    } else if (category.isPortrait) {
      return GridMode.mobile;
    } else {
      return GridMode.auto;
    }
  }

  List<Widget> _buildTestableItems(AspectRatioCategory category) {
    final itemCount = category.isLandscape ? 9 : 6;
    
    return List.generate(itemCount, (index) {
      return Card(
        key: ValueKey('test_item_$index'),
        child: Container(
          child: Center(
            child: Text(
              'Test Item $index',
              style: TextStyle(
                fontSize: category.isLandscape ? 16 : 14,
              ),
            ),
          ),
        ),
      );
    });
  }
}

// 테스트 예제
void testResponsiveWidget() {
  // TV 화면비 테스트
  final tvWidget = TestableResponsiveWidget(
    forcedAspectRatio: AspectRatioCategory.standard,
  );
  
  // 모바일 화면비 테스트
  final mobileWidget = TestableResponsiveWidget(
    forcedAspectRatio: AspectRatioCategory.tallPortrait,
  );
}
```

### 6. 일반적인 안티패턴 방지

#### ❌ 피해야 할 패턴들

```dart
// ❌ 잘못된 예: 과도한 중첩
ResponsiveContainer(
  child: AdaptiveSafeAreaManager(
    child: ResponsiveContainer( // 불필요한 중첩
      child: AdaptiveGrid(...),
    ),
  ),
)

// ❌ 잘못된 예: 하드코딩된 화면비 조건
if (MediaQuery.of(context).size.width > 1000) { // 취약한 조건
  return TvLayout();
}

// ❌ 잘못된 예: 성능을 고려하지 않은 빌드
ResponsiveLayoutBuilder(
  builder: (context, config, category) {
    return ExpensiveWidget(); // 매번 새로 생성
  },
)
```

#### ✅ 권장하는 패턴들

```dart
// ✅ 올바른 예: 깔끔한 구조
AdaptiveSafeAreaManager(
  mode: SafeAreaMode.auto,
  child: AdaptiveGrid(
    mode: GridMode.auto,
    children: [...],
  ),
)

// ✅ 올바른 예: 화면비 기반 조건
ResponsiveLayoutBuilder(
  builder: (context, config, category) {
    if (category.isLandscape) {
      return LandscapeLayout();
    } else {
      return PortraitLayout();
    }
  },
)

// ✅ 올바른 예: 성능 최적화된 빌드
class OptimizedWidget extends StatelessWidget {
  static final Widget _cachedWidget = ExpensiveWidget();
  
  @override
  Widget build(BuildContext context) {
    return _cachedWidget;
  }
}
```

## 🚀 다음 단계

1. **API 참조 문서** 확인: [API_REFERENCE.md](API_REFERENCE.md)
2. **아키텍처 가이드** 읽기: [ARCHITECTURE.md](ARCHITECTURE.md)
3. **변경 로그** 확인: [CHANGELOG.md](CHANGELOG.md)
4. **커뮤니티** 참여: [GitHub Discussions](https://github.com/lg-electronics/lg_responsive_ui_framework/discussions)

---

**LG Responsive UI Framework v2.0**으로 더 나은 반응형 UI를 만들어보세요! 🚀
