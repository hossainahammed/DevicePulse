import 'package:devicepulse/screens/received_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dashboard_screen.dart';
//import 'received_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('received_snapshots');
  //await Hive.openBox<DeviceSnapshot>('snapshots');
  runApp(
      // DevicePreview(
      //   enabled: true,
      //   builder: (context)=>MyApp() ,
      // )
      const MyApp()
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Pulse',
      theme: ThemeData(useMaterial3: true),
      home: const HomeTabs(),
    );
  }
}

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.inbox), label: 'Received'),
        ],
      ),
      body: index == 0 ? const DashboardScreen() : const ReceivedScreen(),
    );
  }
}
