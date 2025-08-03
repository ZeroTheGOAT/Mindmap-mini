import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mindmap.dart';
import '../models/mindmap_node.dart';
import '../utils/constants.dart';

class LocalStorageService {
  static const String _mindMapsBoxName = AppConstants.mindMapsBoxName;
  static const String _settingsBoxName = AppConstants.settingsBoxName;
  
  static Box<MindMap>? _mindMapsBox;
  static Box? _settingsBox;
  
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(MindMapNodeAdapter());
    Hive.registerAdapter(MindMapAdapter());
    
    // Open boxes
    _mindMapsBox = await Hive.openBox<MindMap>(_mindMapsBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }
  
  // Mind Maps operations
  static Future<void> saveMindMap(MindMap mindMap) async {
    await _mindMapsBox?.put(mindMap.id, mindMap);
  }
  
  static Future<MindMap?> loadMindMap(String id) async {
    return _mindMapsBox?.get(id);
  }
  
  static List<MindMap> getAllMindMaps() {
    return _mindMapsBox?.values.toList() ?? [];
  }
  
  static Future<void> deleteMindMap(String id) async {
    await _mindMapsBox?.delete(id);
  }
  
  static Future<void> deleteAllMindMaps() async {
    await _mindMapsBox?.clear();
  }
  
  // Settings operations
  static Future<void> saveSetting<T>(String key, T value) async {
    await _settingsBox?.put(key, value);
  }
  
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox?.get(key, defaultValue: defaultValue) as T?;
  }
  
  static Future<void> deleteSetting(String key) async {
    await _settingsBox?.delete(key);
  }
  
  static Future<void> clearAllSettings() async {
    await _settingsBox?.clear();
  }
  
  // Convenience methods for common settings
  static bool getShowGrid() {
    return getSetting<bool>(AppConstants.showGridKey, defaultValue: AppConstants.defaultShowGrid) ?? AppConstants.defaultShowGrid;
  }
  
  static Future<void> setShowGrid(bool value) async {
    await saveSetting(AppConstants.showGridKey, value);
  }
  
  static bool getSnapToGrid() {
    return getSetting<bool>(AppConstants.snapToGridKey, defaultValue: AppConstants.defaultSnapToGrid) ?? AppConstants.defaultSnapToGrid;
  }
  
  static Future<void> setSnapToGrid(bool value) async {
    await saveSetting(AppConstants.snapToGridKey, value);
  }
  
  static double getGridSize() {
    return getSetting<double>(AppConstants.gridSizeKey, defaultValue: AppConstants.defaultGridSize) ?? AppConstants.defaultGridSize;
  }
  
  static Future<void> setGridSize(double value) async {
    await saveSetting(AppConstants.gridSizeKey, value);
  }
  
  static ThemeMode getThemeMode() {
    final themeIndex = getSetting<int>(AppConstants.themeKey, defaultValue: 0) ?? 0;
    return ThemeMode.values[themeIndex];
  }
  
  static Future<void> setThemeMode(ThemeMode mode) async {
    await saveSetting(AppConstants.themeKey, mode.index);
  }
  
  // Close boxes
  static Future<void> close() async {
    await _mindMapsBox?.close();
    await _settingsBox?.close();
  }
} 