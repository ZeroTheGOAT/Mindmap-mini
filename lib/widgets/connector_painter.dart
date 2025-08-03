import 'dart:math';
import 'package:flutter/material.dart';
import '../models/mindmap_node.dart';
import '../utils/constants.dart';

class ConnectorPainter extends CustomPainter {
  final List<MindMapNode> nodes;
  final double zoomLevel;
  final Offset canvasOffset;

  ConnectorPainter({
    required this.nodes,
    required this.zoomLevel,
    required this.canvasOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = AppConstants.connectorStrokeWidth / zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw connections between parent and child nodes
    for (final node in nodes) {
      if (node.parentId != null) {
        final parentNode = nodes.firstWhere(
          (n) => n.id == node.parentId,
          orElse: () => node,
        );

        if (parentNode != node) {
          _drawConnection(canvas, parentNode, node, paint);
        }
      }
    }
  }

  void _drawConnection(Canvas canvas, MindMapNode parent, MindMapNode child, Paint paint) {
    // Calculate positions with zoom and offset
    final parentPos = Offset(
      parent.x * zoomLevel + canvasOffset.dx,
      parent.y * zoomLevel + canvasOffset.dy,
    );
    
    final childPos = Offset(
      child.x * zoomLevel + canvasOffset.dx,
      child.y * zoomLevel + canvasOffset.dy,
    );

    // Calculate the connection points (edges of the nodes)
    final parentEdge = _getNodeEdge(parentPos, childPos, AppConstants.nodeMinWidth / 2, AppConstants.nodeMinHeight / 2);
    final childEdge = _getNodeEdge(childPos, parentPos, AppConstants.nodeMinWidth / 2, AppConstants.nodeMinHeight / 2);

    // Draw the line
    canvas.drawLine(parentEdge, childEdge, paint);

    // Draw arrow at the child end
    _drawArrow(canvas, childEdge, parentEdge, paint);
  }

  Offset _getNodeEdge(Offset nodeCenter, Offset targetCenter, double halfWidth, double halfHeight) {
    final dx = targetCenter.dx - nodeCenter.dx;
    final dy = targetCenter.dy - nodeCenter.dy;
    
    // Calculate the angle
    final angle = dy == 0 ? (dx > 0 ? 0 : 3.14159) : atan2(dy, dx);
    
    // Calculate intersection with rectangle
    double edgeX, edgeY;
    
    if ((cos(angle)).abs() > (sin(angle)).abs()) {
      // Intersects with left or right edge
      edgeX = nodeCenter.dx + (dx > 0 ? halfWidth : -halfWidth);
      edgeY = nodeCenter.dy + (dx > 0 ? halfWidth : -halfWidth) * tan(angle);
      
      if (edgeY > nodeCenter.dy + halfHeight) {
        edgeY = nodeCenter.dy + halfHeight;
        edgeX = nodeCenter.dx + halfHeight / tan(angle);
      } else if (edgeY < nodeCenter.dy - halfHeight) {
        edgeY = nodeCenter.dy - halfHeight;
        edgeX = nodeCenter.dx - halfHeight / tan(angle);
      }
    } else {
      // Intersects with top or bottom edge
      edgeY = nodeCenter.dy + (dy > 0 ? halfHeight : -halfHeight);
      edgeX = nodeCenter.dx + (dy > 0 ? halfHeight : -halfHeight) / tan(angle);
      
      if (edgeX > nodeCenter.dx + halfWidth) {
        edgeX = nodeCenter.dx + halfWidth;
        edgeY = nodeCenter.dy + halfWidth * tan(angle);
      } else if (edgeX < nodeCenter.dx - halfWidth) {
        edgeX = nodeCenter.dx - halfWidth;
        edgeY = nodeCenter.dy - halfWidth * tan(angle);
      }
    }
    
    return Offset(edgeX, edgeY);
  }

  void _drawArrow(Canvas canvas, Offset arrowTip, Offset arrowBase, Paint paint) {
    const arrowLength = 8.0;
    const arrowAngle = 0.5; // radians
    
    final dx = arrowTip.dx - arrowBase.dx;
    final dy = arrowTip.dy - arrowBase.dy;
    final angle = atan2(dy, dx);
    
    final arrowPoint1 = Offset(
      arrowTip.dx - arrowLength * cos(angle - arrowAngle),
      arrowTip.dy - arrowLength * sin(angle - arrowAngle),
    );
    
    final arrowPoint2 = Offset(
      arrowTip.dx - arrowLength * cos(angle + arrowAngle),
      arrowTip.dy - arrowLength * sin(angle + arrowAngle),
    );
    
    final arrowPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();
    
    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(ConnectorPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
           oldDelegate.zoomLevel != zoomLevel ||
           oldDelegate.canvasOffset != canvasOffset;
  }
}

 