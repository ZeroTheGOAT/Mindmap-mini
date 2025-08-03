import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);
  
  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkPrimaryColor = Color(0xFF90CAF9);
  
  // Node colors
  static const List<Color> nodeColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF795548), // Brown
  ];
  
  // Dimensions
  static const double nodeMinWidth = 120.0;
  static const double nodeMinHeight = 60.0;
  static const double nodeMaxWidth = 300.0;
  static const double nodePadding = 12.0;
  static const double nodeBorderRadius = 12.0;
  static const double connectorStrokeWidth = 2.0;
  static const double minZoomLevel = 0.1;
  static const double maxZoomLevel = 3.0;
  static const double defaultZoomLevel = 1.0;
  
  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  
  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration quickAnimationDuration = Duration(milliseconds: 150);
  
  // Text styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );
  
  // Dark theme text styles
  static const TextStyle darkTitleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle darkSubtitleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );
  
  static const TextStyle darkBodyStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  
  static const TextStyle darkCaptionStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
  
  // Hive box names
  static const String mindMapsBoxName = 'mindmaps';
  static const String settingsBoxName = 'settings';
  
  // Settings keys
  static const String themeKey = 'theme';
  static const String showGridKey = 'showGrid';
  static const String snapToGridKey = 'snapToGrid';
  static const String gridSizeKey = 'gridSize';
  
  // Default values
  static const bool defaultShowGrid = false;
  static const bool defaultSnapToGrid = false;
  static const double defaultGridSize = 20.0;
} 