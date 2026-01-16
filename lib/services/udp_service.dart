import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:devicepulse/models/device_snapshot.dart';

class UDPService {
  static const int port = 4040;

  /// Listen for incoming UDP packets (Android only)
  static Future<void> startListening() async {
    final socket =
    await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);

    socket.listen((_) {
      final dg = socket.receive();
      if (dg == null) return;

      try {
        final decoded = utf8.decode(dg.data);
        final map = jsonDecode(decoded) as Map<String, dynamic>;

        final snapshot = DeviceSnapshot.fromJson(map);

        final box = Hive.box('snapshots');
        box.add(snapshot.toJson());
      } catch (e) {
        // Ignore malformed packets
      }
    });
  }

  /// Broadcast data to all peers on same Wi-Fi
  static Future<void> broadcast(Map<String, dynamic> data) async {
    final socket =
    await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    socket.broadcastEnabled = true;

    socket.send(
      utf8.encode(jsonEncode(data)),
      InternetAddress('255.255.255.255'),
      port,
    );

    socket.close();
  }
}

// import 'dart:convert';
// import 'dart:io';
//
// import 'package:hive/hive.dart';
// import 'package:devicepulse/models/device_snapshot.dart';
//
// class UDPService {
//   static const int port = 4040;
//
//   /// Listen for incoming UDP packets
//   static Future<void> startListening() async {
//     final socket =
//     await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
//
//     socket.listen((event) {
//       if (event == RawDatagramSocketEvent.read) {
//         final dg = socket.receive();
//         if (dg == null) return;
//
//         final decoded = utf8.decode(dg.data);
//         final map = jsonDecode(decoded) as Map<String, dynamic>;
//
//
//         final snapshot = DeviceSnapshot.fromJson(map);
//
//
//         final box = Hive.box('snapshots');
//         box.add(snapshot.toJson());
//       }
//     });
//   }
//
//   /// Broadcast data to all peers on same Wi-Fi
//   static Future<void> broadcast(Map<String, dynamic> data) async {
//     final socket =
//     await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
//
//     socket.broadcastEnabled = true;
//
//     socket.send(
//       utf8.encode(jsonEncode(data)),
//       InternetAddress('255.255.255.255'),
//       port,
//     );
//
//     socket.close();
//   }
// }
