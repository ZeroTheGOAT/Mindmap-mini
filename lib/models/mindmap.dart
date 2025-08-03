import 'package:hive/hive.dart';
import 'mindmap_node.dart';

part 'mindmap.g.dart';

@HiveType(typeId: 1)
class MindMap extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<MindMapNode> nodes;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  double zoomLevel;

  @HiveField(6)
  double offsetX;

  @HiveField(7)
  double offsetY;

  MindMap({
    required this.id,
    required this.title,
    List<MindMapNode>? nodes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.zoomLevel = 1.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  })  : nodes = nodes ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  MindMapNode? get rootNode {
    return nodes.firstWhere(
      (node) => node.parentId == null,
      orElse: () => nodes.isNotEmpty ? nodes.first : MindMapNode(
        id: 'root',
        title: 'Root',
        x: 0,
        y: 0,
      ),
    );
  }

  List<MindMapNode> getChildren(String parentId) {
    return nodes.where((node) => node.parentId == parentId).toList();
  }

  MindMapNode? getNode(String id) {
    try {
      return nodes.firstWhere((node) => node.id == id);
    } catch (e) {
      return null;
    }
  }

  void addNode(MindMapNode node) {
    nodes.add(node);
    updatedAt = DateTime.now();
  }

  void updateNode(MindMapNode updatedNode) {
    final index = nodes.indexWhere((node) => node.id == updatedNode.id);
    if (index != -1) {
      nodes[index] = updatedNode;
      updatedAt = DateTime.now();
    }
  }

  void deleteNode(String nodeId) {
    // Delete the node and all its children recursively
    final nodesToDelete = <String>{nodeId};
    final nodesToCheck = <String>{nodeId};

    while (nodesToCheck.isNotEmpty) {
      final currentId = nodesToCheck.first;
      nodesToCheck.remove(currentId);

      // Find all children of the current node
      for (final node in nodes) {
        if (node.parentId == currentId) {
          nodesToDelete.add(node.id);
          nodesToCheck.add(node.id);
        }
      }
    }

    // Remove all nodes that should be deleted
    nodes.removeWhere((node) => nodesToDelete.contains(node.id));
    updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'nodes': nodes.map((node) => node.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'zoomLevel': zoomLevel,
      'offsetX': offsetX,
      'offsetY': offsetY,
    };
  }

  static MindMap fromMap(Map<String, dynamic> map) {
    return MindMap(
      id: map['id'],
      title: map['title'],
      nodes: (map['nodes'] as List)
          .map((nodeMap) => MindMapNode.fromMap(nodeMap))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      zoomLevel: map['zoomLevel']?.toDouble() ?? 1.0,
      offsetX: map['offsetX']?.toDouble() ?? 0.0,
      offsetY: map['offsetY']?.toDouble() ?? 0.0,
    );
  }

  MindMap copyWith({
    String? id,
    String? title,
    List<MindMapNode>? nodes,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? zoomLevel,
    double? offsetX,
    double? offsetY,
  }) {
    return MindMap(
      id: id ?? this.id,
      title: title ?? this.title,
      nodes: nodes ?? this.nodes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MindMap && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 