import 'package:flutter/material.dart';

class MonthlyBreakdownSection extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  
  const MonthlyBreakdownSection({
    Key? key,
    required this.monthlyData,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Detailed month-by-month cost and usage analysis',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  columns: const [
                    DataColumn(
                      label: Text('Month'),
                      numeric: false,
                    ),
                    DataColumn(
                      label: Text('Usage (kWh)'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Cost (€)'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Season'),
                      numeric: false,
                    ),
                  ],
                  rows: monthlyData.map((month) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            month['month'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${month['usage'] ?? 0}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            '€${(month['cost'] ?? 0.0).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                        DataCell(_buildSeasonBadge(month['season'] ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSeasonBadge(String season) {
    Color color;
    switch (season) {
      case 'winter':
        color = Colors.blue.shade600;
        break;
      case 'summer':
        color = Colors.orange.shade600;
        break;
      case 'spring':
        color = Colors.green.shade600;
        break;
      case 'fall':
        color = Colors.purple.shade600;
        break;
      default:
        color = Colors.grey.shade600;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        season.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
