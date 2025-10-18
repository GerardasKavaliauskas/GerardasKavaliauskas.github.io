import 'package:flutter/material.dart';

class ScheduledLoad {
  final String appliance;
  final int loadWatts;
  final Duration minTimeLeft;
  final Duration maxTimeLeft;
  final bool isPinned;

  ScheduledLoad({
    required this.appliance,
    required this.loadWatts,
    required this.minTimeLeft,
    required this.maxTimeLeft,
    this.isPinned = false,
  });
}

class ApplianceOption {
  final String name;
  final IconData icon;
  final int watts;

  ApplianceOption(this.name, this.icon, this.watts);
}

class CustomAppliance {
  final String name;
  final int watts;
  final IconData icon;

  CustomAppliance({
    required this.name,
    required this.watts,
    this.icon = Icons.device_unknown,
  });
}

class DeviceUsageData {
  final String name;
  final int kwh;
  final double percentage;
  final Color color;
  final IconData icon;

  DeviceUsageData({
    required this.name,
    required this.kwh,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

enum ScheduleMode { relative, absolute }

// Bill Predictor Models
class HistoricalBill {
  final String month;
  final double cost;
  final int kwh;

  HistoricalBill({
    required this.month,
    required this.cost,
    required this.kwh,
  });
}

class MonthPrediction {
  final String month;
  final double cost;
  final int usage;
  final ConfidenceRange? confidenceRange;
  final String? vsAverage;

  MonthPrediction({
    required this.month,
    required this.cost,
    required this.usage,
    this.confidenceRange,
    this.vsAverage,
  });
}

class ConfidenceRange {
  final double min;
  final double max;

  ConfidenceRange(this.min, this.max);
}

class YearPrediction {
  final double totalCost;
  final double avgMonthlyCost;
  final List<MonthPrediction> monthlyBreakdown;

  YearPrediction({
    required this.totalCost,
    required this.avgMonthlyCost,
    required this.monthlyBreakdown,
  });
}

class PredictionResult {
  final MonthPrediction nextMonth;
  final List<MonthPrediction> next3Months;
  final YearPrediction nextYear;
  final List<String> insights;

  PredictionResult({
    required this.nextMonth,
    required this.next3Months,
    required this.nextYear,
    required this.insights,
  });
}
