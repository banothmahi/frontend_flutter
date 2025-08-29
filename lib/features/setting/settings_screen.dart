import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Units'),
            subtitle: Text('Metric (°C, mm)'),
          ),
          ListTile(
            title: Text('Controller'),
            subtitle: Text('Demo mode (no hardware)'),
          ),
        ],
      ),
    );
  }
}
