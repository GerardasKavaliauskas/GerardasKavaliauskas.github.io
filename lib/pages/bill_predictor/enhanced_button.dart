import 'package:flutter/material.dart';

class EnhancedPredictionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final String? loadingText;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final String? tooltip;

  const EnhancedPredictionButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.loadingText,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.semanticLabel,
    this.tooltip,
  }) : super(key: key);

  @override
  State<EnhancedPredictionButton> createState() => _EnhancedPredictionButtonState();
}

class _EnhancedPredictionButtonState extends State<EnhancedPredictionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleTap() {
    if (!widget.isLoading && widget.onPressed != null && !_isPressed) {
      setState(() {
        _isPressed = true;
      });
      
      try {
        widget.onPressed!();
      } catch (e) {
        // Handle error gracefully
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
      
      // Reset pressed state after a short delay to prevent double clicks
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isPressed = false;
          });
        }
      });
    }
  }

  void _handleHoverEnter(PointerEvent event) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isHovered = true;
      });
    }
  }

  void _handleHoverExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !widget.isLoading && widget.onPressed != null;
    
    // Default colors
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final textColor = widget.textColor ?? Colors.white;
    
    // Calculate colors based on state
    Color currentBackgroundColor = backgroundColor;
    Color currentTextColor = textColor;
    
    if (_isHovered && isEnabled) {
      currentBackgroundColor = backgroundColor.withOpacity(0.9);
    } else if (_isPressed && isEnabled) {
      currentBackgroundColor = backgroundColor.withOpacity(0.8);
    } else if (!isEnabled) {
      currentBackgroundColor = Colors.grey.shade400;
      currentTextColor = Colors.grey.shade600;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: MouseRegion(
              cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
              onEnter: _handleHoverEnter,
              onExit: _handleHoverExit,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: _handleTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: widget.width ?? double.infinity,
                  height: widget.height ?? 56,
                  padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: currentBackgroundColor,
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                    boxShadow: [
                      if (isEnabled) ...[
                        BoxShadow(
                          color: backgroundColor.withOpacity(0.3),
                          blurRadius: _isHovered ? 12 : 8,
                          offset: Offset(0, _isHovered ? 6 : 4),
                        ),
                      ],
                    ],
                    border: _isHovered && isEnabled
                        ? Border.all(color: backgroundColor.withOpacity(0.3), width: 2)
                        : null,
                  ),
                  child: Semantics(
                    label: widget.semanticLabel ?? widget.text,
                    button: true,
                    enabled: isEnabled,
                    child: Tooltip(
                      message: widget.tooltip ?? widget.text,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isLoading) ...[
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(currentTextColor),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ] else if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: currentTextColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.isLoading 
                                  ? (widget.loadingText ?? 'Loading...')
                                  : widget.text,
                              style: TextStyle(
                                color: currentTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
