import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/wallpaper_model.dart';
import '../models/brain_text.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/wallpaper_preview.dart';
import 'editor_screen.dart';

class TemplatesScreen extends StatelessWidget {
  static final List<WallpaperModel> templates = [
    WallpaperModel(
      id: 'template_1',
      name: 'Highland Mist',
      style: WallpaperStyle.pattern,
      backgroundColor: Colors.black.value,
      textColor: Colors.white.value,
      fontSize: 32.0,
      fontFamily: 'Outfit',
      textAlign: 2,
      gradientColors: [0xFF667EEA, 0xFF764BA2],
      selectedArtIndex: 1,
      overlayOpacity: 0.3,
      texts: [BrainText(text: 'Focus on the journey')],
      createdAt: DateTime.now(),
    ),
    WallpaperModel(
      id: 'template_2',
      name: 'Clean Slate',
      style: WallpaperStyle.solid,
      backgroundColor: 0xFFF1F5F9,
      textColor: 0xFF1E293B,
      fontSize: 40.0,
      fontFamily: 'Inter',
      textAlign: 2,
      gradientColors: [0xFF4FACFE, 0xFF00F2FE],
      selectedArtIndex: 4,
      overlayOpacity: 0.1,
      texts: [BrainText(text: 'Simplify everything')],
      createdAt: DateTime.now(),
    ),
    WallpaperModel(
      id: 'template_3',
      name: 'Cyberpunk',
      style: WallpaperStyle.gradient,
      backgroundColor: Colors.black.value,
      textColor: Colors.white.value,
      fontSize: 48.0,
      fontFamily: 'Space Mono',
      textAlign: 2,
      gradientColors: [0xFF667EEA, 0xFF764BA2],
      selectedArtIndex: 0,
      overlayOpacity: 0.4,
      texts: [BrainText(text: 'Future is now')],
      createdAt: DateTime.now(),
    ),
    WallpaperModel(
      id: 'template_4',
      name: 'Cotton Candy',
      style: WallpaperStyle.gradient,
      backgroundColor: Colors.white.value,
      textColor: Colors.black.value,
      fontSize: 36.0,
      fontFamily: 'Poppins',
      textAlign: 2,
      gradientColors: [0xFFF093FB, 0xFFF5576C],
      selectedArtIndex: 3,
      overlayOpacity: 0.2,
      texts: [BrainText(text: 'Stay Sweet')],
      createdAt: DateTime.now(),
    ),
    WallpaperModel(
      id: 'template_5',
      name: 'Deep Focus',
      style: WallpaperStyle.pattern,
      backgroundColor: Colors.black.value,
      textColor: Colors.white.value,
      fontSize: 28.0,
      fontFamily: 'Lora',
      textAlign: 2,
      gradientColors: [0xFF30CFD0, 0xFF330867],
      selectedArtIndex: 2,
      overlayOpacity: 0.5,
      texts: [BrainText(text: 'Deep Work')],
      createdAt: DateTime.now(),
    ),
    WallpaperModel(
      id: 'template_6',
      name: 'Ocean Breeze',
      style: WallpaperStyle.gradient,
      backgroundColor: Colors.black.value,
      textColor: Colors.white.value,
      fontSize: 42.0,
      fontFamily: 'Montserrat',
      textAlign: 2,
      gradientColors: [0xFF4FACFE, 0xFF00F2FE],
      selectedArtIndex: 5,
      overlayOpacity: 0.2,
      texts: [BrainText(text: 'Flow with the tide')],
      createdAt: DateTime.now(),
    ),
  ];

  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          _buildFilters(context),
          _buildMasonryGrid(context),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gallery',
                  style: GoogleFonts.getFont(
                    'Inter',
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                ),
                _buildCircleIcon(Icons.notifications_outlined),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search by mood, color, or style...',
                  border: InputBorder.none,
                  icon: Icon(Icons.tune, color: AppColors.mutedForeground),
                  suffixIcon: Icon(Icons.filter_list),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.foreground),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = [
      'Trending',
      'Minimalist',
      'Dark Mode',
      'Nature',
      'Abstract',
    ];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final isSelected = index == 0;
            return Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.foreground,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMasonryGrid(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return _buildTemplateCard(context, templates[index]);
        }, childCount: templates.length),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, WallpaperModel wp) {
    return GestureDetector(
      onTap: () {
        context.read<WallpaperProvider>().setActiveWallpaper(wp);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditorScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  WallpaperPreview(wallpaper: wp, useScale: true),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 10,
                            color: Colors.orangeAccent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '2.4k',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wp.name ?? 'Untitled',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '@brainpaper',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: AppColors.mutedForeground,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
