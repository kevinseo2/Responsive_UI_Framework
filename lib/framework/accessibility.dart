import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityWrapper extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final bool excludeSemantics;

  const AccessibilityWrapper({
    Key? key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.excludeSemantics = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      excludeSemantics: excludeSemantics,
      child: MergeSemantics(
        child: child,
      ),
    );
  }
}

class AccessibleFocusable extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;
  final String? semanticsLabel;
  final VoidCallback? onTap;

  const AccessibleFocusable({
    Key? key,
    required this.child,
    this.focusNode,
    this.semanticsLabel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: onTap,
        child: AccessibilityWrapper(
          semanticsLabel: semanticsLabel,
          child: child,
        ),
      ),
    );
  }
}
