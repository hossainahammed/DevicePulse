import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import ' models/device_snapshot.dart';


class ReceivedScreen extends StatelessWidget {
  const ReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<DeviceSnapshot>('snapshots');

    return Scaffold(
      appBar: AppBar(title: const Text('Received Data')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<DeviceSnapshot> box, __) {
          if (box.isEmpty) {
            return const Center(child: Text('No data received'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, i) {
              final snap = box.getAt(i)!;
              return ListTile(
                title: Text(snap.time.toIso8601String()),
                subtitle: Text(snap.data.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
