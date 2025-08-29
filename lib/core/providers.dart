import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models.dart';
import '../core/policy.dart';

final zonesProvider = FutureProvider<List<Zone>>((ref) async {
  final raw = await rootBundle.loadString('assets/mock/soil_moisture.json');
  final j = jsonDecode(raw);
  final zones = (j['zones'] as List).map((e) => Zone.fromJson(e)).toList();
  return zones;
});

final forecastProvider = FutureProvider<WeatherForecast>((ref) async {
  final raw = await rootBundle.loadString('assets/mock/weather_today.json');
  final j = jsonDecode(raw);
  return WeatherForecast(
    location: j['location'],
    date: j['date'],
    rainProbability: (j['forecast']['rain_probability'] as num).toDouble(),
    etMm: (j['forecast']['evapotranspiration_mm'] as num).toDouble(),
  );
});

final policyProvider = FutureProvider<RLPolicy>((ref) async {
  final p = RLPolicy();
  await p.load();
  return p;
});