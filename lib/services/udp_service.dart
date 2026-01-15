import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import '../ models/device_snapshot.dart';


class UDPService {
  static const port = 4040;

  static void startListening() async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    socket.listen((event) {
      final dg = socket.receive();
      if (dg != null) {
        final map = jsonDecode(utf8.decode(dg.data));
        Hive.box<DeviceSnapshot>('snapshots')
            .add(DeviceSnapshot(Map<String, dynamic>.from(map), DateTime.now()));
      }
    });
  }

  static void broadcast(Map<String, dynamic> data) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    socket.send(
      utf8.encode(jsonEncode(data)),
      InternetAddress('255.255.255.255'),
      port,
    );
    socket.close();
  }
}
