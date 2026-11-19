import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class RoomCard extends StatelessWidget {
  final Map<dynamic, dynamic> data;
  final FirebaseService _service = FirebaseService();

  RoomCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sensors = data['sensors'] ?? {};
    final commands = data['commands'] ?? {};

    final int lightLevel = sensors['lightLevel'] ?? 0;
    final String mode = commands['mode'] ?? 'auto';
    final double curtainAngle = (commands['curtainAngle'] ?? 0).toDouble();
    final double ledBrightness = (commands['ledBrightness'] ?? 0).toDouble();
    final bool isManual = mode == 'manual';

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.meeting_room, color: Colors.indigo, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Room Module',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isManual,
                  onChanged: (val) => _service.updateDevice(
                    'room_module/commands/mode',
                    val ? 'manual' : 'auto',
                  ),
                ),
              ],
            ),
            Text(
              'Mode: ${mode.toUpperCase()}',
              style: TextStyle(
                color: isManual ? Colors.orange : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
            Text(
              'Light Sensor Level: $lightLevel',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text('Curtain Angle: ${curtainAngle.toInt()}°'),
            Slider(
              value: curtainAngle.clamp(0, 180),
              min: 0,
              max: 180,
              divisions: 18,
              onChanged: isManual
                  ? (val) => _service.updateDevice(
                      'room_module/commands/curtainAngle',
                      val.toInt(),
                    )
                  : null,
            ),
            Text('LED Brightness: ${ledBrightness.toInt()}'),
            Slider(
              value: ledBrightness.clamp(0, 255),
              min: 0,
              max: 255,
              onChanged: isManual
                  ? (val) => _service.updateDevice(
                      'room_module/commands/ledBrightness',
                      val.toInt(),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
