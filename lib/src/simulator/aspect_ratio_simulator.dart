import 'package:flutter/material.dart';
import '../types/aspect_ratio_category.dart';

/// Flutter UI Layout Coding Specification 화면비 시뮬레이터
///
/// 5가지 화면비 (16:9, 4:3, 1:1, 3:4, 9:16)를 시뮬레이션하는 개발/테스트 도구입니다.
/// 우상단 팝업 형태의 제어판을 통해 화면비 선택, 전체화면 모드, 제어판 표시/숨김 기능을 제공합니다.
class AspectRatioSimulator extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final AspectRatioCategory? initialAspectRatio;
  final ValueChanged<AspectRatioCategory>? onAspectRatioChanged;
  final bool showControls;
  final bool showFullscreen;

  const AspectRatioSimulator({
    super.key,
    required this.child,
    this.enabled = true,
    this.initialAspectRatio,
    this.onAspectRatioChanged,
    this.showControls = true,
    this.showFullscreen = true,
  });

  /// 현재 선택된 화면비를 전역적으로 공유
  static AspectRatioCategory currentRatio = AspectRatioCategory.wide;

  /// 전체화면 상태를 전역적으로 공유
  static bool isFullscreen = false;

  @override
  State<AspectRatioSimulator> createState() => _AspectRatioSimulatorState();
}

class _AspectRatioSimulatorState extends State<AspectRatioSimulator> {
  late AspectRatioCategory _currentRatio;
  bool _showControlPanel = true;
  bool _isFullscreen = false;

  final Map<AspectRatioCategory, Map<String, dynamic>> _ratioInfo = {
    AspectRatioCategory.ultraWide: {
      'name': '16:9 Ultra Wide',
      'aspectRatio': 16.0 / 9.0,
      'description': '와이드스크린 TV, 모니터, 자동차',
      'examples': ['1920×1080', '3840×2160', '2560×1440'],
      'color': Colors.blue,
    },
    AspectRatioCategory.wide: {
      'name': '4:3 Wide',
      'aspectRatio': 4.0 / 3.0,
      'description': '일반 TV, 태블릿 가로',
      'examples': ['1024×768', '2048×1536', '1600×1200'],
      'color': Colors.green,
    },
    AspectRatioCategory.square: {
      'name': '1:1 Square',
      'aspectRatio': 1.0,
      'description': '정사각형 디스플레이',
      'examples': ['1080×1080', '2048×2048'],
      'color': Colors.orange,
    },
    AspectRatioCategory.tall: {
      'name': '3:4 Tall',
      'aspectRatio': 3.0 / 4.0,
      'description': '태블릿 세로',
      'examples': ['768×1024', '1536×2048', '2160×2880'],
      'color': Colors.purple,
    },
    AspectRatioCategory.ultraTall: {
      'name': '9:16 Ultra Tall',
      'aspectRatio': 9.0 / 16.0,
      'description': '모바일 세로',
      'examples': ['1080×1920', '1440×2560', '1284×2778'],
      'color': Colors.red,
    },
  };

  @override
  void initState() {
    super.initState();
    _currentRatio =
        widget.initialAspectRatio ?? AspectRatioSimulator.currentRatio;
    _showControlPanel = widget.showControls;
    _isFullscreen = AspectRatioSimulator.isFullscreen;
  }

  void _updateAspectRatio(AspectRatioCategory newRatio) {
    setState(() {
      _currentRatio = newRatio;
    });
    AspectRatioSimulator.currentRatio = newRatio;
    widget.onAspectRatioChanged?.call(newRatio);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    AspectRatioSimulator.isFullscreen = _isFullscreen;
  }

  void _toggleControlPanel() {
    setState(() {
      _showControlPanel = !_showControlPanel;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        // 메인 컨텐츠 영역
        _buildMainContent(),

        // 우상단 제어판 (팝업 형태)
        if (_showControlPanel)
          Positioned(
            top: 20,
            right: 20,
            child: _buildControlPopup(),
          ),

        // 제어판이 숨겨져 있을 때 표시할 토글 버튼
        if (!_showControlPanel)
          Positioned(
            top: 20,
            right: 20,
            child: _buildToggleButton(),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (_isFullscreen) {
      // 전체화면 모드: 전체 화면을 시뮬레이터 크기에 맞춤
      return _buildSimulatedScreen(fullscreen: true);
    } else {
      // 일반 모드: 중앙에 시뮬레이터 표시
      return Center(
        child: _buildSimulatedScreen(fullscreen: false),
      );
    }
  }

  Widget _buildControlPopup() {
    final info = _ratioInfo[_currentRatio]!;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '화면비 시뮬레이터',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: info['color'] as Color,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isFullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        size: 20,
                      ),
                      onPressed: _toggleFullscreen,
                      tooltip: _isFullscreen ? '전체화면 해제' : '전체화면',
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _toggleControlPanel,
                      tooltip: '제어판 숨기기',
                    ),
                  ],
                ),
              ],
            ),

            const Divider(),

            // 현재 선택된 화면비 정보
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (info['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (info['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconForRatio(_currentRatio),
                    color: info['color'] as Color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info['name'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: info['color'] as Color,
                          ),
                        ),
                        Text(
                          info['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 화면비 선택 버튼들
            const Text(
              '화면비 선택:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: AspectRatioCategory.values.map((ratio) {
                final ratioInfo = _ratioInfo[ratio]!;
                final isSelected = ratio == _currentRatio;

                return InkWell(
                  onTap: () => _updateAspectRatio(ratio),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ratioInfo['color'] as Color
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: ratioInfo['color'] as Color,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForRatio(ratio),
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : ratioInfo['color'] as Color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ratio.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : ratioInfo['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // 예시 해상도
            Text(
              '예시 해상도:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              (info['examples'] as List).join(', '),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: _toggleControlPanel,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(
            Icons.settings,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildSimulatedScreen({required bool fullscreen}) {
    final info = _ratioInfo[_currentRatio]!;
    final aspectRatio = info['aspectRatio'] as double;

    if (fullscreen) {
      // 전체화면 모드: 전체 화면을 차지
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: widget.child,
      );
    } else {
      // 일반 모드: 지정된 화면비로 제한
      return Container(
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          border: Border.all(color: info['color'] as Color, width: 3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (info['color'] as Color).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: widget.child,
            ),
          ),
        ),
      );
    }
  }

  IconData _getIconForRatio(AspectRatioCategory ratio) {
    switch (ratio) {
      case AspectRatioCategory.ultraWide:
        return Icons.tv;
      case AspectRatioCategory.wide:
        return Icons.tablet_mac;
      case AspectRatioCategory.square:
        return Icons.crop_square;
      case AspectRatioCategory.tall:
        return Icons.tablet;
      case AspectRatioCategory.ultraTall:
        return Icons.phone_android;
    }
  }
}

/// 화면비 선택기 위젯
class AspectRatioSelector extends StatelessWidget {
  final AspectRatioCategory selectedAspectRatio;
  final ValueChanged<AspectRatioCategory> onAspectRatioChanged;
  final bool compact;

  const AspectRatioSelector({
    super.key,
    required this.selectedAspectRatio,
    required this.onAspectRatioChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return DropdownButton<AspectRatioCategory>(
        value: selectedAspectRatio,
        items: AspectRatioCategory.values.map((ratio) {
          return DropdownMenuItem(
            value: ratio,
            child: Text(ratio.displayName),
          );
        }).toList(),
        onChanged: (ratio) {
          if (ratio != null) onAspectRatioChanged(ratio);
        },
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AspectRatioCategory.values.map((ratio) {
        final isSelected = ratio == selectedAspectRatio;

        return FilterChip(
          label: Text(ratio.displayName),
          selected: isSelected,
          onSelected: (_) => onAspectRatioChanged(ratio),
        );
      }).toList(),
    );
  }
}

/// 반응형 UI 시뮬레이터
class ResponsiveUISimulator extends StatelessWidget {
  final Widget child;
  final AspectRatioCategory? initialAspectRatio;
  final ValueChanged<AspectRatioCategory>? onAspectRatioChanged;
  final bool showControls;
  final bool showInfo;

  const ResponsiveUISimulator({
    super.key,
    required this.child,
    this.initialAspectRatio,
    this.onAspectRatioChanged,
    this.showControls = true,
    this.showInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatioSimulator(
      initialAspectRatio: initialAspectRatio,
      onAspectRatioChanged: onAspectRatioChanged,
      showControls: showControls,
      child: child,
    );
  }
}
