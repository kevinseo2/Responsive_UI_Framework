import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoidCallbackIntent extends Intent {
  final VoidCallback callback;
  const VoidCallbackIntent(this.callback);
}

class FocusManager extends StatefulWidget {
  final Widget child;
  final FocusNode? initialFocus;
  final Map<LogicalKeySet, VoidCallback>? shortcuts;

  const FocusManager({
    Key? key,
    required this.child,
    this.initialFocus,
    this.shortcuts,
  }) : super(key: key);

  @override
  State<FocusManager> createState() => _FocusManagerState();
}

class _FocusManagerState extends State<FocusManager> {
  late FocusNode _rootNode;

  @override
  void initState() {
    super.initState();
    _rootNode = FocusNode(debugLabel: 'RootFocusNode');
    if (widget.initialFocus != null) {
      widget.initialFocus!.requestFocus();
    }
  }

  @override
  void dispose() {
    _rootNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _rootNode,
      child: Shortcuts(
        shortcuts: Map<ShortcutActivator, Intent>.from(
          widget.shortcuts?.map((key, value) => 
            MapEntry(key, VoidCallbackIntent(value))) ?? 
          const {},
        ),
        child: Actions(
          actions: {
            DirectionalFocusIntent: DirectionalFocusAction(),
            VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
              onInvoke: (intent) => intent.callback(),
            ),
          },
          child: widget.child,
        ),
      ),
    );
  }
}
