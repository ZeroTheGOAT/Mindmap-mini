# MindMap Mini - Demo Guide

## 🎯 What We Built

**MindMap Mini** is a complete offline Flutter mind mapping application with the following features:

### ✅ Core Features Implemented

1. **📱 Home Screen**
   - List of saved mind maps
   - Create new mind maps
   - Rename, duplicate, and delete maps
   - Clean, modern UI with cards

2. **🧠 Mind Map Canvas**
   - Infinite zoomable and pannable canvas
   - Drag and drop nodes
   - Add child nodes with long-press
   - Edit nodes inline
   - Delete nodes with confirmation
   - Auto-save functionality

3. **🔗 Node Connections**
   - Automatic line drawing between parent and child nodes
   - Arrow indicators showing relationships
   - Clean visual hierarchy

4. **💾 Local Storage**
   - Hive database for offline storage
   - Automatic saving of mind maps
   - Persistent data across app restarts

5. **🎨 UI/UX Features**
   - Material Design 3
   - Light and dark theme support
   - Color-coded nodes
   - Responsive design
   - Smooth animations

6. **⚙️ Settings Page**
   - Theme selection
   - Grid options (framework ready)
   - App information

## 🚀 How to Use

### Getting Started
1. **Install Dependencies**: `flutter pub get`
2. **Generate Code**: `flutter packages pub run build_runner build`
3. **Run the App**: `flutter run`

### Creating Your First Mind Map
1. Tap "New Mind Map" on the home screen
2. Enter a title (e.g., "Project Planning")
3. Start with the central idea node
4. Long-press nodes to add children
5. Drag nodes to rearrange
6. Pinch to zoom, drag to pan

### Node Management
- **Add Child**: Long-press any node → "Add Child"
- **Edit**: Tap a node to edit title/description
- **Delete**: Long-press → "Delete" (removes node and all children)
- **Move**: Drag nodes freely around the canvas

### Canvas Navigation
- **Zoom**: Pinch with two fingers or use zoom buttons
- **Pan**: Drag with one finger to move around
- **Center View**: Tap the center button to see all nodes
- **Reset Zoom**: Use the refresh button

## 🏗️ Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point with theme setup
├── models/
│   ├── mindmap_node.dart     # Node data model with Hive
│   └── mindmap.dart          # Mind map data model
├── pages/
│   ├── home_page.dart        # Mind map list and management
│   ├── mindmap_page.dart     # Main canvas interface
│   └── settings_page.dart    # App settings and info
├── widgets/
│   ├── node_widget.dart      # Draggable node with actions
│   ├── connector_painter.dart # Line drawing between nodes
│   └── canvas_view.dart      # Zoom/pan canvas with grid
├── services/
│   ├── local_storage_service.dart # Hive database operations
│   └── map_manager.dart      # Business logic and state
└── utils/
    └── constants.dart        # App-wide styling and config
```

### Key Technologies
- **Flutter 3.32.8** - UI framework
- **Hive 2.2.3** - Local NoSQL database
- **Provider 6.1.2** - State management
- **UUID 4.5.1** - Unique identifier generation

### Data Models
```dart
// MindMapNode - Individual nodes in the mind map
class MindMapNode {
  String id;           // Unique identifier
  String title;        // Node title
  String? description; // Optional description
  String? parentId;    // Parent node ID (null for root)
  double x, y;         // Position coordinates
  Color color;         // Node color
  DateTime createdAt;  // Creation timestamp
  DateTime updatedAt;  // Last update timestamp
}

// MindMap - Complete mind map with all nodes
class MindMap {
  String id;                    // Unique identifier
  String title;                 // Map title
  List<MindMapNode> nodes;      // All nodes in the map
  double zoomLevel;             // Current zoom level
  double offsetX, offsetY;      // Canvas offset
  DateTime createdAt;           // Creation timestamp
  DateTime updatedAt;           // Last update timestamp
}
```

## 🎨 Design Features

### Color Palette
- **Primary**: Blue (#2196F3)
- **Node Colors**: 8 predefined colors cycling through nodes
- **Dark Theme**: Dark backgrounds with light text
- **Light Theme**: Light backgrounds with dark text

### Responsive Design
- Works on various screen sizes
- Adaptive layouts
- Touch-friendly interactions
- Proper spacing and typography

## 🔧 Customization Options

### Easy to Modify
- **Node Colors**: Edit `AppConstants.nodeColors`
- **Node Sizes**: Modify `AppConstants.nodeMinWidth/Height`
- **Animations**: Adjust `AppConstants.animationDuration`
- **Styling**: Update `AppConstants` text styles

### Extensible Architecture
- Clean separation of concerns
- Provider pattern for state management
- Hive for flexible data storage
- Modular widget structure

## 🚀 Future Enhancements Ready

The app is designed to easily add:
- Export to image/PDF
- Grid background and snap-to-grid
- Undo/redo functionality
- Node icons and emojis
- Multi-select nodes
- Cloud sync
- Search functionality
- Mind map templates

## 📱 Demo Scenarios

### Scenario 1: Project Planning
1. Create "Project Planning" mind map
2. Add central node: "Website Redesign"
3. Add children: "Design", "Development", "Testing", "Deployment"
4. Add sub-children to each branch
5. Drag nodes to organize ideas

### Scenario 2: Brainstorming
1. Create "Ideas" mind map
2. Start with central concept
3. Rapidly add child nodes for different ideas
4. Use different colors for different categories
5. Rearrange to find connections

### Scenario 3: Study Notes
1. Create "Study Notes" mind map
2. Add main topics as root nodes
3. Add subtopics and details
4. Use descriptions for additional notes
5. Organize by dragging related concepts together

## 🎯 Key Benefits

1. **Offline-First**: Works without internet
2. **Fast & Lightweight**: Minimal dependencies
3. **Intuitive**: Natural touch interactions
4. **Flexible**: Unlimited nodes and depth
5. **Persistent**: Data saved automatically
6. **Modern**: Material Design 3 UI

---

**MindMap Mini** - A complete, production-ready mind mapping solution built with Flutter! 🧠✨ 