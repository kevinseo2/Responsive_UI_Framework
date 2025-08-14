import 'package:flutter/material.dart';
import 'responsive_layout.dart';

/// A resolution simulator widget for testing responsive layouts in debug mode.
/// This widget provides a UI to switch between different aspect ratios and screen sizes.
class ResolutionSimulator extends StatefulWidget {
  /// The child widget to display in the simulator
  final Widget child;

  /// Whether the simulator is enabled. Usually set to true only in debug mode.
  final bool enabled;

  const ResolutionSimulator({
    Key? key,
    required this.child,
    this.enabled = false,
  }) : super(key: key);

  @override
  State<ResolutionSimulator> createState() => _ResolutionSimulatorState();
}

class _ResolutionSimulatorState extends State<ResolutionSimulator> {
  ScreenAspectRatio _selectedRatio = ScreenAspectRatio.ratio16x9;
  double _width = 1920;
  double _height = 1080;

  static final Map<ScreenAspectRatio, Size> _defaultSizes = {
    ScreenAspectRatio.ratio32x9: const Size(3840, 1080),
    ScreenAspectRatio.ratio24x9: const Size(2880, 1080),
    ScreenAspectRatio.ratio21x9: const Size(2560, 1080),
    ScreenAspectRatio.ratio16x9: const Size(1920, 1080),
    ScreenAspectRatio.ratio4x3: const Size(1600, 1200),
    ScreenAspectRatio.ratio1x1: const Size(1080, 1080),
    ScreenAspectRatio.ratio3x4: const Size(1200, 1600),
    ScreenAspectRatio.ratio9x16: const Size(1080, 1920),
    ScreenAspectRatio.ratio9x21: const Size(1080, 2560),
  };

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Scaffold(
      body: Material(
        child: Column(
          children: [
            _buildSimulatorControls(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Container(
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        color: Colors.white,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Aspect Ratio: '),
              DropdownButton<ScreenAspectRatio>(
                value: _selectedRatio,
                items: ScreenAspectRatio.values.map((ratio) {
                  return DropdownMenuItem(
                    value: ratio,
                    child: Text(ratio.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (ratio) {
                  if (ratio != null) {
                    setState(() {
                      _selectedRatio = ratio;
                      final defaultSize = _defaultSizes[ratio]!;
                      _width = defaultSize.width;
                      _height = defaultSize.height;
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    const Text('Width: '),
                    Expanded(
                      child: Slider(
                        value: _width,
                        min: 320,
                        max: 3840,
                        onChanged: (value) {
                          setState(() {
                            _width = value;
                            _height = value / _selectedRatio.value;
                          });
                        },
                      ),
                    ),
                    Text('${_width.toInt()}'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    const Text('Height: '),
                    Expanded(
                      child: Slider(
                        value: _height,
                        min: 320,
                        max: 2560,
                        onChanged: (value) {
                          setState(() {
                            _height = value;
                            _width = value * _selectedRatio.value;
                          });
                        },
                      ),
                    ),
                    Text('${_height.toInt()}'),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Current Resolution: ${_width.toInt()}x${_height.toInt()} (${_selectedRatio.toString().split('.').last})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
