import 'package:intl/intl.dart';
import '../core/models.dart';
import 'lithuanian_energy_data.dart';

class PredictionEngine {
  /// Generate energy bill predictions based on user input and market data
  static Future<PredictionResult> generatePredictions({
    required int monthlyUsage,
    required int homeArea,
    required Set<String> appliances,
    required List<HistoricalBill> historicalBills,
  }) async {
    // Fetch current market data
    final marketData = await LithuanianEnergyDataService.getCurrentMarketData();
    final householdAverages = await LithuanianEnergyDataService.getHouseholdAverages();
    
    // Calculate baseline consumption with home area multiplier
    final areaMultiplier = _getAreaMultiplier(homeArea);
    final baselineConsumption = monthlyUsage * areaMultiplier;
    
    // Add appliance consumption
    final applianceConsumption = _calculateApplianceConsumption(appliances);
    
    // Apply seasonal factors
    final currentMonth = DateTime.now().month;
    final seasonalFactor = _getSeasonalFactor(currentMonth);
    
    // Calculate total consumption for next month
    final totalConsumption = (baselineConsumption + applianceConsumption) * seasonalFactor;
    
    // Calculate cost
    final monthlyCost = totalConsumption * marketData.currentPrice;
    
    // Generate predictions
    final nextMonth = MonthPrediction(
      month: _getNextMonthName(),
      cost: monthlyCost,
      usage: totalConsumption.round(),
      confidenceRange: ConfidenceRange(
        monthlyCost * 0.9, // -10%
        monthlyCost * 1.1, // +10%
      ),
      vsAverage: _calculateComparison(totalConsumption, householdAverages.getAverageForArea(homeArea)),
    );
    
    // Generate 3-month forecast
    final next3Months = <MonthPrediction>[];
    for (int i = 1; i <= 3; i++) {
      final futureMonth = DateTime.now().add(Duration(days: 30 * i));
      final monthFactor = _getSeasonalFactor(futureMonth.month);
      final monthConsumption = (baselineConsumption + applianceConsumption) * monthFactor;
      final monthCost = monthConsumption * marketData.currentPrice;
      
      next3Months.add(MonthPrediction(
        month: DateFormat('yyyy-MM').format(futureMonth),
        cost: monthCost,
        usage: monthConsumption.round(),
      ));
    }
    
    // Generate yearly forecast
    final yearlyBreakdown = <MonthPrediction>[];
    double totalYearlyCost = 0;
    
    for (int i = 1; i <= 12; i++) {
      final futureMonth = DateTime.now().add(Duration(days: 30 * i));
      final monthFactor = _getSeasonalFactor(futureMonth.month);
      final monthConsumption = (baselineConsumption + applianceConsumption) * monthFactor;
      final monthCost = monthConsumption * marketData.currentPrice;
      
      yearlyBreakdown.add(MonthPrediction(
        month: DateFormat('yyyy-MM').format(futureMonth),
        cost: monthCost,
        usage: monthConsumption.round(),
      ));
      
      totalYearlyCost += monthCost;
    }
    
    final nextYear = YearPrediction(
      totalCost: totalYearlyCost,
      avgMonthlyCost: totalYearlyCost / 12,
      monthlyBreakdown: yearlyBreakdown,
    );
    
    // Generate insights
    final insights = _generateInsights(
      totalConsumption,
      householdAverages.getAverageForArea(homeArea),
      appliances,
      monthlyCost,
    );
    
    return PredictionResult(
      nextMonth: nextMonth,
      next3Months: next3Months,
      nextYear: nextYear,
      insights: insights,
    );
  }
  
  static double _getAreaMultiplier(int homeArea) {
    // Area-based multipliers for Lithuanian homes
    if (homeArea <= 50) {
      return 0.7; // Small apartments
    } else if (homeArea <= 80) {
      return 1.0; // Average apartments
    } else if (homeArea <= 120) {
      return 1.2; // Large apartments/small houses
    } else if (homeArea <= 200) {
      return 1.4; // Medium houses
    } else {
      return 1.6; // Large houses
    }
  }
  
  static double _calculateApplianceConsumption(Set<String> appliances) {
    double totalConsumption = 0;
    
    for (final appliance in appliances) {
      switch (appliance) {
        case 'Electric heating (winter usage)':
          // Only add in winter months (Oct-Apr)
          final currentMonth = DateTime.now().month;
          if (currentMonth >= 10 || currentMonth <= 4) {
            totalConsumption += 800;
          }
          break;
        case 'Air conditioning (summer usage)':
          // Only add in summer months (Jun-Aug)
          final currentMonth = DateTime.now().month;
          if (currentMonth >= 6 && currentMonth <= 8) {
            totalConsumption += 150;
          }
          break;
        case 'EV charger':
          totalConsumption += 300;
          break;
        case 'Electric water heater':
          totalConsumption += 100;
          break;
        case 'Other high-consumption appliances':
          totalConsumption += 200;
          break;
      }
    }
    
    return totalConsumption;
  }
  
  static double _getSeasonalFactor(int month) {
    // Lithuanian seasonal energy consumption factors
    switch (month) {
      case 10:
      case 11:
      case 12:
      case 1:
      case 2:
      case 3:
      case 4:
        return 1.3; // Winter - heating season
      case 6:
      case 7:
      case 8:
        return 0.8; // Summer - lower heating demand
      case 5:
      case 9:
        return 1.0; // Transition seasons
      default:
        return 1.0;
    }
  }
  
  static String _getNextMonthName() {
    final nextMonth = DateTime.now().add(const Duration(days: 30));
    return DateFormat('yyyy-MM').format(nextMonth);
  }
  
  static String _calculateComparison(double userConsumption, double averageConsumption) {
    final percentage = ((userConsumption - averageConsumption) / averageConsumption) * 100;
    if (percentage > 0) {
      return '+${percentage.toStringAsFixed(0)}%';
    } else {
      return '${percentage.toStringAsFixed(0)}%';
    }
  }
  
  static List<String> _generateInsights(
    double totalConsumption,
    double averageConsumption,
    Set<String> appliances,
    double monthlyCost,
  ) {
    final insights = <String>[];
    
    // Consumption comparison
    final percentage = ((totalConsumption - averageConsumption) / averageConsumption) * 100;
    if (percentage > 15) {
      insights.add('Your consumption is ${percentage.toStringAsFixed(0)}% above average for your home size');
    } else if (percentage < -15) {
      insights.add('Great! Your consumption is ${(-percentage).toStringAsFixed(0)}% below average');
    } else {
      insights.add('Your consumption is close to the Lithuanian average for your home size');
    }
    
    // Seasonal insights
    final currentMonth = DateTime.now().month;
    if (currentMonth >= 10 || currentMonth <= 4) {
      insights.add('Winter heating season may increase your bills by 25-30%');
    } else if (currentMonth >= 6 && currentMonth <= 8) {
      insights.add('Summer cooling costs are typically lower than winter heating');
    }
    
    // Appliance-specific insights
    if (appliances.contains('Electric heating (winter usage)')) {
      insights.add('Electric heating significantly impacts winter bills - consider insulation improvements');
    }
    if (appliances.contains('EV charger')) {
      insights.add('Schedule EV charging during off-peak hours (10 PM - 6 AM) to save up to 30%');
    }
    if (appliances.contains('Air conditioning (summer usage)')) {
      insights.add('Set AC to 24°C and use fans to reduce cooling costs by 20%');
    }
    
    // Cost insights
    if (monthlyCost > 150) {
      insights.add('High monthly costs detected - consider energy efficiency improvements');
    } else if (monthlyCost < 80) {
      insights.add('Excellent energy efficiency! You\'re well below average costs');
    }
    
    return insights;
  }
}
