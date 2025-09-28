/// LG Responsive UI Framework v2.1
///
/// Figma 디자인을 Flutter 코드로 자동 변환하기 위한 반응형 UI 프레임워크입니다.
/// 새로운 Flutter UI Layout Coding Specification을 완전히 지원합니다.
///
/// 주요 기능:
/// - Figma 4가지 레이아웃 모드 완전 지원 (Box, Horizontal, Vertical, Grid)
/// - 5가지 화면비 자동 감지 및 최적화 (16:9, 4:3, 1:1, 3:4, 9:16)
/// - 코딩 스펙 기반 컨테이너 시스템 (BoxContainer, HorizontalContainer, VerticalContainer, GridContainer)
/// - 플레이스홀더 위젯 시스템 (자동 코드 생성 지원)
/// - 반응형 UI 시뮬레이터
/// - Figma Design Spec 기반 자동 레이아웃 변환
///
/// 코딩 스펙 컨테이너 사용 예시:
/// ```dart
/// import 'package:lg_responsive_ui_framework/lg_responsive_ui_framework.dart';
///
/// // Box (Rectangle) 레이아웃
/// BoxContainer(
///   containerId: 'home_header',
///   containerName: 'Header Section',
///   child: HeaderWidget(),
/// )
///
/// // Horizontal 레이아웃
/// HorizontalContainer(
///   containerId: 'nav_menu',
///   containerName: 'Navigation Menu',
///   children: [MenuItem1(), MenuItem2(), MenuItem3()],
/// )
///
/// // Vertical 레이아웃
/// VerticalContainer(
///   containerId: 'content_list',
///   containerName: 'Content List',
///   placeholderItemCount: 5,
/// )
///
/// // Grid 레이아웃
/// ResponsiveGridContainer(
///   containerId: 'content_grid',
///   containerName: 'Content Grid',
///   minItemWidth: 200.0,
///   children: [GridItem1(), GridItem2()],
/// )
/// ```
///
/// 반응형 시스템 사용 예시:
/// ```dart
/// ResponsiveLayoutProvider(
///   child: DynamicLayoutAdapter(
///     builder: (context, aspectRatio) {
///       return Scaffold(
///         body: BoxContainer(
///           containerId: 'main_container',
///           containerName: 'Main Layout',
///           child: VerticalContainer(
///             containerId: 'content_area',
///             containerName: 'Content Area',
///             children: [
///               HeaderContainer(),
///               Expanded(child: ContentGrid()),
///               FooterContainer(),
///             ],
///           ),
///         ),
///       );
///     },
///   ),
/// )
/// ```
library lg_responsive_ui_framework;

// 핵심 반응형 시스템
export 'src/core/responsive_layout_manager.dart';
export 'src/core/dynamic_layout_adapter.dart';
export 'src/core/responsive_layout_provider.dart';

// 코딩 스펙 기반 컨테이너 시스템
export 'src/containers/box_container.dart';
export 'src/containers/horizontal_container.dart';
export 'src/containers/vertical_container.dart';
export 'src/containers/grid_container.dart';
export 'src/containers/placeholder_config.dart';

// 플레이스홀더 위젯 시스템
export 'src/widgets/placeholder_box_item.dart';
export 'src/widgets/placeholder_list_item.dart';
export 'src/widgets/placeholder_grid_item.dart';

// 반응형 UI 시뮬레이터
export 'src/simulator/aspect_ratio_simulator.dart';

// 타입 정의
export 'src/types/aspect_ratio_category.dart';
export 'src/types/layout_mode.dart';
export 'src/types/responsive_config.dart';
export 'src/types/design_spec_types.dart';
export 'src/types/design_spec_models.dart';

// 유틸리티
export 'src/utils/responsive_utils.dart';
export 'src/utils/adaptive_safe_area_manager.dart';
export 'src/utils/layout_calculator.dart';
