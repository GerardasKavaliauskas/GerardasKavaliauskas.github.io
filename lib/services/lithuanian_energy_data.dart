import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LithuanianEnergyDataService {
  static const String _vkkekBaseUrl = 'https://www.regula.lt';
  // static const String _openDataBaseUrl = 'https://data.gov.lt'; // For future use
  static const String _statisticsBaseUrl = 'https://osp.stat.gov.lt';

  // Cache for market data
  static MarketData? _cachedMarketData;
  static DateTime? _lastFetchTime;
  static const Duration _cacheValidity = Duration(hours: 24);

  /// Fetch current electricity prices from VKEKK
  static Future<MarketData> getCurrentMarketData() async {
    // Return cached data if still valid
    if (_cachedMarketData != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheValidity) {
      return _cachedMarketData!;
    }

    try {
      // Try to fetch from VKEKK API
      final response = await http.get(
        Uri.parse('$_vkkekBaseUrl/api/electricity-prices'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cachedMarketData = _parseMarketData(data);
        _lastFetchTime = DateTime.now();
        return _cachedMarketData!;
      }
    } catch (e) {
      print('Error fetching from VKEKK: $e');
    }

    // Fallback to mock data if API fails
    return _getFallbackMarketData();
  }

  /// Fetch household consumption averages from Statistics Lithuania
  static Future<HouseholdAverages> getHouseholdAverages() async {
    try {
      final response = await http.get(
        Uri.parse('$_statisticsBaseUrl/api/household-energy-consumption'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseHouseholdAverages(data);
      }
    } catch (e) {
      print('Error fetching household averages: $e');
    }

    // Fallback to Lithuanian averages
    return HouseholdAverages(
      household1: 200,
      household2: 350,
      household3: 450,
      household4plus: 600,
      lastUpdated: DateTime.now(),
    );
  }

  /// Fetch historical price data
  static Future<List<PriceHistory>> getHistoricalPrices({int months = 12}) async {
    try {
      final endDate = DateTime.now();
      final startDate = DateTime(endDate.year, endDate.month - months, endDate.day);
      
      final response = await http.get(
        Uri.parse('$_vkkekBaseUrl/api/historical-prices?'
            'start=${DateFormat('yyyy-MM-dd').format(startDate)}&'
            'end=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parsePriceHistory(data);
      }
    } catch (e) {
      print('Error fetching historical prices: $e');
    }

    // Fallback to generated historical data
    return _generateHistoricalPrices(months);
  }

  static MarketData _parseMarketData(Map<String, dynamic> data) {
    return MarketData(
      currentPrice: (data['currentPrice'] ?? 0.18) as double,
      lastUpdated: DateTime.tryParse(data['lastUpdated'] ?? '') ?? DateTime.now(),
      historicalPrices: (data['historicalPrices'] as List?)
          ?.map((p) => PriceHistory(
                month: p['month'],
                price: (p['price'] ?? 0.18).toDouble(),
              ))
          .toList() ?? [],
      averageConsumption: HouseholdAverages(
        household1: (data['averageConsumption']?['household1'] ?? 200).toDouble(),
        household2: (data['averageConsumption']?['household2'] ?? 350).toDouble(),
        household3: (data['averageConsumption']?['household3'] ?? 450).toDouble(),
        household4plus: (data['averageConsumption']?['household4plus'] ?? 600).toDouble(),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  static HouseholdAverages _parseHouseholdAverages(Map<String, dynamic> data) {
    return HouseholdAverages(
      household1: (data['household1'] ?? 200).toDouble(),
      household2: (data['household2'] ?? 350).toDouble(),
      household3: (data['household3'] ?? 450).toDouble(),
      household4plus: (data['household4plus'] ?? 600).toDouble(),
      lastUpdated: DateTime.tryParse(data['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  static List<PriceHistory> _parsePriceHistory(List<dynamic> data) {
    return data.map((item) => PriceHistory(
      month: item['month'] ?? '',
      price: (item['price'] ?? 0.18).toDouble(),
    )).toList();
  }

  static MarketData _getFallbackMarketData() {
    return MarketData(
      currentPrice: 0.18, // €/kWh - typical Lithuanian electricity price
      lastUpdated: DateTime.now(),
      historicalPrices: _generateHistoricalPrices(6),
      averageConsumption: HouseholdAverages(
        household1: 200,
        household2: 350,
        household3: 450,
        household4plus: 600,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  static List<PriceHistory> _generateHistoricalPrices(int months) {
    final now = DateTime.now();
    final prices = <PriceHistory>[];
    
    for (int i = months; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final month = DateFormat('yyyy-MM').format(date);
      
      // Generate realistic price variations
      final basePrice = 0.18;
      final seasonalFactor = _getSeasonalFactor(date.month);
      final randomFactor = 0.9 + (0.2 * (i % 3) / 3); // Simulate some variation
      final price = basePrice * seasonalFactor * randomFactor;
      
      prices.add(PriceHistory(month: month, price: price));
    }
    
    return prices;
  }

  static double _getSeasonalFactor(int month) {
    // Lithuanian seasonal energy price factors
    switch (month) {
      case 12:
      case 1:
      case 2:
        return 1.2; // Winter - higher heating demand
      case 6:
      case 7:
      case 8:
        return 0.9; // Summer - lower heating demand
      case 3:
      case 4:
      case 5:
      case 9:
      case 10:
      case 11:
        return 1.0; // Transition seasons
      default:
        return 1.0;
    }
  }
}

class MarketData {
  final double currentPrice;
  final DateTime lastUpdated;
  final List<PriceHistory> historicalPrices;
  final HouseholdAverages averageConsumption;

  MarketData({
    required this.currentPrice,
    required this.lastUpdated,
    required this.historicalPrices,
    required this.averageConsumption,
  });
}

class PriceHistory {
  final String month;
  final double price;

  PriceHistory({
    required this.month,
    required this.price,
  });
}

class HouseholdAverages {
  final double household1;
  final double household2;
  final double household3;
  final double household4plus;
  final DateTime lastUpdated;

  HouseholdAverages({
    required this.household1,
    required this.household2,
    required this.household3,
    required this.household4plus,
    required this.lastUpdated,
  });

  double getAverageForSize(int size) {
    switch (size) {
      case 1:
        return household1;
      case 2:
        return household2;
      case 3:
        return household3;
      default:
        return household4plus;
    }
  }

  double getAverageForArea(int area) {
    // Area-based consumption averages for Lithuanian homes
    if (area <= 50) {
      return 200; // Small apartments
    } else if (area <= 80) {
      return 350; // Average apartments
    } else if (area <= 120) {
      return 450; // Large apartments/small houses
    } else if (area <= 200) {
      return 600; // Medium houses
    } else {
      return 800; // Large houses
    }
  }
}
