import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';

class StyleSelector extends StatelessWidget {
  const StyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Style", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              _StyleOption(
                label: "Solid",
                isSelected: provider.style == WallpaperStyle.solid,
                onTap: () => provider.setStyle(WallpaperStyle.solid),
              ),
              const SizedBox(width: 10),
              _StyleOption(
                label: "Gradient",
                isSelected: provider.style == WallpaperStyle.gradient,
                onTap: () => provider.setStyle(WallpaperStyle.gradient),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (provider.style == WallpaperStyle.solid)
            _ColorPicker(
              selectedColor: provider.backgroundColor,
              onColorSelected: provider.setBackgroundColor,
            )
          else if (provider.style == WallpaperStyle.gradient)
            _GradientPicker(
              selectedColors: provider.gradientColors,
              onColorsSelected: provider.setGradientColors,
            ),
          const SizedBox(height: 20),
          Text("Text Color", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          _ColorPicker(
            selectedColor: provider.textColor,
            onColorSelected: provider.setTextColor,
          ),
        ],
      ),
    );
  }
}

class _StyleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
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
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: selectedColor == color
                    ? [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          blurRadius: 0,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
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
    [Colors.blue, Colors.purple],
    [Colors.red, Colors.orange],
    [Colors.green, Colors.teal],
    [Colors.indigo, Colors.pink],
    [Colors.black, Colors.grey],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
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
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          blurRadius: 0,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
