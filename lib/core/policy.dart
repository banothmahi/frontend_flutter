import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum ActionLevel { off, low, med, high }

class RLPolicy {
  late List<double> soilBins;
  late List<double> rainBins;
  late List<List<int>> q;
  RLPolicy();

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/policy/q_table.json');
    final j = jsonDecode(raw);
    soilBins = (j['state_space']['soil_bins'] as List).map((e) => (e as num).toDouble()).toList();
    rainBins = (j['state_space']['forecast_bins'] as List).map((e) => (e as num).toDouble()).toList();
    q = (j['q'] as List).map<List<int>>((row) => (row as List).map((e) => e as int).toList()).toList();
  }

  int _bin(List<double> bins, double v) {
    for (int i = 0; i < bins.length; i++) {
      if (v <= bins[i]) return i;
    }
    return bins.length - 1;
  }

  ActionLevel decide({required double soilMoisture, required double rainProb}) {
    final s = _bin(soilBins, soilMoisture);
    final r = _bin(rainBins, rainProb);
    final aIdx = q[s][r].clamp(0, 3);
    switch (aIdx) {
      case 0: return ActionLevel.off;
      case 1: return ActionLevel.low;
      case 2: return ActionLevel.med;
      case 3: return ActionLevel.high;
      default: return ActionLevel.off;
    }
  }
}