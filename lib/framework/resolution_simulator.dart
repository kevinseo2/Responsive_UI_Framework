import 'package:flutter/material.dart';
import 'screen_aspect_ratio.dart';
import 'resolution_simulator_controls.dart';

/// A resolution simulator widget for testing responsive layouts in debug mode.
/// This widget provides a UI to switch between different aspect ratios and screen sizes.
class ResolutionSimulator extends StatefulWidget {
  /// The child widget to display in the simulator
  final Widget child;

  /// Whether the simulator is enabled. Usually set to true only in debug mode.
  final bool enabled;

  /// Whether to show the simulator controls initially
  final bool showControls;

  /// Whether to show the fullscreen button
  final bool showFullscreen;

  const ResolutionSimulator({
    Key? key,
    required this.child,
    this.enabled = false,
    this.showControls = true,
    this.showFullscreen = true,
  }) : super(key: key);

  @override
  State<ResolutionSimulator> createState() => _ResolutionSimulatorState();
}

class _ResolutionSimulatorState extends State<ResolutionSimulator> {
  ScreenAspectRatio _selectedRatio = ScreenAspectRatio.ratio16x9;
  double _width = screenSizes[ScreenAspectRatio.ratio16x9]!.width.toDouble();
  double _height = screenSizes[ScreenAspectRatio.ratio16x9]!.height.toDouble();
  bool _showControls = true;
  bool _isFullscreen = false;

  static final Map<ScreenAspectRatio, Color> ratioColors = {
    ScreenAspectRatio.ratio32x9: Colors.deepPurple,
    ScreenAspectRatio.ratio24x9: Colors.indigo,
    ScreenAspectRatio.ratio21x9: Colors.blue,
    ScreenAspectRatio.ratio16x9: Colors.green,
    ScreenAspectRatio.ratio4x3: Colors.orange,
    ScreenAspectRatio.ratio1x1: Colors.red,
    ScreenAspectRatio.ratio3x4: Colors.amber,
    ScreenAspectRatio.ratio9x16: Colors.teal,
    ScreenAspectRatio.ratio9x21: Colors.pink,
  };

  @override
  void initState() {
    super.initState();
    _showControls = widget.showControls;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Scaffold(
      body: Material(
        child: Stack(
          children: [
            // Main simulator content remains the base layer
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: _buildSimulatorContent(),
                  ),
                ),
              ],
            ),

            // Visibility toggle
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                    _showControls ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                },
                tooltip: _showControls ? '컨트롤 숨기기' : '컨트롤 표시',
              ),
            ),

            // Scrim behind the panel
            if (_showControls)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _showControls = false),
                  child: Container(color: Colors.black26),
                ),
              ),

            // Controls overlay (right-side panel)
            if (_showControls)
              Positioned(
                top: 16,
                right: 16,
                bottom: 16,
                child: ResolutionSimulatorControls(
                  currentRatio: _selectedRatio,
                  currentWidth: _width,
                  currentHeight: _height,
                  onRatioChanged: (ratio) {
                    setState(() {
                      _selectedRatio = ratio;
                      final size = screenSizes[ratio]!;
                      _width = size.width.toDouble();
                      _height = size.height.toDouble();
                    });
                  },
                  onWidthChanged: (value) {
                    setState(() {
                      _width = value;
                    });
                  },
                  onHeightChanged: (value) {
                    setState(() {
                      _height = value;
                    });
                  },
                  isFullscreen: _isFullscreen,
                  onFullscreenToggle: () {
                    setState(() {
                      _isFullscreen = !_isFullscreen;
                      // hide controller when entering fullscreen, show when exiting
                      _showControls = !_isFullscreen ? _showControls : false;
                      if (!_isFullscreen) {
                        // when exiting fullscreen, show controls again
                        _showControls = true;
                      }
                    });
                  },
                  onClose: () => setState(() => _showControls = false),
                  showFullscreenButton: widget.showFullscreen,
                ),
              ),

            // Bottom quick pill overlay (independent)
            if (!_isFullscreen)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            final idx = ScreenAspectRatio.values
                                .indexOf(_selectedRatio);
                            final prev = ScreenAspectRatio.values[
                                (idx - 1 + ScreenAspectRatio.values.length) %
                                    ScreenAspectRatio.values.length];
                            setState(() => _selectedRatio = prev);
                          },
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(_getRatioName(_selectedRatio),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          onPressed: () {
                            final idx = ScreenAspectRatio.values
                                .indexOf(_selectedRatio);
                            final next = ScreenAspectRatio.values[
                                (idx + 1) % ScreenAspectRatio.values.length];
                            setState(() => _selectedRatio = next);
                          },
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorContent() {
    // Use LayoutBuilder so we can decide how to wrap the simulated content
    return LayoutBuilder(builder: (context, constraints) {
      final content = Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          border: Border.all(
            color: ratioColors[_selectedRatio]!,
            width: 2,
          ),
          color: Colors.white,
        ),
        child: widget.child,
      );

      if (_isFullscreen) {
        // In fullscreen, make the simulated area fill available constraints
        return LayoutBuilder(builder: (context, full) {
          return Container(
            width: full.maxWidth,
            height: full.maxHeight,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(size: Size(full.maxWidth, full.maxHeight)),
              child: widget.child,
            ),
          );
        });
      }

      // If simulated size fits within available constraints, center it.
      final fitsHorizontally = _width <= constraints.maxWidth;
      final fitsVertically = _height <= constraints.maxHeight;

      if (fitsHorizontally && fitsVertically) {
        return Center(child: content);
      }

      // If content is larger than available space, scale it down to fit while
      // preserving aspect ratio so the user can see the full simulated frame.
      final targetWidth = constraints.maxWidth * 0.95;
      final targetHeight = constraints.maxHeight * 0.85;

      return Center(
        child: SizedBox(
          width: targetWidth,
          height: targetHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(width: _width, height: _height, child: content),
          ),
        ),
      );
    });
  }

  String _getRatioName(ScreenAspectRatio ratio) {
    switch (ratio) {
      case ScreenAspectRatio.ratio32x9:
        return '32:9 Ultra Super Wide';
      case ScreenAspectRatio.ratio24x9:
        return '24:9 Ultra Wide';
      case ScreenAspectRatio.ratio21x9:
        return '21:9 Widescreen';
      case ScreenAspectRatio.ratio16x9:
        return '16:9 Standard';
      case ScreenAspectRatio.ratio4x3:
        return '4:3 Traditional';
      case ScreenAspectRatio.ratio1x1:
        return '1:1 Square';
      case ScreenAspectRatio.ratio3x4:
        return '3:4 Portrait';
      case ScreenAspectRatio.ratio9x16:
        return '9:16 Portrait';
      case ScreenAspectRatio.ratio9x21:
        return '9:21 Ultra Tall';
    }
  }
}
