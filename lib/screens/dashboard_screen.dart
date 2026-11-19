import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/room_card.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await service.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: service.getDevicesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No device data found in Firebase'));
          }

          final devices = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final roomData = devices['room_module'] ?? {};
          final garageData = devices['garage_module'] ?? {};
          final rainData = devices['rain_module'] ?? {};
          final climateData = devices['climate_module'] ?? {};

          return ListView(
            children: [
              RoomCard(data: roomData),
              _SimpleStatusCard(
                title: 'Garage Module',
                icon: Icons.garage,
                status: 'Car Detected: ${garageData['sensors']?['carDetected'] ?? false}',
                switchLabel: 'Gate Open',
                switchValue: garageData['commands']?['gateOpen'] ?? false,
                onToggle: (val) => service.updateDevice('garage_module/commands/gateOpen', val),
              ),
              _SimpleStatusCard(
                title: 'Rain Module',
                icon: Icons.water_drop,
                status: 'Raining: ${rainData['sensors']?['isRaining'] ?? false}',
                switchLabel: 'Roof Closed',
                switchValue: rainData['commands']?['roofClosed'] ?? false,
                onToggle: (val) => service.updateDevice('rain_module/commands/roofClosed', val),
              ),
              _SimpleStatusCard(
                title: 'Climate Module',
                icon: Icons.thermostat,
                status: 'Temperature: ${climateData['sensors']?['temperature'] ?? 25.0} °C',
                switchLabel: 'Fan On',
                switchValue: climateData['commands']?['fanOn'] ?? false,
                onToggle: (val) => service.updateDevice('climate_module/commands/fanOn', val),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SimpleStatusCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String status;
  final String switchLabel;
  final bool switchValue;
  final ValueChanged<bool> onToggle;

  const _SimpleStatusCard({
    required this.title,
    required this.icon,
    required this.status,
    required this.switchLabel,
    required this.switchValue,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(switchLabel),
            Switch(value: switchValue, onChanged: onToggle),
          ],
        ),
      ),
    );
  }
}