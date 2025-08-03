import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showGrid = false;
  bool _snapToGrid = false;
  double _gridSize = 20.0;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load settings from local storage
    setState(() {
      _showGrid = false;
      _snapToGrid = false;
      _gridSize = 20.0;
      _themeMode = ThemeMode.system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppConstants.spacingMedium),
        children: [
          _buildSection(
            title: 'Appearance',
            children: [
              _buildThemeSelector(),
              Divider(),
              _buildGridSettings(),
            ],
          ),
          SizedBox(height: AppConstants.spacingLarge),
          _buildSection(
            title: 'About',
            children: [
              _buildAboutInfo(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppConstants.titleStyle.copyWith(
            color: AppConstants.primaryColor,
          ),
        ),
        SizedBox(height: AppConstants.spacingMedium),
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.spacingMedium),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: AppConstants.subtitleStyle,
        ),
        SizedBox(height: AppConstants.spacingSmall),
        DropdownButtonFormField<ThemeMode>(
          value: _themeMode,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMedium,
              vertical: AppConstants.spacingSmall,
            ),
          ),
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(Icons.brightness_auto),
                  SizedBox(width: AppConstants.spacingSmall),
                  Text('System'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(Icons.light_mode),
                  SizedBox(width: AppConstants.spacingSmall),
                  Text('Light'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: AppConstants.spacingSmall),
                  Text('Dark'),
                ],
              ),
            ),
          ],
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              setState(() {
                _themeMode = newValue;
              });
              // Update theme in the app
              // This would be handled by a theme provider
            }
          },
        ),
      ],
    );
  }

  Widget _buildGridSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Canvas Grid',
          style: AppConstants.subtitleStyle,
        ),
        SizedBox(height: AppConstants.spacingSmall),
        SwitchListTile(
          title: Text('Show Grid'),
          subtitle: Text('Display a grid background on the canvas'),
          value: _showGrid,
          onChanged: (bool value) {
            setState(() {
              _showGrid = value;
            });
            // Save setting
          },
        ),
        SwitchListTile(
          title: Text('Snap to Grid'),
          subtitle: Text('Snap nodes to grid lines when dragging'),
          value: _snapToGrid,
          onChanged: (bool value) {
            setState(() {
              _snapToGrid = value;
            });
            // Save setting
          },
        ),
        if (_showGrid || _snapToGrid) ...[
          SizedBox(height: AppConstants.spacingSmall),
          Text(
            'Grid Size',
            style: AppConstants.captionStyle,
          ),
          Slider(
            value: _gridSize,
            min: 10.0,
            max: 50.0,
            divisions: 8,
            label: '${_gridSize.round()}px',
            onChanged: (double value) {
              setState(() {
                _gridSize = value;
              });
              // Save setting
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAboutInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.psychology,
              size: 48,
              color: AppConstants.primaryColor,
            ),
            SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MindMap Mini',
                    style: AppConstants.titleStyle,
                  ),
                  Text(
                    'Version 1.0.0',
                    style: AppConstants.captionStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.spacingMedium),
        Text(
          'A clean and intuitive mind mapping tool for organizing your ideas visually.',
          style: AppConstants.bodyStyle,
        ),
        SizedBox(height: AppConstants.spacingMedium),
        _buildFeatureList(),
        SizedBox(height: AppConstants.spacingMedium),
        Text(
          'Features:',
          style: AppConstants.subtitleStyle,
        ),
        SizedBox(height: AppConstants.spacingSmall),
        _buildFeatureItem('Create unlimited nested nodes'),
        _buildFeatureItem('Drag and drop nodes freely'),
        _buildFeatureItem('Zoom and pan the canvas'),
        _buildFeatureItem('Save and load mind maps locally'),
        _buildFeatureItem('Works completely offline'),
        _buildFeatureItem('Clean, distraction-free interface'),
      ],
    );
  }

  Widget _buildFeatureList() {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Features:',
            style: AppConstants.subtitleStyle.copyWith(
              color: AppConstants.primaryColor,
            ),
          ),
          SizedBox(height: AppConstants.spacingSmall),
          _buildFeatureItem('✨ Create unlimited nested nodes'),
          _buildFeatureItem('🎯 Drag and drop nodes freely'),
          _buildFeatureItem('🔍 Zoom and pan the canvas'),
          _buildFeatureItem('💾 Save and load mind maps locally'),
          _buildFeatureItem('📱 Works completely offline'),
          _buildFeatureItem('🎨 Clean, distraction-free interface'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppConstants.primaryColor,
          ),
          SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: AppConstants.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }
} 