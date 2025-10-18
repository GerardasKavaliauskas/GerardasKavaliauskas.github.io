import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/models.dart';
import '../../services/optimal_t.dart';
import '../../services/ai_insights_service.dart';
import 'educational_content.dart';
import 'enhanced_button.dart';
import 'widgets.dart';
import 'lithuanian_comparison_widget.dart';

class BillPredictorPage extends StatefulWidget {
  const BillPredictorPage({super.key});

  @override
  State<BillPredictorPage> createState() => _BillPredictorPageState();
}

class _BillPredictorPageState extends State<BillPredictorPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Form data
  final TextEditingController _monthlyUsageController = TextEditingController();
  final TextEditingController _homeAreaController = TextEditingController();
  final Set<String> _selectedAppliances = {};
  final List<HistoricalBill> _historicalBills = [];
  
  // Custom appliances
  final List<CustomAppliance> _customAppliances = [];
  final TextEditingController _customApplianceNameController = TextEditingController();
  final TextEditingController _customApplianceWattsController = TextEditingController();
  
  // Prediction results
  PredictionResult? _predictionResult;
  bool _isLoading = false;
  
  // AI insights
  List<String> _aiInsights = [];
  bool _isGeneratingInsights = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _monthlyUsageController.dispose();
    _homeAreaController.dispose();
    _customApplianceNameController.dispose();
    _customApplianceWattsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Predictor'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.input),
              text: 'Input Your Data',
            ),
            Tab(
              icon: Icon(Icons.trending_up),
              text: 'Your Predictions',
            ),
            Tab(
              icon: Icon(Icons.lightbulb_outline),
              text: 'Insights & Tips',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInputTab(),
          _buildPredictionsTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildInputTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppliancesInput(),
            const SizedBox(height: 24),
            _buildUsageInput(),
            const SizedBox(height: 24),
            _buildHomeAreaInput(),
            const SizedBox(height: 24),
            _buildHistoricalBillsInput(),
            const SizedBox(height: 32),
            _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Current Monthly Usage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Enter your average monthly electricity consumption in kWh. You can find this on your electricity bill.',
                  child: Icon(Icons.help_outline, size: 20, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _monthlyUsageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Monthly Usage (kWh)',
                hintText: 'e.g., 450',
                border: OutlineInputBorder(),
                suffixText: 'kWh',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your monthly usage';
                }
                final usage = int.tryParse(value);
                if (usage == null || usage <= 0 || usage > 10000) {
                  return 'Please enter a valid usage between 1 and 10,000 kWh';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              '💡 Tip: Check your electricity bill for the exact amount. Average Lithuanian household uses 300-500 kWh/month.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeAreaInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Home Area',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Enter the total area of your home in square meters. Larger homes typically consume more energy.',
                  child: Icon(Icons.help_outline, size: 20, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _homeAreaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Home Area (m²)',
                hintText: 'e.g., 120',
                border: OutlineInputBorder(),
                suffixText: 'm²',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your home area';
                }
                final area = int.tryParse(value);
                if (area == null || area <= 0 || area > 1000) {
                  return 'Please enter a valid area between 1 and 1000 m²';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              '💡 Tip: Check your property documents or measure your home. Average Lithuanian home is 80-120 m².',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliancesInput() {
    final appliances = [
      ApplianceOption('Electric heating (winter usage)', Icons.thermostat, 800),
      ApplianceOption('Air conditioning (summer usage)', Icons.ac_unit, 150),
      ApplianceOption('EV charger', Icons.electric_car, 300),
      ApplianceOption('Electric water heater', Icons.water_drop, 100),
      ApplianceOption('Other high-consumption appliances', Icons.power, 200),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Major Appliances',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Select appliances that significantly impact your energy consumption.',
                  child: Icon(Icons.help_outline, size: 20, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...appliances.map((appliance) => _buildApplianceCheckbox(appliance)),
            const SizedBox(height: 16),
            _buildCustomAppliancesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildApplianceCheckbox(ApplianceOption appliance) {
    final isSelected = _selectedAppliances.contains(appliance.name);
    return CheckboxListTile(
      title: Text(appliance.name),
      subtitle: Text('+${appliance.watts} kWh/month'),
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedAppliances.add(appliance.name);
          } else {
            _selectedAppliances.remove(appliance.name);
          }
        });
      },
      secondary: Icon(appliance.icon),
    );
  }

  Widget _buildCustomAppliancesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'Other, non-listed devices',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Add custom devices not listed above with their power consumption.',
              child: Icon(Icons.help_outline, size: 18, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _customApplianceNameController,
                decoration: const InputDecoration(
                  labelText: 'Device Name',
                  hintText: 'e.g., Gaming PC, Pool Heater',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _customApplianceWattsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Watts',
                  hintText: '500',
                  border: OutlineInputBorder(),
                  suffixText: 'W',
                ),
              ),
            ),
            const SizedBox(width: 12),
            DebouncedElevatedButton(
              onPressed: _addCustomAppliance,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add),
                  const SizedBox(width: 8),
                  const Text('Add'),
                ],
              ),
            ),
          ],
        ),
        if (_customAppliances.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Your Custom Devices:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ..._customAppliances.map((appliance) => _buildCustomApplianceTile(appliance)),
        ],
      ],
    );
  }

  Widget _buildCustomApplianceTile(CustomAppliance appliance) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(appliance.icon),
        title: Text(appliance.name),
        subtitle: Text('${appliance.watts}W (${(appliance.watts * 0.73).round()} kWh/month)'),
        trailing: DebouncedIconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              _customAppliances.remove(appliance);
            });
          },
        ),
      ),
    );
  }

  void _addCustomAppliance() {
    final name = _customApplianceNameController.text.trim();
    final wattsText = _customApplianceWattsController.text.trim();
    
    if (name.isEmpty || wattsText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both device name and power consumption')),
      );
      return;
    }
    
    final watts = int.tryParse(wattsText);
    if (watts == null || watts <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid power consumption')),
      );
      return;
    }
    
    setState(() {
      _customAppliances.add(CustomAppliance(name: name, watts: watts));
      _customApplianceNameController.clear();
      _customApplianceWattsController.clear();
    });
  }

  Widget _buildHistoricalBillsInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Historical Bills (Optional)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Upload your past bills for more accurate predictions. CSV or PDF files accepted.',
                  child: Icon(Icons.help_outline, size: 20, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement file upload
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File upload feature coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Bills'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showManualEntryDialog();
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Manual Entry'),
                  ),
                ),
              ],
            ),
            if (_historicalBills.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Recent Bills:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ..._historicalBills.take(3).map((bill) => ListTile(
                title: Text('${bill.month}: €${bill.cost.toStringAsFixed(2)}'),
                subtitle: Text('${bill.kwh} kWh'),
                trailing: DebouncedIconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _historicalBills.remove(bill);
                    });
                  },
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: EnhancedPredictionButton(
        onPressed: _isLoading ? null : _generatePredictions,
        text: 'Generate Predictions',
        icon: Icons.analytics,
        isLoading: _isLoading,
        loadingText: 'Generating Predictions...',
        backgroundColor: Colors.blue.shade600,
        semanticLabel: 'Generate energy bill predictions based on your input data',
        tooltip: 'Click to generate your personalized energy forecast',
      ),
    );
  }

  Widget _buildPredictionsTab() {
    if (_predictionResult == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.trending_up, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Generate predictions first',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Go to the "Input Your Data" tab to get started',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNextMonthForecast(),
          const SizedBox(height: 24),
          _buildDeviceUsageChart(),
          const SizedBox(height: 24),
          // Lithuanian comparison widget
          LithuanianComparisonWidget(
            userMonthlyConsumption: _predictionResult!.nextMonth.usage.toDouble(),
            userHomeArea: double.tryParse(_homeAreaController.text) ?? 0,
          ),
          const SizedBox(height: 24),
          _buildNext3MonthsForecast(),
          const SizedBox(height: 24),
          _buildNextYearForecast(),
        ],
      ),
    );
  }

  Widget _buildNextMonthForecast() {
    final nextMonth = _predictionResult!.nextMonth;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Month Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildForecastCard(
                    'Total Cost',
                    '€${nextMonth.cost.toStringAsFixed(2)}',
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildForecastCard(
                    'Expected Usage',
                    '${nextMonth.usage} kWh',
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child:                     Text(
                      'Confidence Range: €${nextMonth.confidenceRange?.min.toStringAsFixed(2) ?? 'N/A'} - €${nextMonth.confidenceRange?.max.toStringAsFixed(2) ?? 'N/A'}',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getComparisonColor(nextMonth.vsAverage ?? '0%').withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getComparisonColor(nextMonth.vsAverage ?? '0%')),
              ),
              child: Row(
                children: [
                  Icon(
                    _getComparisonIcon(nextMonth.vsAverage ?? '0%'),
                    color: _getComparisonColor(nextMonth.vsAverage ?? '0%'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${nextMonth.vsAverage ?? 'N/A'} compared to average Lithuanian household',
                    style: TextStyle(
                      color: _getComparisonColor(nextMonth.vsAverage ?? '0%'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceUsageChart() {
    final chartData = _generateDeviceUsageData();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Usage Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 250,
                    child: chartData.isEmpty 
                        ? const Center(child: Text('No data available'))
                        : PieChart(
                            PieChartData(
                              sections: chartData.map((data) => PieChartSectionData(
                                color: data.color,
                                value: data.percentage > 0 ? data.percentage : 0.1, // Ensure minimum value
                                title: data.percentage > 0 ? '${data.percentage.toStringAsFixed(1)}%' : '',
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )).toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: chartData.map((data) => _buildLegendItem(data)).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(DeviceUsageData data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: data.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(data.icon, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${data.kwh} kWh',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DeviceUsageData> _generateDeviceUsageData() {
    final data = <DeviceUsageData>[];
    final totalUsage = _predictionResult!.nextMonth.usage;
    
    // Ensure totalUsage is not zero to avoid division by zero
    if (totalUsage <= 0) {
      return [DeviceUsageData(
        name: 'No Data',
        kwh: 0,
        percentage: 100.0,
        color: Colors.grey.shade400,
        icon: Icons.info,
      )];
    }
    
    // Base usage (non-appliance)
    final baseUsage = totalUsage * 0.4; // Assume 40% base usage
    data.add(DeviceUsageData(
      name: 'Base Usage',
      kwh: baseUsage.round(),
      percentage: (baseUsage / totalUsage * 100),
      color: Colors.grey.shade400,
      icon: Icons.home,
    ));
    
    // Selected appliances
    final applianceWatts = {
      'Electric heating (winter usage)': 800,
      'Air conditioning (summer usage)': 150,
      'EV charger': 300,
      'Electric water heater': 100,
      'Other high-consumption appliances': 200,
    };
    
    final applianceIcons = {
      'Electric heating (winter usage)': Icons.thermostat,
      'Air conditioning (summer usage)': Icons.ac_unit,
      'EV charger': Icons.electric_car,
      'Electric water heater': Icons.water_drop,
      'Other high-consumption appliances': Icons.power,
    };
    
    final colors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
    ];
    
    int colorIndex = 0;
    for (final appliance in _selectedAppliances) {
      if (applianceWatts.containsKey(appliance)) {
        final watts = applianceWatts[appliance]!;
        final kwh = (watts * 0.73).round(); // Convert watts to monthly kWh
        final percentage = (kwh / totalUsage * 100);
        
        data.add(DeviceUsageData(
          name: appliance,
          kwh: kwh,
          percentage: percentage,
          color: colors[colorIndex % colors.length],
          icon: applianceIcons[appliance] ?? Icons.device_unknown,
        ));
        colorIndex++;
      }
    }
    
    // Custom appliances
    for (final customAppliance in _customAppliances) {
      final kwh = (customAppliance.watts * 0.73).round();
      final percentage = (kwh / totalUsage * 100);
      
      data.add(DeviceUsageData(
        name: customAppliance.name,
        kwh: kwh,
        percentage: percentage,
        color: colors[colorIndex % colors.length],
        icon: customAppliance.icon,
      ));
      colorIndex++;
    }
    
    return data;
  }

  Widget _buildNext3MonthsForecast() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next 3 Months',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ..._predictionResult!.next3Months.map((month) => ListTile(
              title: Text(month.month),
              subtitle: Text('${month.usage} kWh'),
              trailing: Text(
                '€${month.cost.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNextYearForecast() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Year Annual Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildForecastCard(
                    'Total Annual Cost',
                    '€${_predictionResult!.nextYear.totalCost.toStringAsFixed(2)}',
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildForecastCard(
                    'Average Monthly',
                    '€${_predictionResult!.nextYear.avgMonthlyCost.toStringAsFixed(2)}',
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Monthly Breakdown:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // TODO: Add interactive chart here
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Interactive chart coming soon'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab() {
    if (_predictionResult == null) {
      // Show educational content when no predictions generated
      return EducationalContent(
        onGetStartedPressed: () {
          // Navigate to Input Your Data tab
          _tabController.animateTo(0);
        },
      );
    }

    // Show personalized insights when predictions are available
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAIInsightsCard(),
          const SizedBox(height: 16),
          _buildInsightsCard(),
          const SizedBox(height: 16),
          _buildTipsCard(),
          const SizedBox(height: 16),
          _buildComparisonCard(),
          const SizedBox(height: 24),
          _buildCollapsibleEducationalContent(),
        ],
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'AI-Powered Insights',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Icon(Icons.psychology, color: Colors.purple.shade600, size: 24),
                const Spacer(),
                if (_isGeneratingInsights)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (_aiInsights.isEmpty)
                  DebouncedIconButton(
                    icon: Icon(Icons.refresh, color: Colors.blue.shade600),
                    onPressed: _generateAIInsights,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isGeneratingInsights)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Generating personalized AI insights...'),
                    ],
                  ),
                ),
              )
            else if (_aiInsights.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.psychology, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'AI insights not generated yet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Click the refresh button to generate personalized insights based on your data.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._aiInsights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.purple.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(insight)),
                    ],
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Insights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ..._predictionResult!.insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.trending_up, color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(insight)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Energy-Saving Tips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              Icons.thermostat,
              'Optimize Heating',
              'Set your thermostat to 20°C during the day and 18°C at night. Each degree lower saves 6% on heating costs.',
            ),
            _buildTipItem(
              Icons.schedule,
              'Time Your Usage',
              'Run high-consumption appliances during off-peak hours (usually 10 PM - 6 AM) to save up to 30%.',
            ),
            _buildTipItem(
              Icons.lightbulb,
              'LED Lighting',
              'Replace incandescent bulbs with LEDs to reduce lighting costs by 80%.',
            ),
            _buildTipItem(
              Icons.home_repair_service,
              'Improve Insulation',
              'Proper insulation can reduce heating costs by 20-30%. Check windows and doors for drafts.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Household Comparison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your household vs. Lithuanian averages:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow('Monthly Usage', '${_monthlyUsageController.text} kWh', '350 kWh'),
            _buildComparisonRow('Home Area', '${_homeAreaController.text} m²', '100 m²'),
            _buildComparisonRow('Major Appliances', '${_selectedAppliances.length}', '2.1 average'),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String yourValue, String averageValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(yourValue, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          Text('vs $averageValue', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Color _getComparisonColor(String comparison) {
    if (comparison.contains('+')) return Colors.red;
    if (comparison.contains('-')) return Colors.green;
    return Colors.orange;
  }

  IconData _getComparisonIcon(String comparison) {
    if (comparison.contains('+')) return Icons.trending_up;
    if (comparison.contains('-')) return Icons.trending_down;
    return Icons.trending_flat;
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Bill Entry'),
        content: const Text('Manual entry feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePredictions() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get form data
      final monthlyUsage = int.parse(_monthlyUsageController.text);
      final homeArea = int.parse(_homeAreaController.text);
      
      // Generate predictions using the real algorithm
      final result = await PredictionEngine.generatePredictions(
        monthlyUsage: monthlyUsage,
        homeArea: homeArea,
        appliances: _selectedAppliances,
        historicalBills: _historicalBills,
      );

      setState(() {
        _predictionResult = result;
        _isLoading = false;
      });

      // Generate AI insights
      _generateAIInsights();

      // Switch to predictions tab
      _tabController.animateTo(1);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating predictions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _generateAIInsights() async {
    if (_predictionResult == null) return;
    
    setState(() {
      _isGeneratingInsights = true;
    });

    try {
      // Safely parse the text fields with fallback values
      final monthlyUsage = int.tryParse(_monthlyUsageController.text) ?? 0;
      final homeArea = int.tryParse(_homeAreaController.text) ?? 0;
      
      // Only proceed if we have valid data
      if (monthlyUsage <= 0 || homeArea <= 0) {
        setState(() {
          _isGeneratingInsights = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid usage and home area data first'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      final insights = await AIInsightsService.generateInsights(
        monthlyUsage: monthlyUsage,
        homeArea: homeArea,
        selectedAppliances: _selectedAppliances,
        customAppliances: _customAppliances,
        predictionResult: _predictionResult!,
      );

      setState(() {
        _aiInsights = insights;
        _isGeneratingInsights = false;
      });
    } catch (e) {
      setState(() {
        _isGeneratingInsights = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating AI insights: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildCollapsibleEducationalContent() {
    return Card(
      child: ExpansionTile(
        title: const Text(
          'Learn More About Electricity Usage',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Educational content about Lithuanian electricity'),
        leading: Icon(Icons.school, color: Colors.blue.shade600),
        children: [
          EducationalContent(
            onGetStartedPressed: () {
              // Navigate to Input Your Data tab
              _tabController.animateTo(0);
            },
          ),
        ],
      ),
    );
  }
}
