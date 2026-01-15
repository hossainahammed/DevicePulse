import 'dart:convert';
import 'package:flutter/material.dart';
import 'services/native_service.dart';
import 'services/udp_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? data;

  Future<void> load() async {
    final d = await NativeService.getDeviceData();
    setState(() => data = d);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Device Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(jsonEncode(data), style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => UDPService.broadcast(data!),
            child: const Text('Share My Pulse'),
          ),
        ],
      ),
    );
  }
}
