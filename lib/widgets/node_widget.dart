import 'dart:math';
import 'package:flutter/material.dart';
import '../models/mindmap_node.dart';
import '../utils/constants.dart';

enum NodeShape { circle, square, rectangle, triangle, pentagon, hexagon, parallelogram }

NodeShape shapeFromId(int id) => NodeShape.values[id.clamp(0, NodeShape.values.length - 1)];
int shapeIdFor(NodeShape shape) => NodeShape.values.indexOf(shape);

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
        onLongPress: _showActionMenuDialog,
        child: Draggable<MindMapNode>(
          data: widget.node,
          feedback: _buildNodeContent(true),
          childWhenDragging: _buildNodeContent(false, opacity: 0.5),
          onDragEnd: (details) {
            final newPosition = Offset(
              (details.offset.dx - widget.canvasOffset.dx) / widget.zoomLevel,
              (details.offset.dy - widget.canvasOffset.dy) / widget.zoomLevel,
            );
            final updatedNode = widget.node.copyWith(
              x: newPosition.dx,
              y: newPosition.dy,
            );
            widget.onNodeUpdated(updatedNode);
          },
          child: _buildNodeContent(false),
        ),
      ),
    );
  }

  Widget _buildNodeContent(bool isDragging, {double opacity = 1.0}) {
    final shape = shapeFromId(widget.node.shapeId);
    final diameter = AppConstants.nodeMinWidth * widget.zoomLevel;
    final width = AppConstants.nodeMinWidth * widget.zoomLevel;
    final height = AppConstants.nodeMinHeight * widget.zoomLevel;

    Widget content = Padding(
      padding: EdgeInsets.all(AppConstants.nodePadding * widget.zoomLevel),
      child: _isEditing ? _buildEditMode() : _buildDisplayMode(),
    );

    switch (shape) {
      case NodeShape.circle:
        return SizedBox(
          width: diameter,
          height: diameter,
          child: CustomPaint(
            painter: _ShapePainter(shape: shape, fill: widget.node.color.withOpacity(opacity), border: widget.node.borderColor),
            child: Material(color: Colors.transparent, child: content),
          ),
        );
      case NodeShape.square:
        return SizedBox(
          width: width,
          height: width,
          child: CustomPaint(
            painter: _ShapePainter(shape: shape, fill: widget.node.color.withOpacity(opacity), border: widget.node.borderColor),
            child: Material(color: Colors.transparent, child: content),
          ),
        );
      default:
        return SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: _ShapePainter(shape: shape, fill: widget.node.color.withOpacity(opacity), border: widget.node.borderColor),
            child: Material(color: Colors.transparent, child: content),
          ),
        );
    }
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
                color: Colors.white.withOpacity(0.9),
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
            color: Colors.white.withOpacity(0.9),
          ),
          decoration: InputDecoration(
            hintText: 'Description (optional)',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
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
              child: Icon(Icons.check, color: Colors.white, size: 16 * widget.zoomLevel),
            ),
            SizedBox(width: 8 * widget.zoomLevel),
            GestureDetector(
              onTap: _cancelEdit,
              child: Icon(Icons.close, color: Colors.white, size: 16 * widget.zoomLevel),
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
              leading: Icon(Icons.color_lens),
              title: Text('Change Color'),
              onTap: () {
                Navigator.pop(context);
                _showColorPicker();
              },
            ),
            ListTile(
              leading: Icon(Icons.change_circle),
              title: Text('Change Shape'),
              onTap: () {
                Navigator.pop(context);
                _cycleShape();
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

  void _showColorPicker() async {
    final colors = <Color>[
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
      const Color(0xFFFF5722),
      const Color(0xFF795548),
      const Color(0xFF37474F),
      const Color(0xFF607D8B),
    ];

    Color selectedFill = widget.node.color;
    Color selectedBorder = widget.node.borderColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick Colors'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(alignment: Alignment.centerLeft, child: Text('Fill Color')),
            SizedBox(height: 8),
            _buildColorGrid(colors, selectedFill, (c) => setState(() => selectedFill = c)),
            SizedBox(height: 16),
            Align(alignment: Alignment.centerLeft, child: Text('Border Color')),
            SizedBox(height: 8),
            _buildColorGrid(colors, selectedBorder, (c) => setState(() => selectedBorder = c)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = widget.node.copyWith(color: selectedFill, borderColor: selectedBorder);
              widget.onNodeUpdated(updated);
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorGrid(List<Color> colors, Color selected, ValueChanged<Color> onPick) {
    return SizedBox(
      height: 100,
      child: GridView.count(
        crossAxisCount: 5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        children: [
          for (final c in colors)
            GestureDetector(
              onTap: () => onPick(c),
              child: Container(
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(color: selected == c ? Colors.black : Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _cycleShape() {
    final current = shapeFromId(widget.node.shapeId);
    final nextIndex = (shapeIdFor(current) + 1) % NodeShape.values.length;
    final updated = widget.node.copyWith(shapeId: nextIndex);
    widget.onNodeUpdated(updated);
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

class _ShapePainter extends CustomPainter {
  final NodeShape shape;
  final Color fill;
  final Color border;

  _ShapePainter({required this.shape, required this.fill, required this.border});

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()..color = fill..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path;
    switch (shape) {
      case NodeShape.circle:
        canvas.drawCircle(size.center(Offset.zero), size.shortestSide / 2, paintFill);
        canvas.drawCircle(size.center(Offset.zero), size.shortestSide / 2, paintStroke);
        return;
      case NodeShape.square:
        path = Path()..addRect(Rect.fromLTWH(0, 0, size.shortestSide, size.shortestSide));
        break;
      case NodeShape.rectangle:
        path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)));
        break;
      case NodeShape.triangle:
        path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        break;
      case NodeShape.pentagon:
        path = _regularPolygonPath(size, 5);
        break;
      case NodeShape.hexagon:
        path = _regularPolygonPath(size, 6);
        break;
      case NodeShape.parallelogram:
        final skew = size.width * 0.2;
        path = Path()
          ..moveTo(skew, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width - skew, size.height)
          ..lineTo(0, size.height)
          ..close();
        break;
    }
    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  Path _regularPolygonPath(Size size, int sides) {
    final path = Path();
    final center = size.center(Offset.zero);
    final radius = 0.5 * size.shortestSide;
    for (int i = 0; i < sides; i++) {
      final angle = (pi / 2) + (2 * pi * i / sides);
      final x = center.dx + radius * cos(angle);
      final y = center.dy - radius * sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) {
    return oldDelegate.shape != shape || oldDelegate.fill != fill || oldDelegate.border != border;
  }
} 