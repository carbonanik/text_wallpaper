import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/todo_provider.dart';
import '../providers/wallpaper_provider.dart';

class WallpaperPreview extends StatelessWidget {
  const WallpaperPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TodoProvider, WallpaperProvider>(
      builder: (context, todoProvider, wallpaperProvider, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: wallpaperProvider.style == WallpaperStyle.solid
                ? wallpaperProvider.backgroundColor
                : null,
            gradient: wallpaperProvider.style == WallpaperStyle.gradient
                ? LinearGradient(
                    colors: wallpaperProvider.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            image: wallpaperProvider.style == WallpaperStyle.pattern
                ? DecorationImage(
                    image: NetworkImage(
                      WallpaperProvider.artImages[wallpaperProvider
                          .selectedArtIndex],
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            children: [
              // Overlay for patterns
              if (wallpaperProvider.style == WallpaperStyle.pattern)
                Container(
                  color: Colors.black.withOpacity(
                    wallpaperProvider.overlayOpacity,
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (todoProvider.todos.isEmpty)
                        Text(
                          "No Tasks",
                          style: GoogleFonts.getFont(
                            wallpaperProvider.fontFamily,
                            color: wallpaperProvider.textColor.withOpacity(0.5),
                            fontSize: wallpaperProvider.fontSize,
                          ),
                        )
                      else
                        ...todoProvider.todos
                            .where((t) => !t.isDone)
                            .map(
                              (todo) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  todo.text,
                                  textAlign: wallpaperProvider.textAlign,
                                  style: GoogleFonts.getFont(
                                    wallpaperProvider.fontFamily,
                                    color: wallpaperProvider.textColor,
                                    fontSize: wallpaperProvider.fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
