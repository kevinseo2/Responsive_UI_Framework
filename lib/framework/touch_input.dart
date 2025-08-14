import 'package:flutter/material.dart';

class TouchInputHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureScaleUpdateCallback? onScaleUpdate;

  const TouchInputHandler({
    Key? key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onPanUpdate,
    this.onScaleUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onPanUpdate: onPanUpdate,
      child: child,
    );
  }
}
