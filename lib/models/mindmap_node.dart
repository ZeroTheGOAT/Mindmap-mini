import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'mindmap_node.g.dart';

@HiveType(typeId: 0)
class MindMapNode extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? parentId;

  @HiveField(4)
  double x;

  @HiveField(5)
  double y;

  @HiveField(6)
  Color color;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  MindMapNode({
    required this.id,
    required this.title,
    this.description,
    this.parentId,
    required this.x,
    required this.y,
    this.color = const Color(0xFF2196F3),
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Offset get position => Offset(x, y);

  set position(Offset offset) {
    x = offset.dx;
    y = offset.dy;
    updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'parentId': parentId,
      'x': x,
      'y': y,
      'color': color.value,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  static MindMapNode fromMap(Map<String, dynamic> map) {
    return MindMapNode(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      parentId: map['parentId'],
      x: map['x'].toDouble(),
      y: map['y'].toDouble(),
      color: Color(map['color']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  MindMapNode copyWith({
    String? id,
    String? title,
    String? description,
    String? parentId,
    double? x,
    double? y,
    Color? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MindMapNode(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MindMapNode && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 