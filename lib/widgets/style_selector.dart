import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/wallpaper_provider.dart';

class StyleSelector extends StatelessWidget {
  const StyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.4, // Start at 40% of screen height
      minChildSize: 0.1, // Can collapse to 10% (mostly hidden)
      maxChildSize: 0.4, // Can expand to 70% of screen height
      snap: true,
      snapSizes: const [0.1, 0.4],
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Style Section
                  Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        size: 20,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Background Style",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _StyleOption(
                        label: "Solid",
                        icon: Icons.square,
                        isSelected: provider.style == WallpaperStyle.solid,
                        onTap: () => provider.setStyle(WallpaperStyle.solid),
                      ),
                      const SizedBox(width: 12),
                      _StyleOption(
                        label: "Gradient",
                        icon: Icons.gradient,
                        isSelected: provider.style == WallpaperStyle.gradient,
                        onTap: () => provider.setStyle(WallpaperStyle.gradient),
                      ),
                      const SizedBox(width: 12),
                      _StyleOption(
                        label: "Image",
                        icon: Icons.image,
                        isSelected: provider.style == WallpaperStyle.pattern,
                        onTap: () => provider.setStyle(WallpaperStyle.pattern),
                      ),
                    ],
                  ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Color Picker Section
                  if (provider.style == WallpaperStyle.solid)
                    _ColorSection(
                      title: "Background Color",
                      icon: Icons.format_color_fill,
                      child: _ColorPicker(
                        selectedColor: provider.backgroundColor,
                        onColorSelected: provider.setBackgroundColor,
                      ),
                    )
                  else if (provider.style == WallpaperStyle.gradient)
                    _ColorSection(
                      title: "Gradient Colors",
                      icon: Icons.gradient,
                      child: _GradientPicker(
                        selectedColors: provider.gradientColors,
                        onColorsSelected: provider.setGradientColors,
                      ),
                    )
                  else if (provider.style == WallpaperStyle.pattern)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ColorSection(
                          title: "Select Art",
                          icon: Icons.image_search,
                          child: _ArtPicker(
                            selectedIndex: provider.selectedArtIndex,
                            onArtSelected: provider.setArtIndex,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Dimness",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: provider.overlayOpacity,
                                min: 0.0,
                                max: 0.8,
                                onChanged: provider.setOverlayOpacity,
                              ),
                            ),
                            Text(
                              "${(provider.overlayOpacity * 100).toInt()}%",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Typography Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.text_fields,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Typography",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Font Family Picker
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              [
                                'Outfit',
                                'Roboto',
                                'Lora',
                                'Montserrat',
                                'Poppins',
                                'Oswald',
                                'Playfair Display',
                                'Inter',
                              ].map((font) {
                                final isSelected = provider.fontFamily == font;
                                return GestureDetector(
                                  onTap: () => provider.setFontFamily(font),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      font,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Font Size Slider
                      Row(
                        children: [
                          Text(
                            "Size",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: provider.fontSize,
                              min: 12.0,
                              max: 96.0,
                              onChanged: provider.setFontSize,
                            ),
                          ),
                          Text(
                            provider.fontSize.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Text Color Section
                  _ColorSection(
                    title: "Text Color",
                    icon: Icons.color_lens,
                    child: _ColorPicker(
                      selectedColor: provider.textColor,
                      onColorSelected: provider.setTextColor,
                    ),
                  ),

                  // Bottom Padding
                  const SizedBox(height: 124),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ColorSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ColorSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _StyleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              : Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const _ColorPicker({
    required this.selectedColor,
    required this.onColorSelected,
  });

  static const List<Color> colors = [
    Colors.black,
    Colors.white,
    Color(0xFFEF4444), // Modern red
    Color(0xFF10B981), // Modern green
    Color(0xFF3B82F6), // Modern blue
    Color(0xFFF59E0B), // Modern amber
    Color(0xFF8B5CF6), // Modern purple
    Color(0xFFEC4899), // Modern pink
    Color(0xFF14B8A6), // Modern teal
    Color(0xFF6366F1), // Modern indigo
    ///
    Color(0xFF1A1A2E), // Deep navy - for Blue gradient
    Color(0xFF2D1B4E), // Deep purple - for Sunset gradient
    Color(0xFF4A4A6A), // Slate gray - for Pastel gradient
    Color(0xFFFEE140), // Bright yellow accent
    Color(0xFF00F2FE), // Cyan accent
    Color(0xFFFF6A88), // Coral accent
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = selectedColor == color;

          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color == Colors.white
                      ? Colors.grey.shade300
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: isSelected ? 12 : 4,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: color == Colors.white || color == Colors.yellow
                          ? Colors.grey.shade800
                          : Colors.white,
                      size: 24,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _GradientPicker extends StatelessWidget {
  final List<Color> selectedColors;
  final Function(List<Color>) onColorsSelected;

  const _GradientPicker({
    required this.selectedColors,
    required this.onColorsSelected,
  });

  static const List<List<Color>> gradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)], // Purple
    [Color(0xFFF093FB), Color(0xFFF5576C)], // Pink
    [Color(0xFF4FACFE), Color(0xFF00F2FE)], // Blue
    [Color(0xFF43E97B), Color(0xFF38F9D7)], // Green
    [Color(0xFFFA709A), Color(0xFFFEE140)], // Sunset
    [Color(0xFF30CFD0), Color(0xFF330867)], // Ocean
    [Color(0xFFA8EDEA), Color(0xFFFED6E3)], // Pastel
    [Color(0xFFFF9A56), Color(0xFFFF6A88)], // Warm
    [Colors.black, Colors.grey],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gradients.length,
        itemBuilder: (context, index) {
          final gradient = gradients[index];
          final isSelected =
              selectedColors.length == gradient.length &&
              selectedColors[0] == gradient[0] &&
              selectedColors[1] == gradient[1];

          return GestureDetector(
            onTap: () => onColorsSelected(gradient),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.3),
                    blurRadius: isSelected ? 12 : 4,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _ArtPicker extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onArtSelected;

  const _ArtPicker({required this.selectedIndex, required this.onArtSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: WallpaperProvider.artImages.length,
        itemBuilder: (context, index) {
          final imageUrl = WallpaperProvider.artImages[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onArtSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey.shade500,
                            size: 24,
                          ),
                        );
                      },
                    ),
                    if (isSelected)
                      Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
