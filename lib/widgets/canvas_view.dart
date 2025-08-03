import 'dart:math';
import 'package:flutter/material.dart';
import '../models/mindmap.dart';
import '../models/mindmap_node.dart';
import '../utils/constants.dart';
import 'node_widget.dart';
import 'connector_painter.dart';

class CanvasView extends StatefulWidget {
  final MindMap mindMap;
  final Function(MindMap) onMindMapUpdated;
  final Function(String) onAddChild;
  final Function(String) onDeleteNode;

  const CanvasView({
    Key? key,
    required this.mindMap,
    required this.onMindMapUpdated,
    required this.onAddChild,
    required this.onDeleteNode,
  }) : super(key: key);

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  double _zoomLevel = 1.0;
  Offset _canvasOffset = Offset.zero;
  Offset? _lastPanPosition;
  bool _showGrid = false;
  bool _snapToGrid = false;
  double _gridSize = 20.0;

  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.mindMap.zoomLevel;
    _canvasOffset = Offset(widget.mindMap.offsetX, widget.mindMap.offsetY);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load settings from local storage
    // This would be implemented with the LocalStorageService
    setState(() {
      _showGrid = false;
      _snapToGrid = false;
      _gridSize = 20.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onTap: _onCanvasTap,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            // Grid background
            if (_showGrid) _buildGrid(),
            
            // Canvas with connectors
            CustomPaint(
              painter: ConnectorPainter(
                nodes: widget.mindMap.nodes,
                zoomLevel: _zoomLevel,
                canvasOffset: _canvasOffset,
              ),
              size: Size.infinite,
            ),
            
            // Nodes
            ...widget.mindMap.nodes.map((node) => NodeWidget(
              node: node,
              zoomLevel: _zoomLevel,
              canvasOffset: _canvasOffset,
              onNodeUpdated: _onNodeUpdated,
              onAddChild: _onAddChild,
              onDeleteNode: _onDeleteNode,
              onNodeTapped: _onNodeTapped,
            )),
            
            // Zoom controls
            _buildZoomControls(),
            
            // Center view button
            _buildCenterViewButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return CustomPaint(
      painter: GridPainter(
        gridSize: _gridSize * _zoomLevel,
        offset: _canvasOffset,
        color: Colors.grey.withOpacity(0.3),
      ),
      size: Size.infinite,
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: _zoomIn,
            child: Icon(Icons.zoom_in),
            heroTag: 'zoom_in',
          ),
          SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: _zoomOut,
            child: Icon(Icons.zoom_out),
            heroTag: 'zoom_out',
          ),
          SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: _resetZoom,
            child: Icon(Icons.refresh),
            heroTag: 'reset_zoom',
          ),
        ],
      ),
    );
  }

  Widget _buildCenterViewButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton(
        onPressed: _centerView,
        child: Icon(Icons.center_focus_strong),
        heroTag: 'center_view',
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastPanPosition = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      // Zoom
      final newZoom = (_zoomLevel * details.scale).clamp(
        AppConstants.minZoomLevel,
        AppConstants.maxZoomLevel,
      );
      setState(() => _zoomLevel = newZoom);
    } else if (details.focalPointDelta != Offset.zero) {
      // Pan
      setState(() {
        _canvasOffset += details.focalPointDelta;
      });
    }
    
    _saveViewState();
  }

  void _onCanvasTap() {
    // Clear any selected nodes or close menus
  }

  void _onNodeTapped(MindMapNode node) {
    // Handle node tap - could show details or highlight
  }

  void _onNodeUpdated(MindMapNode updatedNode) {
    final updatedMap = widget.mindMap.copyWith(
      nodes: widget.mindMap.nodes.map((node) {
        return node.id == updatedNode.id ? updatedNode : node;
      }).toList(),
    );
    widget.onMindMapUpdated(updatedMap);
  }

  void _onAddChild(String parentId) {
    final parentNode = widget.mindMap.getNode(parentId);
    if (parentNode == null) return;

    // Calculate position for new child node
    final childPosition = _calculateChildPosition(parentNode);
    
    widget.onAddChild(parentId);
  }

  void _onDeleteNode(String nodeId) {
    widget.onDeleteNode(nodeId);
  }

  Offset _calculateChildPosition(MindMapNode parentNode) {
    // Calculate a position for the new child node
    // This is a simple implementation - you might want to make it more sophisticated
    final angle = (widget.mindMap.getChildren(parentNode.id).length * 45) * (3.14159 / 180);
    const distance = 150.0;
    
    return Offset(
      parentNode.x + distance * cos(angle),
      parentNode.y + distance * sin(angle),
    );
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel * 1.2).clamp(
        AppConstants.minZoomLevel,
        AppConstants.maxZoomLevel,
      );
    });
    _saveViewState();
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel / 1.2).clamp(
        AppConstants.minZoomLevel,
        AppConstants.maxZoomLevel,
      );
    });
    _saveViewState();
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = AppConstants.defaultZoomLevel;
    });
    _saveViewState();
  }

  void _centerView() {
    if (widget.mindMap.nodes.isEmpty) return;
    
    // Calculate the center of all nodes
    double minX = double.infinity;
    double maxX = -double.infinity;
    double minY = double.infinity;
    double maxY = -double.infinity;
    
    for (final node in widget.mindMap.nodes) {
      minX = min(minX, node.x);
      maxX = max(maxX, node.x);
      minY = min(minY, node.y);
      maxY = max(maxY, node.y);
    }
    
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    
    // Center the view
    final screenCenter = MediaQuery.of(context).size.center(Offset.zero);
    setState(() {
      _canvasOffset = Offset(
        screenCenter.dx - centerX * _zoomLevel,
        screenCenter.dy - centerY * _zoomLevel,
      );
    });
    _saveViewState();
  }

  void _saveViewState() {
    final updatedMap = widget.mindMap.copyWith(
      zoomLevel: _zoomLevel,
      offsetX: _canvasOffset.dx,
      offsetY: _canvasOffset.dy,
    );
    widget.onMindMapUpdated(updatedMap);
  }

  void toggleGrid() {
    setState(() {
      _showGrid = !_showGrid;
    });
  }

  void toggleSnapToGrid() {
    setState(() {
      _snapToGrid = !_snapToGrid;
    });
  }

  Offset _snapToGridPosition(Offset position) {
    if (!_snapToGrid) return position;
    
    final snappedX = (position.dx / _gridSize).round() * _gridSize;
    final snappedY = (position.dy / _gridSize).round() * _gridSize;
    
    return Offset(snappedX, snappedY);
  }
}

class GridPainter extends CustomPainter {
  final double gridSize;
  final Offset offset;
  final Color color;

  GridPainter({
    required this.gridSize,
    required this.offset,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    // Draw vertical lines
    for (double x = offset.dx % gridSize; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = offset.dy % gridSize; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize ||
           oldDelegate.offset != offset ||
           oldDelegate.color != color;
  }
} 