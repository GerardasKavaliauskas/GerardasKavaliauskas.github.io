import 'package:flutter/material.dart';
import '../../services/lithuanian_electricity_data_service.dart';

class LithuanianComparisonWidget extends StatefulWidget {
  final double userMonthlyConsumption;
  final double userHomeArea;

  const LithuanianComparisonWidget({
    Key? key,
    required this.userMonthlyConsumption,
    required this.userHomeArea,
  }) : super(key: key);

  @override
  State<LithuanianComparisonWidget> createState() => _LithuanianComparisonWidgetState();
}

class _LithuanianComparisonWidgetState extends State<LithuanianComparisonWidget> {
  ConsumptionComparison? _comparison;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComparison();
  }

  Future<void> _loadComparison() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final comparison = await LithuanianElectricityDataService.compareWithLithuanianAverage(
        userMonthlyConsumption: widget.userMonthlyConsumption,
        userHomeArea: widget.userHomeArea,
      );

      setState(() {
        _comparison = comparison;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'Comparison with Lithuanian Average',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_comparison != null)
                  IconButton(
                    onPressed: _loadComparison,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh data',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              _buildErrorWidget()
            else if (_comparison != null)
              _buildComparisonContent()
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Failed to get data'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          const Text(
            'Failed to get Lithuanian data',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 4),
          Text(
            'Error: $_error',
            style: const TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loadComparison,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonContent() {
    final comparison = _comparison!;
    
    return Column(
      children: [
        // Efficiency Rating
        _buildEfficiencyRating(comparison.efficiencyRating),
        const SizedBox(height: 16),
        
        // Comparison Message
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getEfficiencyColor(comparison.efficiencyRating).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getEfficiencyColor(comparison.efficiencyRating).withOpacity(0.3),
            ),
          ),
          child: Text(
            comparison.comparisonMessage,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: _getEfficiencyColor(comparison.efficiencyRating),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        
        // Statistics Grid
        _buildStatisticsGrid(comparison),
        const SizedBox(height: 16),
        
        // Potential Savings
        if (comparison.potentialAnnualSavings > 0)
          _buildSavingsCard(comparison.potentialAnnualSavings),
      ],
    );
  }

  Widget _buildEfficiencyRating(EfficiencyRating rating) {
    final color = _getEfficiencyColor(rating);
    final text = _getEfficiencyText(rating);
    final icon = _getEfficiencyIcon(rating);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(ConsumptionComparison comparison) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Your consumption',
            '${comparison.userConsumption.toStringAsFixed(0)} kWh',
            Icons.person,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Lithuanian average',
            '${comparison.lithuanianAverage.toStringAsFixed(0)} kWh',
            Icons.people,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Difference',
            '${comparison.consumptionDifference > 0 ? '+' : ''}${comparison.consumptionDifference.toStringAsFixed(0)} kWh',
            Icons.trending_up,
            comparison.consumptionDifference > 0 ? Colors.orange : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard(double potentialSavings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.savings, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Potential annual savings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '€${potentialSavings.toStringAsFixed(0)} per year',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getEfficiencyColor(EfficiencyRating rating) {
    switch (rating) {
      case EfficiencyRating.excellent:
        return Colors.green;
      case EfficiencyRating.good:
        return Colors.lightGreen;
      case EfficiencyRating.average:
        return Colors.blue;
      case EfficiencyRating.belowAverage:
        return Colors.orange;
      case EfficiencyRating.poor:
        return Colors.red;
    }
  }

  String _getEfficiencyText(EfficiencyRating rating) {
    switch (rating) {
      case EfficiencyRating.excellent:
        return 'Excellent!';
      case EfficiencyRating.good:
        return 'Good';
      case EfficiencyRating.average:
        return 'Average';
      case EfficiencyRating.belowAverage:
        return 'Below Average';
      case EfficiencyRating.poor:
        return 'Needs Improvement';
    }
  }

  IconData _getEfficiencyIcon(EfficiencyRating rating) {
    switch (rating) {
      case EfficiencyRating.excellent:
        return Icons.emoji_events;
      case EfficiencyRating.good:
        return Icons.thumb_up;
      case EfficiencyRating.average:
        return Icons.remove;
      case EfficiencyRating.belowAverage:
        return Icons.trending_down;
      case EfficiencyRating.poor:
        return Icons.warning;
    }
  }
}
