import 'package:flutter/material.dart';
import 'screen_aspect_ratio.dart';

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
