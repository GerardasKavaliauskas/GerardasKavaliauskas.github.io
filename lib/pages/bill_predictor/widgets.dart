import 'package:flutter/material.dart';

// This file contains additional widgets for the Bill Predictor feature

class DebouncedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Duration debounceDuration;
  final bool enabled;

  const DebouncedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  }) : super(key: key);

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  bool _isProcessing = false;

  void _handlePress() {
    if (!_isProcessing && widget.enabled && widget.onPressed != null) {
      setState(() {
        _isProcessing = true;
      });

      widget.onPressed!();

      // Reset after debounce duration
      Future.delayed(widget.debounceDuration, () {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isProcessing || !widget.enabled,
      child: Opacity(
        opacity: (_isProcessing || !widget.enabled) ? 0.6 : 1.0,
        child: GestureDetector(
          onTap: _handlePress,
          child: widget.child,
        ),
      ),
    );
  }
}

class DebouncedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Duration debounceDuration;
  final bool enabled;

  const DebouncedElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebouncedButton(
      onPressed: onPressed,
      debounceDuration: debounceDuration,
      enabled: enabled,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class DebouncedIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Duration debounceDuration;
  final bool enabled;

  const DebouncedIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebouncedButton(
      onPressed: onPressed,
      debounceDuration: debounceDuration,
      enabled: enabled,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}

class BillPredictorWidgets {
  // Placeholder for future widget extractions
}
