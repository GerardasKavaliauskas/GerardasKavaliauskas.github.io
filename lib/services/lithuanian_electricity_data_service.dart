import 'dart:convert';
import 'package:http/http.dart' as http;

class LithuanianElectricityDataService {
  // Lithuanian electricity consumption data API
  static const String _consumptionApiUrl = 'https://get.data.gov.lt/datasets/gov/eso/fiz_asm_elektros_suvartojimas/FizAsmElektraSuvartojimas';
  
  // ESO electricity pricing (you may need to scrape or find API endpoint)
  // static const String _pricingUrl = 'https://www.eso.lt/web/verslui/elektra/tarifai-kainos-atsiskaitymai-ir-skolos/elektros-kainos-sudedamosios-dalys/3846';

  /// Fetches Lithuanian household electricity consumption data
  static Future<List<LithuanianHouseholdData>> fetchHouseholdConsumptionData() async {
    try {
      final response = await http.get(
        Uri.parse(_consumptionApiUrl),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Flutter Bill Predictor App',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> records = data['_data'] ?? [];
        
        return records.map((record) => LithuanianHouseholdData.fromJson(record)).toList();
      } else {
        print('Failed to fetch Lithuanian data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching Lithuanian electricity data: $e');
      return [];
    }
  }

  /// Calculates average consumption statistics for Lithuanian households
  static Future<LithuanianAverageStats> calculateAverageStats() async {
    final data = await fetchHouseholdConsumptionData();
    
    if (data.isEmpty) {
      // Return fallback data if API fails
      return LithuanianAverageStats(
        averageMonthlyConsumption: 250.0, // kWh
        medianMonthlyConsumption: 220.0,
        averageHomeArea: 75.0, // m²
        totalHouseholds: 0,
        dataSource: 'Fallback data',
      );
    }

    final consumptions = data.map((d) => d.bendrasSuvartojimasKwh).toList();
    consumptions.sort();

    final average = consumptions.reduce((a, b) => a + b) / consumptions.length;
    final median = consumptions.length % 2 == 0
        ? (consumptions[consumptions.length ~/ 2 - 1] + consumptions[consumptions.length ~/ 2]) / 2
        : consumptions[consumptions.length ~/ 2];

    return LithuanianAverageStats(
      averageMonthlyConsumption: average.toDouble(),
      medianMonthlyConsumption: median.toDouble(),
      averageHomeArea: 75.0, // Estimated average Lithuanian home size
      totalHouseholds: data.length,
      dataSource: 'data.gov.lt API',
    );
  }

  /// Gets current Lithuanian electricity pricing (mock implementation)
  /// In a real app, you'd scrape the ESO website or use their API
  static Future<LithuanianElectricityPricing> getCurrentPricing() async {
    // Mock pricing data - in reality, you'd fetch from ESO
    return LithuanianElectricityPricing(
      basePricePerKwh: 0.12, // €/kWh
      distributionPricePerKwh: 0.08,
      transmissionPricePerKwh: 0.02,
      renewableEnergyPricePerKwh: 0.03,
      totalPricePerKwh: 0.25, // Total €/kWh
      currency: 'EUR',
      lastUpdated: DateTime.now(),
      source: 'ESO (mock data)',
    );
  }

  /// Compares user's consumption with Lithuanian averages
  static Future<ConsumptionComparison> compareWithLithuanianAverage({
    required double userMonthlyConsumption,
    required double userHomeArea,
  }) async {
    final stats = await calculateAverageStats();
    final pricing = await getCurrentPricing();

    final userConsumptionPerSqm = userHomeArea > 0 ? userMonthlyConsumption / userHomeArea : 0.0;
    final averageConsumptionPerSqm = stats.averageHomeArea > 0 
        ? stats.averageMonthlyConsumption / stats.averageHomeArea 
        : 0.0;

    final consumptionDifference = userMonthlyConsumption - stats.averageMonthlyConsumption;
    final consumptionPercentage = stats.averageMonthlyConsumption > 0 
        ? (consumptionDifference / stats.averageMonthlyConsumption) * 100 
        : 0.0;

    final efficiencyRating = _calculateEfficiencyRating(
      userConsumptionPerSqm,
      averageConsumptionPerSqm,
    );

    final potentialSavings = consumptionDifference > 0 
        ? consumptionDifference * pricing.totalPricePerKwh * 12 // Annual savings
        : 0.0;

    return ConsumptionComparison(
      userConsumption: userMonthlyConsumption,
      lithuanianAverage: stats.averageMonthlyConsumption,
      lithuanianMedian: stats.medianMonthlyConsumption,
      consumptionDifference: consumptionDifference,
      consumptionPercentage: consumptionPercentage,
      efficiencyRating: efficiencyRating,
      potentialAnnualSavings: potentialSavings,
      userConsumptionPerSqm: userConsumptionPerSqm,
      averageConsumptionPerSqm: averageConsumptionPerSqm,
      comparisonMessage: _generateComparisonMessage(
        consumptionPercentage,
        efficiencyRating,
        potentialSavings,
      ),
    );
  }

  static EfficiencyRating _calculateEfficiencyRating(
    double userConsumptionPerSqm,
    double averageConsumptionPerSqm,
  ) {
    if (averageConsumptionPerSqm == 0) return EfficiencyRating.average;
    
    final ratio = userConsumptionPerSqm / averageConsumptionPerSqm;
    
    if (ratio < 0.8) return EfficiencyRating.excellent;
    if (ratio < 1.0) return EfficiencyRating.good;
    if (ratio < 1.2) return EfficiencyRating.average;
    if (ratio < 1.5) return EfficiencyRating.belowAverage;
    return EfficiencyRating.poor;
  }

  static String _generateComparisonMessage(
    double consumptionPercentage,
    EfficiencyRating rating,
    double potentialSavings,
  ) {
    if (rating == EfficiencyRating.excellent) {
      return 'Excellent! Your energy consumption is ${consumptionPercentage.abs().toStringAsFixed(1)}% lower than the average Lithuanian household.';
    } else if (rating == EfficiencyRating.good) {
      return 'Good! Your consumption is ${consumptionPercentage.abs().toStringAsFixed(1)}% lower than average.';
    } else if (rating == EfficiencyRating.average) {
      return 'Your energy consumption matches the average Lithuanian household level.';
    } else if (rating == EfficiencyRating.belowAverage) {
      return 'Your consumption is ${consumptionPercentage.toStringAsFixed(1)}% higher than average.';
    } else {
      return 'Your energy consumption is ${consumptionPercentage.toStringAsFixed(1)}% higher than average. You can save up to €${potentialSavings.toStringAsFixed(0)} per year.';
    }
  }
}

class LithuanianHouseholdData {
  final String recordId;
  final String clientId;
  final String objectId;
  final String municipality;
  final String gender;
  final DateTime birthYear;
  final DateTime validFrom;
  final DateTime? validTo;
  final DateTime accountingMonth;
  final double receivedKwh;
  final double consumedKwh;
  final double bendrasSuvartojimasKwh;
  final String? dataProvider;
  final String clientMunicipality;
  final bool ngv;
  final String automatedAccounting;
  final String voltageLevel;
  final double voltageKv;
  final double allowedPowerKw;
  final double allowedGenerationPower;
  final double installedGenerationPower;
  final String objectManufacturerType;

  LithuanianHouseholdData({
    required this.recordId,
    required this.clientId,
    required this.objectId,
    required this.municipality,
    required this.gender,
    required this.birthYear,
    required this.validFrom,
    this.validTo,
    required this.accountingMonth,
    required this.receivedKwh,
    required this.consumedKwh,
    required this.bendrasSuvartojimasKwh,
    this.dataProvider,
    required this.clientMunicipality,
    required this.ngv,
    required this.automatedAccounting,
    required this.voltageLevel,
    required this.voltageKv,
    required this.allowedPowerKw,
    required this.allowedGenerationPower,
    required this.installedGenerationPower,
    required this.objectManufacturerType,
  });

  factory LithuanianHouseholdData.fromJson(Map<String, dynamic> json) {
    return LithuanianHouseholdData(
      recordId: json['iraso_id'] ?? '',
      clientId: json['kliento_id'] ?? '',
      objectId: json['objekto_id'] ?? '',
      municipality: json['objekto_savivaldybe'] ?? '',
      gender: json['lytis'] ?? '',
      birthYear: DateTime.tryParse(json['gimimo_metai'] ?? '') ?? DateTime(1970),
      validFrom: DateTime.tryParse(json['obj_galioja_nuo'] ?? '') ?? DateTime.now(),
      validTo: json['obj_galioja_iki'] != null ? DateTime.tryParse(json['obj_galioja_iki']) : null,
      accountingMonth: DateTime.tryParse(json['apskaitos_men'] ?? '') ?? DateTime.now(),
      receivedKwh: (json['atgauta_kwh'] ?? 0.0).toDouble(),
      consumedKwh: (json['suvartota_kwh'] ?? 0.0).toDouble(),
      bendrasSuvartojimasKwh: (json['bendras_suvartojimas_kwh'] ?? 0.0).toDouble(),
      dataProvider: json['duomenis_pateike'],
      clientMunicipality: json['kliento_savivaldybe'] ?? '',
      ngv: json['ngv'] ?? false,
      automatedAccounting: json['automatizuota_apskaita'] ?? '',
      voltageLevel: json['obj_itampos_lygis'] ?? '',
      voltageKv: (json['obj_itampa_kv'] ?? 0.0).toDouble(),
      allowedPowerKw: (json['leistina_galia_kw'] ?? 0.0).toDouble(),
      allowedGenerationPower: (json['leistina_generuoti_galia'] ?? 0.0).toDouble(),
      installedGenerationPower: (json['instaliuota_generuoti_galia'] ?? 0.0).toDouble(),
      objectManufacturerType: json['objekto_gamintojo_tipas'] ?? '',
    );
  }
}

class LithuanianAverageStats {
  final double averageMonthlyConsumption;
  final double medianMonthlyConsumption;
  final double averageHomeArea;
  final int totalHouseholds;
  final String dataSource;

  LithuanianAverageStats({
    required this.averageMonthlyConsumption,
    required this.medianMonthlyConsumption,
    required this.averageHomeArea,
    required this.totalHouseholds,
    required this.dataSource,
  });
}

class LithuanianElectricityPricing {
  final double basePricePerKwh;
  final double distributionPricePerKwh;
  final double transmissionPricePerKwh;
  final double renewableEnergyPricePerKwh;
  final double totalPricePerKwh;
  final String currency;
  final DateTime lastUpdated;
  final String source;

  LithuanianElectricityPricing({
    required this.basePricePerKwh,
    required this.distributionPricePerKwh,
    required this.transmissionPricePerKwh,
    required this.renewableEnergyPricePerKwh,
    required this.totalPricePerKwh,
    required this.currency,
    required this.lastUpdated,
    required this.source,
  });
}

class ConsumptionComparison {
  final double userConsumption;
  final double lithuanianAverage;
  final double lithuanianMedian;
  final double consumptionDifference;
  final double consumptionPercentage;
  final EfficiencyRating efficiencyRating;
  final double potentialAnnualSavings;
  final double userConsumptionPerSqm;
  final double averageConsumptionPerSqm;
  final String comparisonMessage;

  ConsumptionComparison({
    required this.userConsumption,
    required this.lithuanianAverage,
    required this.lithuanianMedian,
    required this.consumptionDifference,
    required this.consumptionPercentage,
    required this.efficiencyRating,
    required this.potentialAnnualSavings,
    required this.userConsumptionPerSqm,
    required this.averageConsumptionPerSqm,
    required this.comparisonMessage,
  });
}

enum EfficiencyRating {
  excellent,
  good,
  average,
  belowAverage,
  poor,
}
