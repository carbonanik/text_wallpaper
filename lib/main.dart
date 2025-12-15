import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'providers/wallpaper_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize TodoProvider and load saved todos
  final todoProvider = TodoProvider();
  await todoProvider.loadTodos();

  // Initialize WallpaperProvider and load settings
  final wallpaperProvider = WallpaperProvider();
  await wallpaperProvider.loadSettings();

  runApp(
    MyApp(todoProvider: todoProvider, wallpaperProvider: wallpaperProvider),
  );
}

class MyApp extends StatelessWidget {
  final TodoProvider todoProvider;
  final WallpaperProvider wallpaperProvider;

  const MyApp({
    super.key,
    required this.todoProvider,
    required this.wallpaperProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: todoProvider),
        ChangeNotifierProvider.value(value: wallpaperProvider),
      ],
      child: MaterialApp(
        title: 'Text Wallpaper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
