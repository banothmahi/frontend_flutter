import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../core/policy.dart';

class IrrigationRecommendations extends ConsumerWidget {
  final String zoneId;
  final String zoneName;

  const IrrigationRecommendations({super.key, required this.zoneId, required this.zoneName});

  Future<double> _loadSoilForZone(String id) async {
    final raw = await rootBundle.loadString('assets/mock/soil_moisture.json');
    final j = jsonDecode(raw);
    final zone = (j['zones'] as List).firstWhere((e) => e['id'] == id);
    return (zone['moisture'] as num).toDouble();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(forecastProvider);
    final policy = ref.watch(policyProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Irrigation Plan • $zoneName')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<double>(
          future: _loadSoilForZone(zoneId),
          builder: (context, soilSnap) {
            if (!soilSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final soil = soilSnap.data!;
            return forecast.when(
              data: (f) => policy.when(
                data: (p) {
                  final action = p.decide(soilMoisture: soil, rainProb: f.rainProbability);
                  String label;
                  String minutes;
                  switch (action) {
                    case ActionLevel.off: label = 'OFF'; minutes = '0'; break;
                    case ActionLevel.low: label = 'LOW'; minutes = '10'; break;
                    case ActionLevel.med: label = 'MED'; minutes = '20'; break;
                    case ActionLevel.high: label = 'HIGH'; minutes = '30'; break;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Soil moisture: ${(soil*100).toStringAsFixed(1)}%'),
                      const SizedBox(height: 8),
                      Text('Rain probability (today): ${(f.rainProbability*100).toStringAsFixed(0)}%'),
                      const SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          title: const Text('Recommended Action (RL Policy)'),
                          subtitle: Text('Valve: $label  •  Duration: $minutes min'),
                          leading: const Icon(Icons.auto_awesome),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Irrigation schedule sent to controller (mock).')),
                          );
                        },
                        icon: const Icon(Icons.play_circle),
                        label: const Text('Apply Now'),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Policy error: $e'),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Forecast error: $e'),
            );
          },
        ),
      ),
    );
  }
}
