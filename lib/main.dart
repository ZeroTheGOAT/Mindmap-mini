import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/map_manager.dart';
import 'utils/constants.dart';
import 'pages/home_page.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the map manager
  final mapManager = MapManager();
  await mapManager.initialize();
  
  runApp(MyApp(mapManager: mapManager));
}

class MyApp extends StatelessWidget {
  final MapManager mapManager;

  const MyApp({
    Key? key,
    required this.mapManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: mapManager,
      child: Builder(
        builder: (_) {
          if (!LocalStorageService.hasSettingsBox) {
            return MaterialApp(
              title: 'MindMap Mini',
              debugShowCheckedModeBanner: false,
              theme: _buildLightTheme(),
              darkTheme: _buildDarkTheme(),
              themeMode: ThemeMode.system,
              home: HomePage(),
            );
          }
          return ValueListenableBuilder(
            valueListenable: LocalStorageService.settingsListenable(keys: [AppConstants.themeKey]),
            builder: (context, box, _) {
              final themeMode = LocalStorageService.getThemeMode();
              return MaterialApp(
                title: 'MindMap Mini',
                debugShowCheckedModeBanner: false,
                theme: _buildLightTheme(),
                darkTheme: _buildDarkTheme(),
                themeMode: themeMode,
                home: HomePage(),
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
          borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: AppConstants.titleStyle,
        titleMedium: AppConstants.subtitleStyle,
        bodyLarge: AppConstants.bodyStyle,
        bodySmall: AppConstants.captionStyle,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.darkPrimaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppConstants.darkBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.darkSurfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.darkPrimaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.darkPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppConstants.darkSurfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
          borderSide: BorderSide(color: AppConstants.darkPrimaryColor, width: 2),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: AppConstants.darkTitleStyle,
        titleMedium: AppConstants.darkSubtitleStyle,
        bodyLarge: AppConstants.darkBodyStyle,
        bodySmall: AppConstants.darkCaptionStyle,
      ),
    );
  }
}
