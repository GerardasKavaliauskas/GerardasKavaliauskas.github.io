import 'package:flutter/material.dart';
import 'enhanced_button.dart';

class EducationalContent extends StatelessWidget {
  final VoidCallback? onGetStartedPressed;
  
  const EducationalContent({
    super.key,
    this.onGetStartedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeMessage(context),
          const SizedBox(height: 24),
          _buildCostBreakdown(context),
          const SizedBox(height: 24),
          _buildHouseholdAverages(context),
          const SizedBox(height: 24),
          _buildSeasonalPatterns(context),
          const SizedBox(height: 24),
          _buildApplianceGuide(context),
          const SizedBox(height: 24),
          _buildEnergySavingTips(context),
          const SizedBox(height: 24),
          _buildMarketInsights(context),
          const SizedBox(height: 24),
          _buildQuickEstimator(context),
          const SizedBox(height: 24),
          _buildCTABanner(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade600, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Understanding Electricity in Lithuania',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Learn how electricity costs are calculated, what affects your bill, and discover proven ways to save money on your energy expenses.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
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
                  const Expanded(
                    child: Text(
                      'All data is sourced from VKEKK, Lithuanian Open Data Portal, and Statistics Lithuania',
                      style: TextStyle(fontSize: 14),
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

  Widget _buildCostBreakdown(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Your Electricity Bill is Calculated',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your electricity bill consists of several components, each with different costs:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCostComponent(
                    'Generation',
                    '45-50%',
                    '€0.08-0.10/kWh',
                    Colors.blue,
                    'Electricity production costs',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCostComponent(
                    'Distribution',
                    '25-30%',
                    '€0.04-0.06/kWh',
                    Colors.green,
                    'Local grid maintenance',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCostComponent(
                    'Transmission',
                    '10-15%',
                    '€0.02-0.03/kWh',
                    Colors.orange,
                    'High-voltage lines',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCostComponent(
                    'Taxes & Fees',
                    '15-20%',
                    '€0.03-0.04/kWh',
                    Colors.red,
                    'Government taxes',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Current Average Price in Lithuania',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€0.16-0.20 per kWh',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• 64% of electricity is imported\n• 32% from renewable sources (2023)\n• Connected to EU grid via Poland and Sweden',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostComponent(String title, String percentage, String cost, Color color, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 4),
          Text(percentage, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(cost, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHouseholdAverages(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Much Do Lithuanian Households Use?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Average Lithuanian household consumption:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildAverageRow('1 person', '2,000 kWh/year', '165 kWh/month', Colors.blue),
            _buildAverageRow('2 people', '3,000 kWh/year', '250 kWh/month', Colors.green),
            _buildAverageRow('3 people', '3,800 kWh/year', '315 kWh/month', Colors.orange),
            _buildAverageRow('4+ people', '4,500+ kWh/year', '375+ kWh/month', Colors.red),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Residential electricity represents 28% of total national consumption. Significant seasonal variation due to heating needs.',
                      style: TextStyle(fontSize: 14),
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

  Widget _buildAverageRow(String household, String yearly, String monthly, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(household, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(yearly, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          Text(monthly, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildSeasonalPatterns(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lithuania\'s Energy Seasons: What to Expect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSeasonCard(
              'Winter (October - April)',
              'Heating Season',
              'Bills can increase 40-60% compared to summer',
              '350-450 kWh/month',
              Colors.red,
              Icons.thermostat,
              [
                'Set thermostat to 19-21°C',
                'Use programmable thermostats',
                'Check insulation',
              ],
            ),
            const SizedBox(height: 12),
            _buildSeasonCard(
              'Summer (June - August)',
              'Cooling Season',
              'Bills typically 20-30% lower than annual average',
              '180-250 kWh/month',
              Colors.blue,
              Icons.ac_unit,
              [
                'Use natural ventilation',
                'Close blinds during peak sun',
                'Set AC to 24-26°C',
              ],
            ),
            const SizedBox(height: 12),
            _buildSeasonCard(
              'Transition (May, September)',
              'Moderate Period',
              'Best time to assess baseline usage',
              '250-300 kWh/month',
              Colors.green,
              Icons.balance,
              [
                'No heating or cooling needed',
                'Baseline consumption period',
                'Good time for energy audits',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonCard(String title, String subtitle, String description, String consumption, Color color, IconData icon, List<String> tips) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: color)),
                  ],
                ),
              ),
              Text(consumption, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(tip, style: const TextStyle(fontSize: 12))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildApplianceGuide(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s Using Your Electricity? Appliance Consumption Guide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Based on average rate of €0.18/kWh',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            ..._getApplianceData().map((appliance) => _buildApplianceRow(appliance)),
          ],
        ),
      ),
    );
  }

  Widget _buildApplianceRow(Map<String, dynamic> appliance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(appliance['icon'], color: appliance['color'], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appliance['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(appliance['usage'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(appliance['cost'], style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(appliance['percentage'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getApplianceData() {
    return [
      {
        'name': 'Electric heating (winter)',
        'usage': '600-1000 kWh/month',
        'cost': '€110-180',
        'percentage': '60-70% of bill',
        'icon': Icons.thermostat,
        'color': Colors.red,
      },
      {
        'name': 'EV charger',
        'usage': '250-350 kWh/month',
        'cost': '€45-63',
        'percentage': '30-40% of bill',
        'icon': Icons.electric_car,
        'color': Colors.blue,
      },
      {
        'name': 'Air conditioning (summer)',
        'usage': '100-200 kWh/month',
        'cost': '€18-36',
        'percentage': '15-25% of bill',
        'icon': Icons.ac_unit,
        'color': Colors.cyan,
      },
      {
        'name': 'Electric water heater',
        'usage': '80-120 kWh/month',
        'cost': '€14-22',
        'percentage': '10-15% of bill',
        'icon': Icons.water_drop,
        'color': Colors.blue,
      },
      {
        'name': 'Refrigerator',
        'usage': '40-60 kWh/month',
        'cost': '€7-11',
        'percentage': '5-8% of bill',
        'icon': Icons.kitchen,
        'color': Colors.grey,
      },
      {
        'name': 'Washing machine',
        'usage': '15-25 kWh/month',
        'cost': '€3-5',
        'percentage': '2-3% of bill',
        'icon': Icons.local_laundry_service,
        'color': Colors.purple,
      },
      {
        'name': 'TV & entertainment',
        'usage': '20-35 kWh/month',
        'cost': '€4-6',
        'percentage': '3-5% of bill',
        'icon': Icons.tv,
        'color': Colors.indigo,
      },
      {
        'name': 'Lighting',
        'usage': '15-30 kWh/month',
        'cost': '€3-5',
        'percentage': '2-4% of bill',
        'icon': Icons.lightbulb,
        'color': Colors.yellow,
      },
    ];
  }

  Widget _buildEnergySavingTips(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proven Ways to Reduce Your Electricity Bill',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTipCategory(
              'Heating & Cooling (Biggest Impact)',
              Icons.thermostat,
              Colors.red,
              [
                'Lower thermostat by 1°C = Save 5-7% on heating costs',
                'Use programmable thermostat: Save €15-30/month in winter',
                'Seal windows and doors: Reduce heating by 10-20%',
                'Clean AC filters monthly: Improve efficiency by 5-15%',
              ],
            ),
            const SizedBox(height: 16),
            _buildTipCategory(
              'High-Consumption Appliances',
              Icons.power,
              Colors.orange,
              [
                'Electric heating alternatives: Consider upgrading insulation (saves 20-40%)',
                'Water heater: Lower temperature to 50-55°C (saves 5-10%)',
                'Use washing machine at 30°C instead of 60°C: Save 40% per load',
                'Air-dry clothes instead of dryer: Save €5-10/month',
              ],
            ),
            const SizedBox(height: 16),
            _buildTipCategory(
              'Everyday Savings',
              Icons.lightbulb,
              Colors.green,
              [
                'Replace 10 bulbs with LED: Save €30-50/year',
                'Unplug devices on standby: Save 5-10% on bill',
                'Full loads only: Run dishwasher/washing machine when full',
                'Use laptop instead of desktop: Save 50-75% energy',
              ],
            ),
            const SizedBox(height: 16),
            _buildTipCategory(
              'Time-of-Use Strategies',
              Icons.schedule,
              Colors.blue,
              [
                'Shift heavy usage to off-peak (23:00-07:00)',
                'Run dishwasher, washing machine, charge EV during night hours',
                'Can save 20-30% on electricity costs with proper timing',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCategory(String title, IconData icon, Color color, List<String> tips) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(tip, style: const TextStyle(fontSize: 14))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMarketInsights(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Understanding Lithuania\'s Electricity Market',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Did You Know?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildMarketFact('Lithuania is part of the Baltic electricity market'),
            _buildMarketFact('Connected to EU grid via Poland and Sweden (NordBalt cable)'),
            _buildMarketFact('Electricity prices influenced by Nordic market and EU energy policies'),
            _buildMarketFact('Government initiatives for renewable energy expansion'),
            _buildMarketFact('Smart meter rollout ongoing (check if available in your area)'),
            _buildMarketFact('Potential for dynamic pricing in the future'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Data sources: VKEKK (regula.lt), Lithuanian Open Data Portal (data.gov.lt), Statistics Lithuania (osp.stat.gov.lt)',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketFact(String fact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(fact, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildQuickEstimator(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Estimate: How Much Could You Save?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select common savings actions to see potential savings:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSavingsOption('Lower heating by 1°C', 'Save 5-7%', Colors.red),
            _buildSavingsOption('Switch to LED bulbs', 'Save €3/month', Colors.yellow),
            _buildSavingsOption('Unplug standby devices', 'Save €5/month', Colors.green),
            _buildSavingsOption('Use cold water washing', 'Save €4/month', Colors.blue),
            _buildSavingsOption('Optimize AC usage', 'Save €8/month', Colors.cyan),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    'Potential Monthly Savings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€20-30 per month',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'That\'s €240-360 per year!',
                    style: TextStyle(fontSize: 16, color: Colors.green.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsOption(String action, String savings, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(action, style: const TextStyle(fontSize: 14))),
          Text(savings, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildCTABanner(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.trending_up, size: 48, color: Colors.blue.shade600),
            const SizedBox(height: 16),
            const Text(
              'Ready for Personalized Predictions?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get accurate cost forecasts based on your specific home and usage patterns.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            EnhancedPredictionButton(
              onPressed: onGetStartedPressed,
              text: 'Get Started with Predictions',
              icon: Icons.trending_up,
              backgroundColor: Colors.blue.shade600,
              semanticLabel: 'Navigate to input form to start energy predictions',
              tooltip: 'Click to begin creating your personalized energy forecast',
            ),
          ],
        ),
      ),
    );
  }
}
