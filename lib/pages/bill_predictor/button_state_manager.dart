import 'dart:async';
import 'package:flutter/material.dart';

class ButtonStateManager extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  
  void setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = null; // Clear error when starting new operation
    }
    notifyListeners();
  }
  
  void setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void reset() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

class LoadingButtonWrapper extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onPressed;
  final String? loadingText;
  final String? errorText;
  final Duration? loadingTimeout;
  
  const LoadingButtonWrapper({
    Key? key,
    required this.child,
    this.onPressed,
    this.loadingText,
    this.errorText,
    this.loadingTimeout,
  }) : super(key: key);
  
  @override
  State<LoadingButtonWrapper> createState() => _LoadingButtonWrapperState();
}

class _LoadingButtonWrapperState extends State<LoadingButtonWrapper> {
  final ButtonStateManager _stateManager = ButtonStateManager();
  
  @override
  void dispose() {
    _stateManager.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _stateManager,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            if (_stateManager.isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        if (widget.loadingText != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.loadingText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            if (_stateManager.hasError)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.errorText ?? _stateManager.errorMessage!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _stateManager.clearError,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
