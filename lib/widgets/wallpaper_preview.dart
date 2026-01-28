import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/wallpaper_provider.dart';
import '../models/wallpaper_model.dart';

class WallpaperPreview extends StatelessWidget {
  final WallpaperModel? wallpaper;
  final bool useScale;

  const WallpaperPreview({super.key, this.wallpaper, this.useScale = true});

  @override
  Widget build(BuildContext context) {
    // If no wallpaper is provided, watch the active one from the provider
    final activeWallpaper = context.watch<WallpaperProvider>().activeWallpaper;
    final wp = wallpaper ?? activeWallpaper;
    final texts = wp.texts;

    final width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = useScale ? (constraints.maxWidth / width) : 1.0;
        final double scaledFontSize = wp.fontSize * scale;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Background Layer
            _buildBackground(wp),

            // Text Layer
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (texts.isEmpty)
                      Text(
                        "BrainPaper",
                        style: GoogleFonts.getFont(
                          wp.fontFamily,
                          textStyle: TextStyle(
                            fontSize: scaledFontSize,
                            fontWeight: FontWeight.bold,
                            color: Color(wp.textColor),
                          ),
                        ),
                      )
                    else
                      ...texts.map(
                        (item) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4 * scale),
                          child: Text(
                            item.text,
                            textAlign: TextAlign.values[wp.textAlign],
                            style: GoogleFonts.getFont(
                              wp.fontFamily,
                              textStyle: TextStyle(
                                fontSize: scaledFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(wp.textColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackground(WallpaperModel wp) {
    switch (wp.style) {
      case WallpaperStyle.solid:
        return Container(color: Color(wp.backgroundColor));
      case WallpaperStyle.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: wp.gradientColors.map((c) => Color(c)).toList(),
            ),
          ),
        );
      case WallpaperStyle.pattern:
        return Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: WallpaperProvider.artImages[wp.selectedArtIndex],
              fit: BoxFit.cover,
            ),
            Container(color: Colors.black.withValues(alpha: wp.overlayOpacity)),
          ],
        );
    }
  }
}
