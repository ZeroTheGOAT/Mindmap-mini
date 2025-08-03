import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/map_manager.dart';
import '../models/mindmap.dart';
import '../utils/constants.dart';
import 'mindmap_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapManager>().initialize();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MindMap Mini'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MapManager>(
        builder: (context, mapManager, child) {
          if (mapManager.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppConstants.spacingMedium),
                  Text('Loading mind maps...'),
                ],
              ),
            );
          }

          if (mapManager.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.errorColor,
                  ),
                  SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    'Error: ${mapManager.error}',
                    style: AppConstants.bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppConstants.spacingMedium),
                  ElevatedButton(
                    onPressed: () => mapManager.initialize(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (mapManager.mindMaps.isEmpty) {
            return _buildEmptyState();
          }

          return _buildMindMapsList(mapManager);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateMapDialog,
        icon: Icon(Icons.add),
        label: Text('New Mind Map'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology,
            size: 80,
            color: AppConstants.primaryColor.withOpacity(0.6),
          ),
          SizedBox(height: AppConstants.spacingLarge),
          Text(
            'No mind maps yet',
            style: AppConstants.titleStyle,
          ),
          SizedBox(height: AppConstants.spacingMedium),
          Text(
            'Create your first mind map to start organizing your ideas',
            style: AppConstants.subtitleStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.spacingLarge),
          ElevatedButton.icon(
            onPressed: _showCreateMapDialog,
            icon: Icon(Icons.add),
            label: Text('Create Mind Map'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLarge,
                vertical: AppConstants.spacingMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMindMapsList(MapManager mapManager) {
    return ListView.builder(
      padding: EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: mapManager.mindMaps.length,
      itemBuilder: (context, index) {
        final mindMap = mapManager.mindMaps[index];
        return _buildMindMapCard(mindMap, mapManager);
      },
    );
  }

  Widget _buildMindMapCard(MindMap mindMap, MapManager mapManager) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    return Card(
      margin: EdgeInsets.only(bottom: AppConstants.spacingMedium),
      elevation: 2,
      child: InkWell(
        onTap: () => _openMindMap(mindMap),
        borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mindMap.title,
                      style: AppConstants.titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, mindMap, mapManager),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Rename'),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy),
                          title: Text('Duplicate'),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                        ),
                      ),
                    ],
                    child: Icon(Icons.more_vert),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: AppConstants.primaryColor,
                  ),
                  SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    '${mindMap.nodes.length} nodes',
                    style: AppConstants.captionStyle,
                  ),
                  Spacer(),
                  Text(
                    'Created: ${dateFormat.format(mindMap.createdAt)}',
                    style: AppConstants.captionStyle,
                  ),
                ],
              ),
              SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey,
                  ),
                  SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    'Updated: ${dateFormat.format(mindMap.updatedAt)} at ${timeFormat.format(mindMap.updatedAt)}',
                    style: AppConstants.captionStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateMapDialog() {
    _titleController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Mind Map'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Mind Map Title',
              hintText: 'Enter a title for your mind map',
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _createMindMap,
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createMindMap() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    Navigator.pop(context);

    final mapManager = context.read<MapManager>();
    final newMap = await mapManager.createNewMindMap(title: title);
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MindMapPage(mindMap: newMap),
        ),
      );
    }
  }

  void _openMindMap(MindMap mindMap) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MindMapPage(mindMap: mindMap),
      ),
    );
  }

  void _handleMenuAction(String action, MindMap mindMap, MapManager mapManager) {
    switch (action) {
      case 'rename':
        _showRenameDialog(mindMap, mapManager);
        break;
      case 'duplicate':
        mapManager.duplicateMindMap(mindMap.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mind map duplicated')),
        );
        break;
      case 'delete':
        _showDeleteDialog(mindMap, mapManager);
        break;
    }
  }

  void _showRenameDialog(MindMap mindMap, MapManager mapManager) {
    _titleController.text = mindMap.title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Mind Map'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'New Title',
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newTitle = _titleController.text.trim();
                mapManager.renameMindMap(mindMap.id, newTitle);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mind map renamed')),
                );
              }
            },
            child: Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(MindMap mindMap, MapManager mapManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Mind Map'),
        content: Text(
          'Are you sure you want to delete "${mindMap.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              mapManager.deleteMindMap(mindMap.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mind map deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 