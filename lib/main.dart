import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wallpaper_provider.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WallpaperProvider and load settings
  final wallpaperProvider = WallpaperProvider();
  await wallpaperProvider.loadSettings();

  runApp(MyApp(wallpaperProvider: wallpaperProvider));
}

class MyApp extends StatelessWidget {
  final WallpaperProvider wallpaperProvider;

  const MyApp({super.key, required this.wallpaperProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: wallpaperProvider)],
      child: MaterialApp(
        title: 'BrainPaper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainScreen(),
      ),
    );
  }
}
