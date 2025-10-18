import 'package:flutter/material.dart';
import 'enhanced_button.dart';

class ButtonDemoPage extends StatefulWidget {
  const ButtonDemoPage({Key? key}) : super(key: key);

  @override
  State<ButtonDemoPage> createState() => _ButtonDemoPageState();
}

class _ButtonDemoPageState extends State<ButtonDemoPage> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _simulateAsyncOperation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate random success/failure
      if (DateTime.now().millisecond % 3 == 0) {
        throw Exception('Simulated network error');
      }
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Operation completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Button Demo'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhanced Button Features',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Professional button component with hover states, loading animations, and accessibility features.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            
            // Basic Button
            _buildSection(
              'Basic Button',
              'Standard button with hover and press animations',
              EnhancedPredictionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Basic button pressed!')),
                  );
                },
                text: 'Basic Button',
                icon: Icons.star,
                backgroundColor: Colors.blue.shade600,
              ),
            ),
            
            // Loading Button
            _buildSection(
              'Loading Button',
              'Button with loading state and spinner',
              EnhancedPredictionButton(
                onPressed: _isLoading ? null : _simulateAsyncOperation,
                text: 'Start Async Operation',
                icon: Icons.cloud_upload,
                isLoading: _isLoading,
                loadingText: 'Processing...',
                backgroundColor: Colors.green.shade600,
              ),
            ),
            
            // Error State
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Error Occurred',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _clearError,
                      icon: const Icon(Icons.close),
                      color: Colors.red.shade600,
                    ),
                  ],
                ),
              ),
            ],
            
            // Disabled Button
            _buildSection(
              'Disabled Button',
              'Button in disabled state with proper styling',
              EnhancedPredictionButton(
                onPressed: null,
                text: 'Disabled Button',
                icon: Icons.block,
                backgroundColor: Colors.grey.shade400,
              ),
            ),
            
            // Custom Styled Button
            _buildSection(
              'Custom Styled Button',
              'Button with custom colors and dimensions',
              EnhancedPredictionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Custom button pressed!')),
                  );
                },
                text: 'Custom Style',
                icon: Icons.palette,
                backgroundColor: Colors.purple.shade600,
                textColor: Colors.white,
                width: 200,
                height: 60,
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            
            // Accessibility Features
            _buildSection(
              'Accessibility Features',
              'Button with semantic labels and tooltips',
              EnhancedPredictionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Accessible button pressed!')),
                  );
                },
                text: 'Accessible Button',
                icon: Icons.accessibility,
                backgroundColor: Colors.orange.shade600,
                semanticLabel: 'Navigate to predictions page',
                tooltip: 'Click to start creating your energy forecast',
              ),
            ),
            
            // Button Row
            _buildSection(
              'Button Row',
              'Multiple buttons with different styles',
              Row(
                children: [
                  Expanded(
                    child: EnhancedPredictionButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Primary action!')),
                        );
                      },
                      text: 'Primary',
                      icon: Icons.check,
                      backgroundColor: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: EnhancedPredictionButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Secondary action!')),
                        );
                      },
                      text: 'Secondary',
                      icon: Icons.info,
                      backgroundColor: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Features List
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Button Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem('✅ Hover animations with smooth transitions'),
                    _buildFeatureItem('✅ Press animations with scale effects'),
                    _buildFeatureItem('✅ Loading states with spinners'),
                    _buildFeatureItem('✅ Error handling with user feedback'),
                    _buildFeatureItem('✅ Accessibility support (ARIA labels)'),
                    _buildFeatureItem('✅ Keyboard navigation support'),
                    _buildFeatureItem('✅ Tooltip support for better UX'),
                    _buildFeatureItem('✅ Customizable colors and dimensions'),
                    _buildFeatureItem('✅ Semantic labels for screen readers'),
                    _buildFeatureItem('✅ Proper cursor states (pointer/basic)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String description, Widget button) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          button,
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
