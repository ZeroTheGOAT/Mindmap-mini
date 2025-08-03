import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/mindmap.dart';
import '../models/mindmap_node.dart';
import '../utils/constants.dart';
import 'local_storage_service.dart';

class MapManager extends ChangeNotifier {
  static final MapManager _instance = MapManager._internal();
  factory MapManager() => _instance;
  MapManager._internal();

  final Uuid _uuid = const Uuid();
  
  MindMap? _currentMindMap;
  List<MindMap> _mindMaps = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  MindMap? get currentMindMap => _currentMindMap;
  List<MindMap> get mindMaps => _mindMaps;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCurrentMap => _currentMindMap != null;

  // Initialize the manager
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await LocalStorageService.initialize();
      await _loadAllMindMaps();
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Create a new mind map
  Future<MindMap> createNewMindMap({String? title}) async {
    final newMap = MindMap(
      id: _uuid.v4(),
      title: title ?? 'New Mind Map',
      nodes: [
        MindMapNode(
          id: _uuid.v4(),
          title: 'Central Idea',
          x: 0,
          y: 0,
          color: AppConstants.nodeColors[0],
        ),
      ],
    );

    await LocalStorageService.saveMindMap(newMap);
    _mindMaps.add(newMap);
    _currentMindMap = newMap;
    notifyListeners();
    
    return newMap;
  }

  // Load a mind map
  Future<void> loadMindMap(String id) async {
    _setLoading(true);
    try {
      final mindMap = await LocalStorageService.loadMindMap(id);
      if (mindMap != null) {
        _currentMindMap = mindMap;
        _error = null;
      } else {
        _error = 'Mind map not found';
      }
    } catch (e) {
      _error = 'Failed to load mind map: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Save current mind map
  Future<void> saveCurrentMindMap() async {
    if (_currentMindMap == null) return;

    _setLoading(true);
    try {
      await LocalStorageService.saveMindMap(_currentMindMap!);
      
      // Update in the list
      final index = _mindMaps.indexWhere((map) => map.id == _currentMindMap!.id);
      if (index != -1) {
        _mindMaps[index] = _currentMindMap!;
      }
      
      _error = null;
    } catch (e) {
      _error = 'Failed to save mind map: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update current mind map
  void updateCurrentMindMap(MindMap updatedMap) {
    _currentMindMap = updatedMap;
    notifyListeners();
  }

  // Add node to current mind map
  void addNode({
    required String title,
    String? description,
    String? parentId,
    Offset? position,
    Color? color,
  }) {
    if (_currentMindMap == null) return;

    final node = MindMapNode(
      id: _uuid.v4(),
      title: title,
      description: description,
      parentId: parentId,
      x: position?.dx ?? 0,
      y: position?.dy ?? 0,
      color: color ?? AppConstants.nodeColors[_currentMindMap!.nodes.length % AppConstants.nodeColors.length],
    );

    _currentMindMap!.addNode(node);
    notifyListeners();
  }

  // Update node in current mind map
  void updateNode(MindMapNode updatedNode) {
    if (_currentMindMap == null) return;

    _currentMindMap!.updateNode(updatedNode);
    notifyListeners();
  }

  // Delete node from current mind map
  void deleteNode(String nodeId) {
    if (_currentMindMap == null) return;

    _currentMindMap!.deleteNode(nodeId);
    notifyListeners();
  }

  // Rename mind map
  Future<void> renameMindMap(String id, String newTitle) async {
    final mindMap = _mindMaps.firstWhere((map) => map.id == id);
    final updatedMap = mindMap.copyWith(title: newTitle);
    
    await LocalStorageService.saveMindMap(updatedMap);
    
    final index = _mindMaps.indexWhere((map) => map.id == id);
    if (index != -1) {
      _mindMaps[index] = updatedMap;
    }
    
    if (_currentMindMap?.id == id) {
      _currentMindMap = updatedMap;
    }
    
    notifyListeners();
  }

  // Duplicate mind map
  Future<MindMap> duplicateMindMap(String id) async {
    final originalMap = _mindMaps.firstWhere((map) => map.id == id);
    
    // Create new IDs for all nodes
    final nodeIdMap = <String, String>{};
    final duplicatedNodes = originalMap.nodes.map((node) {
      final newId = _uuid.v4();
      nodeIdMap[node.id] = newId;
      
      return node.copyWith(
        id: newId,
        parentId: node.parentId != null ? nodeIdMap[node.parentId!] : null,
      );
    }).toList();

    final duplicatedMap = MindMap(
      id: _uuid.v4(),
      title: '${originalMap.title} (Copy)',
      nodes: duplicatedNodes,
    );

    await LocalStorageService.saveMindMap(duplicatedMap);
    _mindMaps.add(duplicatedMap);
    notifyListeners();
    
    return duplicatedMap;
  }

  // Delete mind map
  Future<void> deleteMindMap(String id) async {
    await LocalStorageService.deleteMindMap(id);
    _mindMaps.removeWhere((map) => map.id == id);
    
    if (_currentMindMap?.id == id) {
      _currentMindMap = null;
    }
    
    notifyListeners();
  }

  // Clear current mind map
  void clearCurrentMindMap() {
    _currentMindMap = null;
    notifyListeners();
  }

  // Load all mind maps
  Future<void> _loadAllMindMaps() async {
    _mindMaps = LocalStorageService.getAllMindMaps();
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
  }
} 