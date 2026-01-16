part of 'device_snapshot.dart';

class DeviceSnapshotAdapter extends TypeAdapter<DeviceSnapshot> {
  @override
  final int typeId = 1;

  @override
  DeviceSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceSnapshot(
      (fields[0] as Map).cast<String, dynamic>(),
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceSnapshot obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
