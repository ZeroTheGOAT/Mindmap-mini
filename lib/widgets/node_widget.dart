import 'package:flutter/material.dart';
import '../models/mindmap_node.dart';
import '../utils/constants.dart';

class NodeWidget extends StatefulWidget {
  final MindMapNode node;
  final double zoomLevel;
  final Offset canvasOffset;
  final Function(MindMapNode) onNodeUpdated;
  final Function(String) onAddChild;
  final Function(String) onDeleteNode;
  final Function(MindMapNode) onNodeTapped;

  const NodeWidget({
    Key? key,
    required this.node,
    required this.zoomLevel,
    required this.canvasOffset,
    required this.onNodeUpdated,
    required this.onAddChild,
    required this.onDeleteNode,
    required this.onNodeTapped,
  }) : super(key: key);

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _showActionMenu = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.node.title);
    _descriptionController = TextEditingController(text: widget.node.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaledPosition = Offset(
      widget.node.x * widget.zoomLevel + widget.canvasOffset.dx,
      widget.node.y * widget.zoomLevel + widget.canvasOffset.dy,
    );

    return Positioned(
      left: scaledPosition.dx - (AppConstants.nodeMinWidth * widget.zoomLevel) / 2,
      top: scaledPosition.dy - (AppConstants.nodeMinHeight * widget.zoomLevel) / 2,
      child: GestureDetector(
        onTap: () => widget.onNodeTapped(widget.node),
        onLongPress: () => _showActionMenuDialog(),
        child: Draggable<MindMapNode>(
          data: widget.node,
          feedback: _buildNodeContent(true),
          childWhenDragging: _buildNodeContent(false, opacity: 0.5),
          onDragEnd: (details) {
            if (details.wasAccepted) {
              final newPosition = Offset(
                (details.offset.dx - widget.canvasOffset.dx) / widget.zoomLevel,
                (details.offset.dy - widget.canvasOffset.dy) / widget.zoomLevel,
              );
              final updatedNode = widget.node.copyWith(
                x: newPosition.dx,
                y: newPosition.dy,
              );
              widget.onNodeUpdated(updatedNode);
            }
          },
          child: _buildNodeContent(false),
        ),
      ),
    );
  }

  Widget _buildNodeContent(bool isDragging, {double opacity = 1.0}) {
    return AnimatedContainer(
      duration: AppConstants.quickAnimationDuration,
      width: AppConstants.nodeMinWidth * widget.zoomLevel,
      constraints: BoxConstraints(
        minHeight: AppConstants.nodeMinHeight * widget.zoomLevel,
        maxWidth: AppConstants.nodeMaxWidth * widget.zoomLevel,
      ),
      decoration: BoxDecoration(
        color: widget.node.color.withOpacity(opacity),
        borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius * widget.zoomLevel),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8 * widget.zoomLevel,
                  offset: Offset(0, 4 * widget.zoomLevel),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4 * widget.zoomLevel,
                  offset: Offset(0, 2 * widget.zoomLevel),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius * widget.zoomLevel),
          onTap: _isEditing ? null : () => widget.onNodeTapped(widget.node),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.nodePadding * widget.zoomLevel),
            child: _isEditing ? _buildEditMode() : _buildDisplayMode(),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayMode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.node.title,
          style: AppConstants.bodyStyle.copyWith(
            fontSize: AppConstants.bodyStyle.fontSize! * widget.zoomLevel,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.node.description != null && widget.node.description!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4 * widget.zoomLevel),
            child: Text(
              widget.node.description!,
              style: AppConstants.captionStyle.copyWith(
                fontSize: AppConstants.captionStyle.fontSize! * widget.zoomLevel,
                color: Colors.white.withOpacity(0.8),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          style: AppConstants.bodyStyle.copyWith(
            fontSize: AppConstants.bodyStyle.fontSize! * widget.zoomLevel,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          maxLines: 2,
        ),
        SizedBox(height: 4 * widget.zoomLevel),
        TextField(
          controller: _descriptionController,
          style: AppConstants.captionStyle.copyWith(
            fontSize: AppConstants.captionStyle.fontSize! * widget.zoomLevel,
            color: Colors.white.withOpacity(0.8),
          ),
          decoration: InputDecoration(
            hintText: 'Description (optional)',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          maxLines: 3,
        ),
        SizedBox(height: 8 * widget.zoomLevel),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _saveChanges,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16 * widget.zoomLevel,
              ),
            ),
            SizedBox(width: 8 * widget.zoomLevel),
            GestureDetector(
              onTap: _cancelEdit,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 16 * widget.zoomLevel,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showActionMenuDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Node Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _isEditing = true);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Child'),
              onTap: () {
                Navigator.pop(context);
                widget.onAddChild(widget.node.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Node'),
        content: Text('Are you sure you want to delete this node and all its children?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDeleteNode(widget.node.id);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final updatedNode = widget.node.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );
    widget.onNodeUpdated(updatedNode);
    setState(() => _isEditing = false);
  }

  void _cancelEdit() {
    _titleController.text = widget.node.title;
    _descriptionController.text = widget.node.description ?? '';
    setState(() => _isEditing = false);
  }
} 