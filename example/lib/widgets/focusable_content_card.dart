import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';

class FocusableContentCard extends StatefulWidget {
  final String title;
  final double aspectRatio;
  final VoidCallback? onFocus;
  final VoidCallback? onPressed;
  final bool isSelected;

  const FocusableContentCard({
    Key? key,
    required this.title,
    this.aspectRatio = 16/9,
    this.onFocus,
    this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<FocusableContentCard> createState() => _FocusableContentCardState();
}

class _FocusableContentCardState extends State<FocusableContentCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Focus(
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
          if (focused && widget.onFocus != null) {
            widget.onFocus!();
          }
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isFocused 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.transparent,
                width: 2,
              ),
              boxShadow: _isFocused 
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha((0.3 * 255).round()),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : [],
            ),
            child: Card(
              elevation: _isFocused ? 8 : 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
