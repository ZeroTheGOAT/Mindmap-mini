# MindMap Mini

A clean and intuitive offline Flutter app for creating and organizing mind maps. MindMap Mini allows users to visually organize ideas using a tree-like structure with unlimited nested nodes, drag-and-drop functionality, and local storage.

## 🎯 Features

### Core Functionality
- **Create unlimited nested nodes** - Build complex mind maps with unlimited depth
- **Drag and drop nodes** - Freely rearrange nodes by dragging them across the canvas
- **Zoom and pan** - Pinch to zoom and pan around the infinite canvas
- **Local storage** - Save and load mind maps using Hive database
- **Offline-first** - Works completely without internet access

### User Interface
- **Clean, distraction-free design** - Minimal interface focused on content
- **Color-coded nodes** - Each node gets a unique color from a predefined palette
- **Responsive layout** - Works on various screen sizes
- **Dark and light themes** - Support for both light and dark modes

### Node Management
- **Add child nodes** - Right-click or long-press to add child nodes
- **Edit nodes** - Tap to edit node title and description
- **Delete nodes** - Remove nodes and their children recursively
- **Node descriptions** - Add optional descriptions to nodes

### Canvas Features
- **Infinite canvas** - Pan in any direction without limits
- **Zoom controls** - Buttons for zoom in, zoom out, and reset zoom
- **Center view** - Automatically center the view on all nodes
- **Grid background** - Optional grid for better organization (coming soon)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mindmap_mini
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

### Creating a Mind Map
1. Tap the "New Mind Map" button on the home screen
2. Enter a title for your mind map
3. Start with a central idea node

### Adding Nodes
- **Add root node**: Tap the floating action button (+)
- **Add child node**: Long-press on any node and select "Add Child"
- **Edit node**: Tap on a node to edit its content

### Navigating the Canvas
- **Pan**: Drag with one finger to move around
- **Zoom**: Pinch with two fingers to zoom in/out
- **Zoom buttons**: Use the zoom controls on the right side
- **Center view**: Tap the center button to view all nodes

### Managing Mind Maps
- **Save**: Mind maps are automatically saved
- **Rename**: Use the menu on the home screen
- **Duplicate**: Create a copy of an existing mind map
- **Delete**: Remove mind maps permanently

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── mindmap_node.dart     # Node data model
│   └── mindmap.dart          # Mind map data model
├── pages/
│   ├── home_page.dart        # Mind map list
│   ├── mindmap_page.dart     # Canvas view
│   └── settings_page.dart    # App settings
├── widgets/
│   ├── node_widget.dart      # Draggable node widget
│   ├── connector_painter.dart # Line drawing between nodes
│   └── canvas_view.dart      # Main canvas with zoom/pan
├── services/
│   ├── local_storage_service.dart # Hive database operations
│   └── map_manager.dart      # Business logic and state management
└── utils/
    └── constants.dart        # App-wide constants and styles
```

### Key Technologies
- **Flutter** - UI framework
- **Hive** - Local NoSQL database
- **Provider** - State management
- **UUID** - Unique identifier generation

### Data Models

#### MindMapNode
```dart
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
```

#### MindMap
```dart
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

## 🎨 Customization

### Colors
Node colors are defined in `lib/utils/constants.dart`:
```dart
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
```

### Styling
All app styling constants are in `lib/utils/constants.dart`:
- Node dimensions
- Spacing values
- Animation durations
- Text styles

## 🔧 Development

### Adding New Features
1. Create feature branch
2. Implement changes
3. Update tests if applicable
4. Run `flutter analyze` to check for issues
5. Submit pull request

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📦 Dependencies

### Core Dependencies
- `flutter` - UI framework
- `hive` - Local NoSQL database
- `hive_flutter` - Flutter integration for Hive
- `provider` - State management
- `uuid` - Unique identifier generation
- `intl` - Internationalization and formatting

### Development Dependencies
- `flutter_test` - Testing framework
- `flutter_lints` - Code linting
- `hive_generator` - Code generation for Hive
- `build_runner` - Code generation runner

## 🚀 Future Enhancements

### Planned Features
- [ ] Export mind maps as images/PDF
- [ ] Grid background and snap-to-grid
- [ ] Undo/redo functionality
- [ ] Node icons and emojis
- [ ] Multi-select nodes
- [ ] Color-coded branches
- [ ] Mind map templates
- [ ] Search functionality
- [ ] Cloud sync (optional)

### Performance Optimizations
- [ ] Virtual scrolling for large mind maps
- [ ] Canvas rendering optimizations
- [ ] Memory usage improvements

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive team for the lightweight database
- Material Design for the design system
- All contributors and users of MindMap Mini

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/your-repo/mindmap_mini/issues) page
2. Create a new issue with detailed information
3. Include device information and steps to reproduce

---

**MindMap Mini** - Organize your thoughts, one node at a time! 🧠✨
