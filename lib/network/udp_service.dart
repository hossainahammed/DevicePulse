import 'dart:convert';
import 'dart:io';
import 'package:devicepulse/models/device_snapshot.dart';

import 'peer.dart';

class UdpService {
  static const int port = 45678;
  RawDatagramSocket? _socket;

  final List<Peer> peers = [];

  Future<void> startDiscovery(void Function(List<Peer>) onUpdate) async {
    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      port,
      reuseAddress: true,
      reusePort: true,
    );

    _socket!.broadcastEnabled = true;

    _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram == null) return;

        final message = utf8.decode(datagram.data);
        final data = jsonDecode(message);

        if (data['type'] == 'HELLO') {
          final peer = Peer(
            ip: datagram.address.address,
            name: data['name'],
          );

          if (!peers.any((p) => p.ip == peer.ip)) {
            peers.add(peer);
            onUpdate(peers);
          }
        }
      }
    });

    _broadcastDiscover();
  }

  void _broadcastDiscover() {
    final msg = jsonEncode({"type": "DISCOVER"});
    _socket!.send(
      utf8.encode(msg),
      InternetAddress('255.255.255.255'),
      port,
    );
  }

  void respondHello(String deviceName, InternetAddress address) {
    final msg = jsonEncode({
      "type": "HELLO",
      "name": deviceName,
    });
    _socket!.send(utf8.encode(msg), address, port);
  }

  void sendSnapshot(Peer peer, DeviceSnapshot snapshot) {
    final msg = jsonEncode(snapshot.toJson());
    _socket!.send(
      utf8.encode(msg),
      InternetAddress(peer.ip),
      port,
    );
  }

  void dispose() {
    _socket?.close();
  }
}
