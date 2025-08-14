import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final Map<ScreenAspectRatio, Widget Function(BuildContext)> layoutBuilders;

  const ResponsiveLayout({
    Key? key,
    required this.child,
    required this.layoutBuilders,
  }) : super(key: key);

  static final supportedAspectRatios = {
    ScreenAspectRatio.ratio32x9,
    ScreenAspectRatio.ratio24x9,
    ScreenAspectRatio.ratio21x9,
    ScreenAspectRatio.ratio16x9,
    ScreenAspectRatio.ratio4x3,
    ScreenAspectRatio.ratio1x1,
    ScreenAspectRatio.ratio3x4,
    ScreenAspectRatio.ratio9x16,
    ScreenAspectRatio.ratio9x21,
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        final closestRatio = _getClosestAspectRatio(aspectRatio);
        
        if (layoutBuilders.containsKey(closestRatio)) {
          return layoutBuilders[closestRatio]!(context);
        }
        
        return child;
      },
    );
  }

  ScreenAspectRatio _getClosestAspectRatio(double currentRatio) {
    return supportedAspectRatios.reduce((a, b) {
      final aDiff = (a.value - currentRatio).abs();
      final bDiff = (b.value - currentRatio).abs();
      return aDiff < bDiff ? a : b;
    });
  }
}

enum ScreenAspectRatio {
  ratio32x9(32/9),
  ratio24x9(24/9),
  ratio21x9(21/9),
  ratio16x9(16/9),
  ratio4x3(4/3),
  ratio1x1(1),
  ratio3x4(3/4),
  ratio9x16(9/16),
  ratio9x21(9/21);

  final double value;
  const ScreenAspectRatio(this.value);
}
