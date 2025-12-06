import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'dart:io';
import '../providers/todo_provider.dart';
import '../widgets/wallpaper_preview.dart';
import '../widgets/style_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todoController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSaving = false;

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_todoController.text.isNotEmpty) {
      Provider.of<TodoProvider>(
        context,
        listen: false,
      ).addTodo(_todoController.text);
      _todoController.clear();
    }
  }

  Future<void> _saveWallpaper() async {
    setState(() => _isSaving = true);
    try {
      // Request permissions
      if (!await Permission.photos.request().isGranted &&
          !await Permission.storage.request().isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Permission denied')));
        }
        return;
      }

      // Capture screenshot
      final directory = await getTemporaryDirectory();

      final image = await _screenshotController.captureAndSave(
        directory.path,
        fileName: 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.png',
        pixelRatio: 3.0, // High quality
      );

      if (image != null) {
        // Save to gallery using gal
        await Gal.putImage(image);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wallpaper saved to gallery! Setting wallpaper...'),
            ),
          );
        }

        // Set wallpaper
        try {
          final wallpaperManager = WallpaperManagerPlus();
          await wallpaperManager.setWallpaper(
            File(image),
            WallpaperManagerPlus.homeScreen,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Wallpaper set successfully!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error setting wallpaper: $e')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving wallpaper: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _todoController,
          decoration: const InputDecoration(
            hintText: 'Enter task...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) {
            _addTodo();
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTodo();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _clearAllTodos() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    if (todoProvider.todos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No tasks to clear')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('Are you sure you want to clear all tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              todoProvider.clearAllTodos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All tasks cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wallpaper Preview (Background)
          Screenshot(
            controller: _screenshotController,
            child: const WallpaperPreview(),
          ),

          // UI Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Text Wallpaper',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _clearAllTodos,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveWallpaper,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.wallpaper),
                        label: const Text('Set Wallpaper'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Style Selector Bottom Sheet (Draggable)
          const StyleSelector(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
