# Responsive UI Framework for LG webOS

A Flutter UI framework designed for developing responsive applications for LG webOS devices, supporting various aspect ratios and form factors.

## Features

- 📱 Responsive Layout System
  - Support for multiple aspect ratios (32:9, 24:9, 21:9, 16:9, 4:3, 1:1, 3:4, 9:16, 9:21)
  - Easy-to-use layout builder system
  - Resolution simulator for testing (Debug mode only)

- 🎯 Focus Management
  - Directional focus navigation
  - Keyboard shortcuts support
  - Remote control friendly

- ♿ Accessibility
  - Semantic labels and hints
  - Screen reader support
  - High contrast support

- 📱 Touch Input
  - Gesture support (tap, double tap, long press, pan, scale)
  - Touch-friendly components

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  responsive_ui_framework: ^1.0.0
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResolutionSimulator(
        enabled: kDebugMode, // Enable simulator in debug mode
        child: ResponsiveLayout(
          child: const Center(child: Text('Default Layout')),
          layoutBuilders: {
            ScreenAspectRatio.ratio32x9: (context) => UltraWideLayout(),
            ScreenAspectRatio.ratio16x9: (context) => LandscapeLayout(),
            ScreenAspectRatio.ratio9x16: (context) => PortraitLayout(),
          },
        ),
      ),
    );
  }
}
```

### Focus Management

```dart
FocusManager(
  initialFocus: myFocusNode,
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.select): () {
      // Handle select action
    },
  },
  child: YourWidget(),
)
```

### Accessibility

```dart
AccessibleFocusable(
  semanticsLabel: 'Action button',
  focusNode: myFocusNode,
  onTap: () {
    // Handle tap
  },
  child: YourWidget(),
)
```

### Touch Input

```dart
TouchInputHandler(
  onTap: () {
    // Handle tap
  },
  onDoubleTap: () {
    // Handle double tap
  },
  onLongPress: () {
    // Handle long press
  },
  child: YourWidget(),
)
```

## Additional Information

For more examples and detailed documentation, visit the [GitHub repository](https://github.com/your-username/responsive_ui_framework).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### 0.1.1
- Improved Resolution Simulator UX:
  - Overlay panel with scrim and compact panel design.
  - Fullscreen behavior: entering fullscreen makes the simulated viewport fill the window and overrides MediaQuery so child layouts respond to window resizing; controls automatically hide in fullscreen and reappear when exiting.
  - Wide aspect ratios (32:9, 24:9, 21:9) now scale down to fit the window or can be scrolled when larger than the viewport.
  - Compact quick pill at the bottom center for fast previous/next aspect ratio switching.

See `lib/framework/resolution_simulator.dart` and `lib/framework/resolution_simulator_controls.dart` for implementation details.
