// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mindmap.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MindMapAdapter extends TypeAdapter<MindMap> {
  @override
  final int typeId = 1;

  @override
  MindMap read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MindMap(
      id: fields[0] as String,
      title: fields[1] as String,
      nodes: (fields[2] as List?)?.cast<MindMapNode>(),
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[4] as DateTime?,
      zoomLevel: fields[5] as double,
      offsetX: fields[6] as double,
      offsetY: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MindMap obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.nodes)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.zoomLevel)
      ..writeByte(6)
      ..write(obj.offsetX)
      ..writeByte(7)
      ..write(obj.offsetY);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MindMapAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
