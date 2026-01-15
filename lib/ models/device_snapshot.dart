import 'package:hive/hive.dart';

part 'device_snapshot.g.dart';

@HiveType(typeId: 1)
class DeviceSnapshot {
  @HiveField(0)
  final Map<String, dynamic> data;

  @HiveField(1)
  final DateTime time;

  DeviceSnapshot(this.data, this.time);
}
