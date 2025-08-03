// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mindmap_node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MindMapNodeAdapter extends TypeAdapter<MindMapNode> {
  @override
  final int typeId = 0;

  @override
  MindMapNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MindMapNode(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      parentId: fields[3] as String?,
      x: fields[4] as double,
      y: fields[5] as double,
      color: fields[6] as Color,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MindMapNode obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.parentId)
      ..writeByte(4)
      ..write(obj.x)
      ..writeByte(5)
      ..write(obj.y)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MindMapNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
