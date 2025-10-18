class PredictionService {
  static const double pricePerKwh = 0.18; // Lithuanian average price
  
  // Household size multipliers
  static const Map<int, double> householdMultipliers = {
    1: 0.7,
    2: 1.0,
    3: 1.2,
    4: 1.4,
    5: 1.6,
  };
  
  static List<MonthlyPrediction> generateMonthlyPredictions({
    required double baseUsage,
    required List<String> appliances,
    required int householdSize,
  }) {
    final householdMult = householdMultipliers[householdSize] ?? 1.0;
    final adjustedBase = baseUsage * householdMult;
    
    // Define 12 months with Lithuanian seasonal patterns
    final monthConfigs = [
      // WINTER - High heating demand
      MonthConfig('Nov 2025', 'winter', 1.4, true),
      MonthConfig('Dec 2025', 'winter', 1.6, true),
      MonthConfig('Jan 2026', 'winter', 1.7, true),
      MonthConfig('Feb 2026', 'winter', 1.7, true),
      MonthConfig('Mar 2026', 'winter', 1.5, true),
      
      // SPRING - Transitional
      MonthConfig('Apr 2026', 'spring', 1.2, false),
      MonthConfig('May 2026', 'spring', 1.0, false),
      
      // SUMMER - Low usage
      MonthConfig('Jun 2026', 'summer', 0.85, false),
      MonthConfig('Jul 2026', 'summer', 0.75, false),
      MonthConfig('Aug 2026', 'summer', 0.80, false),
      
      // FALL - Transitional
      MonthConfig('Sep 2026', 'fall', 1.0, false),
      MonthConfig('Oct 2026', 'fall', 1.3, true),
    ];
    
    List<MonthlyPrediction> predictions = [];
    
    for (var config in monthConfigs) {
      double monthlyUsage = adjustedBase * config.baseMultiplier;
      
      // Add appliance consumption
      if (appliances.contains('Electric heating (winter usage)') && config.heatingActive) {
        monthlyUsage += 800; // Major heating impact
      }
      
      if (appliances.contains('EV charger')) {
        monthlyUsage += 300; // Consistent EV usage
      }
      
      if (appliances.contains('Air conditioning (summer usage)') && config.season == 'summer') {
        monthlyUsage += 150; // AC only in summer
      }
      
      if (appliances.contains('Electric water heater')) {
        monthlyUsage += 100; // Consistent usage
      }
      
      if (appliances.contains('Other high-consumption appliances')) {
        monthlyUsage += 200; // Other appliances
      }
      
      final monthlyCost = monthlyUsage * pricePerKwh;
      
      predictions.add(MonthlyPrediction(
        month: config.month,
        usage: monthlyUsage.round(),
        cost: double.parse(monthlyCost.toStringAsFixed(2)),
        season: config.season,
      ));
    }
    
    return predictions;
  }
  
  static Map<String, ApplianceImpact> calculateApplianceImpact(List<String> appliances) {
    Map<String, ApplianceImpact> impacts = {};
    
    if (appliances.contains('Electric heating (winter usage)')) {
      impacts['Electric Heating'] = ApplianceImpact(
        name: 'Electric Heating',
        monthlyUsage: 800,
        monthlyCost: 144,
        annualCost: 1008, // 7 winter months
      );
    }
    
    if (appliances.contains('EV charger')) {
      impacts['EV Charger'] = ApplianceImpact(
        name: 'EV Charger',
        monthlyUsage: 300,
        monthlyCost: 54,
        annualCost: 648,
      );
    }
    
    if (appliances.contains('Air conditioning (summer usage)')) {
      impacts['Air Conditioning'] = ApplianceImpact(
        name: 'Air Conditioning',
        monthlyUsage: 150,
        monthlyCost: 27,
        annualCost: 81, // 3 summer months
      );
    }
    
    if (appliances.contains('Electric water heater')) {
      impacts['Water Heater'] = ApplianceImpact(
        name: 'Water Heater',
        monthlyUsage: 100,
        monthlyCost: 18,
        annualCost: 216,
      );
    }
    
    if (appliances.contains('Other high-consumption appliances')) {
      impacts['Other Appliances'] = ApplianceImpact(
        name: 'Other Appliances',
        monthlyUsage: 200,
        monthlyCost: 36,
        annualCost: 432,
      );
    }
    
    return impacts;
  }
}

// Helper classes
class MonthConfig {
  final String month;
  final String season;
  final double baseMultiplier;
  final bool heatingActive;
  
  MonthConfig(this.month, this.season, this.baseMultiplier, this.heatingActive);
}

class MonthlyPrediction {
  final String month;
  final int usage;
  final double cost;
  final String season;
  
  MonthlyPrediction({
    required this.month,
    required this.usage,
    required this.cost,
    required this.season,
  });
}

class ApplianceImpact {
  final String name;
  final int monthlyUsage;
  final double monthlyCost;
  final double annualCost;
  
  ApplianceImpact({
    required this.name,
    required this.monthlyUsage,
    required this.monthlyCost,
    required this.annualCost,
  });
}
