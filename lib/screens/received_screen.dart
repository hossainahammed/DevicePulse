
import 'package:devicepulse/models/device_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class ReceivedScreen extends StatelessWidget {
  const ReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Received Pulses")),
      body: ValueListenableBuilder(
        valueListenable:
        Hive.box<DeviceSnapshot>('snapshots').listenable(),
        builder: (_, box, __) {
          if (box.isEmpty) {
            return const Center(child: Text("No data received"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, i) {
              final snap = box.getAt(i)!;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(snap.deviceName),
                  subtitle: Text(
                    "Battery: ${snap.batteryLevel}% | Temp: ${snap.batteryTemp}°C\n"
                        "Health: ${snap.batteryHealth}\n"
                        "Time: ${snap.timestamp.toLocal()}",
                  ),

                  // title: Text(snap.deviceName),
                  // subtitle: Text(
                  //   "Battery: ${snap.batteryLevel}% | Temp: ${snap.batteryTemp}°C",
                  // ),
                  trailing: Text(
                    snap.timestamp.toLocal().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
