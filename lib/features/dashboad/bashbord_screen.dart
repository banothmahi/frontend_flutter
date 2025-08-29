import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../irrigation/irrigation_recommendations.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zones = ref.watch(zonesProvider);
    final forecast = ref.watch(forecastProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Irrigation (RL) Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              forecast.when(
                data: (f) => 'Location: ${f.location}  •  Date: ${f.date}  •  Rain prob: ${(f.rainProbability*100).toStringAsFixed(0)}%',
                loading: () => 'Loading forecast...',
                error: (e,_) => 'Forecast error: $e',
              ),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: zones.when(
                data: (list) => ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final z = list[i];
                    return Card(
                      child: ListTile(
                        title: Text(z.name),
                        subtitle: Text('Soil moisture: ${(z.moisture*100).toStringAsFixed(1)}%'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => IrrigationRecommendations(zoneId: z.id, zoneName: z.name),
                        )),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,_) => Text('Error: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
