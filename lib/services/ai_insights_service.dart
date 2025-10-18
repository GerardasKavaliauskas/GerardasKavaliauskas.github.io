// import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../core/models.dart';
import 'lithuanian_electricity_data_service.dart';

class AIInsightsService {
  // You can replace this with your actual API key
  // static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';
  // static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<List<String>> generateInsights({
    required int monthlyUsage,
    required int homeArea,
    required Set<String> selectedAppliances,
    required List<CustomAppliance> customAppliances,
    required PredictionResult predictionResult,
  }) async {
    try {
      // For demo purposes, we'll generate mock AI insights
      // In a real implementation, you would call the OpenAI API here
      return _generateMockInsights(
        monthlyUsage: monthlyUsage,
        homeArea: homeArea,
        selectedAppliances: selectedAppliances,
        customAppliances: customAppliances,
        predictionResult: predictionResult,
      );
    } catch (e) {
      // Fallback to basic insights if AI service fails
      return _generateBasicInsights(
        monthlyUsage: monthlyUsage,
        homeArea: homeArea,
        selectedAppliances: selectedAppliances,
        customAppliances: customAppliances,
        predictionResult: predictionResult,
      );
    }
  }

  static List<String> _generateMockInsights({
    required int monthlyUsage,
    required int homeArea,
    required Set<String> selectedAppliances,
    required List<CustomAppliance> customAppliances,
    required PredictionResult predictionResult,
  }) {
    final insights = <String>[];
    
    // Add Lithuanian context (async call would be better, but this is mock)
    _addLithuanianContext(insights, monthlyUsage, homeArea);
    
    // Analyze usage patterns
    if (monthlyUsage > 500) {
      insights.add('🔍 Your monthly usage of ${monthlyUsage}kWh is above average. Consider implementing energy-saving measures to reduce costs.');
    } else if (monthlyUsage < 300) {
      insights.add('✅ Great job! Your monthly usage of ${monthlyUsage}kWh is below average, indicating efficient energy consumption.');
    }

    // Analyze home size vs usage
    final usagePerSqm = monthlyUsage / homeArea;
    if (usagePerSqm > 4) {
      insights.add('🏠 Your energy usage per square meter (${usagePerSqm.toStringAsFixed(1)} kWh/m²) is high. Consider improving insulation or upgrading appliances.');
    }

    // Analyze appliances
    if (selectedAppliances.contains('Electric heating (winter usage)')) {
      insights.add('🔥 Electric heating is your largest energy consumer. Consider using a programmable thermostat and improving home insulation.');
    }
    
    if (selectedAppliances.contains('EV charger')) {
      insights.add('🚗 Your EV charger adds significant load. Consider charging during off-peak hours (10 PM - 6 AM) to save up to 30% on costs.');
    }

    // Custom appliances analysis
    if (customAppliances.isNotEmpty) {
      final totalCustomWatts = customAppliances.fold(0, (sum, appliance) => sum + appliance.watts);
      if (totalCustomWatts > 1000) {
        insights.add('⚡ Your custom devices (${totalCustomWatts}W total) consume significant energy. Consider scheduling their usage during off-peak hours.');
      }
    }

    // Seasonal insights
    final currentMonth = DateTime.now().month;
    if (currentMonth >= 11 || currentMonth <= 3) {
      insights.add('❄️ Winter months typically see 40-60% higher energy usage due to heating. Your current forecast accounts for this seasonal pattern.');
    } else if (currentMonth >= 6 && currentMonth <= 8) {
      insights.add('☀️ Summer months may see increased AC usage. Consider using fans and natural ventilation to reduce cooling costs.');
    }

    // Cost optimization
    final monthlyCost = predictionResult.nextMonth.cost;
    if (monthlyCost > 100) {
      insights.add('💰 Your projected monthly cost of €${monthlyCost.toStringAsFixed(2)} is significant. Implementing time-of-use scheduling could save 15-25%.');
    }

    // Efficiency recommendations
    insights.add('💡 Consider upgrading to ENERGY STAR certified appliances to reduce consumption by 10-50% depending on the device type.');
    
    if (homeArea > 150) {
      insights.add('🏡 For your ${homeArea}m² home, consider zone heating/cooling to only condition occupied areas, potentially saving 20-30% on energy costs.');
    }

    return insights;
  }

  static List<String> _generateBasicInsights({
    required int monthlyUsage,
    required int homeArea,
    required Set<String> selectedAppliances,
    required List<CustomAppliance> customAppliances,
    required PredictionResult predictionResult,
  }) {
    return [
      '📊 Your energy usage analysis is complete. Consider implementing the recommended energy-saving measures.',
      '💡 Regular maintenance of appliances can improve efficiency by 5-15%.',
      '⏰ Using appliances during off-peak hours can significantly reduce your electricity costs.',
    ];
  }

  // Real OpenAI API implementation (commented out for demo)
  /*
  static Future<List<String>> _callOpenAI({
    required int monthlyUsage,
    required int homeArea,
    required Set<String> selectedAppliances,
    required List<CustomAppliance> customAppliances,
    required PredictionResult predictionResult,
  }) async {
    final prompt = _buildPrompt(
      monthlyUsage: monthlyUsage,
      homeArea: homeArea,
      selectedAppliances: selectedAppliances,
      customAppliances: customAppliances,
      predictionResult: predictionResult,
    );

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an energy efficiency expert providing personalized insights for Lithuanian households.',
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return content.split('\n').where((line) => line.trim().isNotEmpty).toList();
    } else {
      throw Exception('Failed to generate AI insights: ${response.statusCode}');
    }
  }

  static String _buildPrompt({
    required int monthlyUsage,
    required int homeArea,
    required Set<String> selectedAppliances,
    required List<CustomAppliance> customAppliances,
    required PredictionResult predictionResult,
  }) {
    return '''
    Analyze this Lithuanian household's energy usage and provide 5-7 personalized insights and tips:

    Monthly Usage: ${monthlyUsage} kWh
    Home Area: ${homeArea} m²
    Selected Appliances: ${selectedAppliances.join(', ')}
    Custom Appliances: ${customAppliances.map((a) => '${a.name} (${a.watts}W)').join(', ')}
    Projected Monthly Cost: €${predictionResult.nextMonth.cost.toStringAsFixed(2)}
    Projected Usage: ${predictionResult.nextMonth.usage} kWh

    Provide specific, actionable insights for energy savings in Lithuania, considering:
    - Seasonal patterns (winter heating, summer cooling)
    - Time-of-use pricing
    - Home size and efficiency
    - Appliance usage patterns
    - Cost optimization opportunities

    Format each insight as a concise bullet point with an emoji.
    ''';
  }
  */

  static void _addLithuanianContext(List<String> insights, int monthlyUsage, int homeArea) {
    // Mock Lithuanian average (in reality, this would come from the API)
    const double lithuanianAverage = 250.0; // kWh per month
    const double lithuanianAverageHomeSize = 75.0; // m²
    
    final consumptionDifference = monthlyUsage - lithuanianAverage;
    final consumptionPercentage = (consumptionDifference / lithuanianAverage) * 100;
    
    if (consumptionPercentage > 20) {
      insights.add('🇱🇹 Your consumption is ${consumptionPercentage.toStringAsFixed(1)}% higher than the average Lithuanian household (${lithuanianAverage.toStringAsFixed(0)} kWh/month).');
    } else if (consumptionPercentage < -20) {
      insights.add('🇱🇹 Excellent! Your consumption is ${consumptionPercentage.abs().toStringAsFixed(1)}% lower than the average Lithuanian household.');
    } else {
      insights.add('🇱🇹 Your energy consumption matches the average Lithuanian household level.');
    }
    
    // Calculate potential savings
    if (consumptionDifference > 0) {
      const double averagePricePerKwh = 0.25; // €/kWh (Lithuanian average)
      final annualSavings = consumptionDifference * averagePricePerKwh * 12;
      insights.add('💰 By optimizing your energy consumption, you can save up to €${annualSavings.toStringAsFixed(0)} per year.');
    }
  }
}
