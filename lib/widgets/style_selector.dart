import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/pickers.dart';

class StyleSelector extends StatelessWidget {
  const StyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      snap: true,
      snapSizes: const [0.1, 0.4],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(28, 8, 28, 120),
                  children: [
                    _buildSectionLabel(
                      'BACKGROUND STYLE',
                      Icons.layers_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildStyleTabs(provider),
                    const SizedBox(height: 32),

                    if (provider.style == WallpaperStyle.pattern) ...[
                      _buildSectionLabel('SELECT ART', Icons.image_outlined),
                      const SizedBox(height: 12),
                      ArtPicker(
                        selectedIndex: provider.selectedArtIndex,
                        onArtSelected: provider.setArtIndex,
                      ),
                      const SizedBox(height: 24),
                      _buildSlider(
                        context,
                        'Dimness',
                        provider.overlayOpacity,
                        provider.setOverlayOpacity,
                        Icons.wb_sunny_outlined,
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (provider.style == WallpaperStyle.solid) ...[
                      _buildSectionLabel(
                        'BACKGROUND COLOR',
                        Icons.palette_outlined,
                      ),
                      const SizedBox(height: 12),
                      ColorPicker(
                        selectedColor: provider.backgroundColor,
                        onColorSelected: provider.setBackgroundColor,
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (provider.style == WallpaperStyle.gradient) ...[
                      _buildSectionLabel('GRADIENT COLORS', Icons.gradient),
                      const SizedBox(height: 12),
                      GradientPicker(
                        selectedColors: provider.gradientColors,
                        onColorsSelected: provider.setGradientColors,
                      ),
                      const SizedBox(height: 32),
                    ],

                    _buildSectionLabel('TYPOGRAPHY', Icons.text_fields),
                    const SizedBox(height: 12),
                    FontPicker(
                      selectedFont: provider.fontFamily,
                      onFontSelected: provider.setFontFamily,
                    ),
                    const SizedBox(height: 24),
                    _buildSlider(
                      context,
                      'Text Size',
                      provider.fontSize / 96,
                      (v) => provider.setFontSize(v * 96),
                      Icons.format_size,
                    ),
                    const SizedBox(height: 32),

                    _buildSectionLabel('TEXT COLOR', Icons.color_lens_outlined),
                    const SizedBox(height: 12),
                    ColorPicker(
                      selectedColor: provider.textColor,
                      onColorSelected: provider.setTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.mutedForeground,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStyleTabs(WallpaperProvider provider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildStyleTab(
            'Image',
            Icons.image_outlined,
            provider.style == WallpaperStyle.pattern,
            () => provider.setStyle(WallpaperStyle.pattern),
          ),
          _buildStyleTab(
            'Solid',
            Icons.stop,
            provider.style == WallpaperStyle.solid,
            () => provider.setStyle(WallpaperStyle.solid),
          ),
          _buildStyleTab(
            'Gradient',
            Icons.gradient,
            provider.style == WallpaperStyle.gradient,
            () => provider.setStyle(WallpaperStyle.gradient),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleTab(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.mutedForeground,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.foreground
                      : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    double value,
    Function(double) onChanged,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.mutedForeground),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(value * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(value: value.clamp(0.0, 1.0), onChanged: onChanged),
        ),
      ],
    );
  }
}
