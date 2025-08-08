import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/mindmap.dart';
import '../models/mindmap_node.dart';
import '../services/map_manager.dart';
import '../utils/constants.dart';
import '../widgets/canvas_view.dart';
import '../widgets/node_widget.dart';

class MindMapPage extends StatefulWidget {
  final MindMap mindMap;

  const MindMapPage({
    Key? key,
    required this.mindMap,
  }) : super(key: key);

  @override
  State<MindMapPage> createState() => _MindMapPageState();
}

class _MindMapPageState extends State<MindMapPage> {
  late MindMap _currentMindMap;
  final Uuid _uuid = const Uuid();
  bool _isSaving = false;

  // UI state
  NodeShape _currentShape = NodeShape.rounded;
  String? _pendingConnectSourceId;

  @override
  void initState() {
    super.initState();
    _currentMindMap = widget.mindMap;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapManager>().updateCurrentMindMap(_currentMindMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentMindMap.title),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isSaving ? null : _saveMindMap,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'add_root',
                child: ListTile(
                  leading: Icon(Icons.add_circle),
                  title: Text('Add Root Node'),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                ),
              ),
              PopupMenuItem(
                value: 'center_view',
                child: ListTile(
                  leading: Icon(Icons.center_focus_strong),
                  title: Text('Center View'),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                ),
              ),
              PopupMenuItem(
                value: 'toggle_shape',
                child: ListTile(
                  leading: Icon(Icons.change_circle),
                  title: Text('Toggle Node Shape'),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                ),
              ),
              PopupMenuItem(
                value: 'connect_mode',
                child: ListTile(
                  leading: Icon(Icons.alt_route),
                  title: Text(_pendingConnectSourceId == null ? 'Start Connect' : 'Cancel Connect'),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export (Coming Soon)'),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                ),
              ),
            ],
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          CanvasView(
            mindMap: _currentMindMap,
            onMindMapUpdated: _onMindMapUpdated,
            onAddChild: _addChildNode,
            onDeleteNode: _deleteNode,
            onNodeTap: _onNodeTap,
            shape: _currentShape,
            onChangeShape: _onChangeNodeShape,
          ),
          if (_isSaving)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMedium,
                  vertical: AppConstants.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      'Saving...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          if (_pendingConnectSourceId != null)
            Positioned(
              left: 16,
              bottom: 16,
              child: Chip(
                label: Text('Select target node to connect...'),
                avatar: Icon(Icons.alt_route),
                backgroundColor: Colors.amber.shade100,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRootNode,
        child: Icon(Icons.add),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _onMindMapUpdated(MindMap updatedMindMap) {
    setState(() {
      _currentMindMap = updatedMindMap;
    });
    context.read<MapManager>().updateCurrentMindMap(_currentMindMap);
  }

  void _onNodeTap(MindMapNode node) {
    if (_pendingConnectSourceId == null) return;
    if (_pendingConnectSourceId!.isEmpty) {
      // Set source
      setState(() => _pendingConnectSourceId = node.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Now tap the target node to connect to')),
      );
      return;
    }

    if (node.id == _pendingConnectSourceId) return;

    final updatedNodes = _currentMindMap.nodes.map((n) {
      if (n.id == node.id) {
        return n.copyWith(parentId: _pendingConnectSourceId);
      }
      return n;
    }).toList();

    _onMindMapUpdated(_currentMindMap.copyWith(nodes: updatedNodes));
    setState(() => _pendingConnectSourceId = null);
  }

  void _addRootNode() {
    _showAddNodeDialog(null);
  }

  void _addChildNode(String parentId) {
    _showAddNodeDialog(parentId);
  }

  void _showAddNodeDialog(String? parentId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(parentId == null ? 'Add Root Node' : 'Add Child Node'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                autofocus: true,
              ),
              SizedBox(height: AppConstants.spacingMedium),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim();

                _createNode(title: title, description: description, parentId: parentId);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _createNode({
    required String title,
    String? description,
    String? parentId,
  }) {
    Offset position;
    if (parentId == null) {
      position = Offset.zero;
    } else {
      final parentNode = _currentMindMap.getNode(parentId);
      if (parentNode == null) return;

      final children = _currentMindMap.getChildren(parentId);
      final angle = (children.length * 45) * (3.14159 / 180);
      const distance = 150.0;

      position = Offset(
        parentNode.x + distance * cos(angle),
        parentNode.y + distance * sin(angle),
      );
    }

    final newNode = MindMapNode(
      id: _uuid.v4(),
      title: title,
      description: description,
      parentId: parentId,
      x: position.dx,
      y: position.dy,
      color: AppConstants.nodeColors[_currentMindMap.nodes.length % AppConstants.nodeColors.length],
    );

    final updatedMap = _currentMindMap.copyWith(
      nodes: [..._currentMindMap.nodes, newNode],
    );

    _onMindMapUpdated(updatedMap);
  }

  void _deleteNode(String nodeId) {
    final updatedMap = _currentMindMap.copyWith(
      nodes: _currentMindMap.nodes.where((node) => node.id != nodeId).toList(),
    );

    final nodesToRemove = <String>{nodeId};
    final nodesToCheck = <String>{nodeId};

    while (nodesToCheck.isNotEmpty) {
      final currentId = nodesToCheck.first;
      nodesToCheck.remove(currentId);

      for (final node in updatedMap.nodes) {
        if (node.parentId == currentId) {
          nodesToRemove.add(node.id);
          nodesToCheck.add(node.id);
        }
      }
    }

    final finalMap = updatedMap.copyWith(
      nodes: updatedMap.nodes.where((node) => !nodesToRemove.contains(node.id)).toList(),
    );

    _onMindMapUpdated(finalMap);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'add_root':
        _addRootNode();
        break;
      case 'center_view':
        // Center view handled by CanvasView button; trigger here by calling setState to rebuild and then calling center
        // Not directly accessible; user can press the floating button.
        break;
      case 'toggle_shape':
        setState(() {
          _currentShape = _currentShape == NodeShape.rounded ? NodeShape.circle : NodeShape.rounded;
        });
        break;
      case 'connect_mode':
        setState(() {
          _pendingConnectSourceId = _pendingConnectSourceId == null ? '' : null;
        });
        if (_pendingConnectSourceId == null) return;
        // Wait for the next node tap to set source id
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tap a source node to start connecting')),
        );
        break;
      case 'export':
        _showExportDialog();
        break;
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Mind Map'),
        content: Text('Export functionality is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMindMap() async {
    setState(() => _isSaving = true);

    try {
      await context.read<MapManager>().saveCurrentMindMap();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mind map saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save mind map: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onChangeNodeShape(String nodeId) {
    setState(() {
      _currentShape = _currentShape == NodeShape.rounded ? NodeShape.circle : NodeShape.rounded;
    });
  }

  @override
  void dispose() {
    _saveMindMap();
    super.dispose();
  }
} 