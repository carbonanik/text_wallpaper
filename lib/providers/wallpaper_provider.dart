import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum WallpaperStyle { solid, gradient, pattern }

class WallpaperProvider with ChangeNotifier {
  WallpaperStyle _style = WallpaperStyle.solid;
  Color _backgroundColor = Colors.black;
  Color _textColor = Colors.white;
  double _fontSize = 24.0;
  TextAlign _textAlign = TextAlign.center;
  List<Color> _gradientColors = [Colors.blue, Colors.purple];
  String _fontFamily = 'Outfit';
  int _selectedArtIndex = 0;
  double _overlayOpacity = 0.4;

  static const List<String> artImages = [
    'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?q=80&w=1000&auto=format&fit=crop', // Abstract
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1000&auto=format&fit=crop', // Nature Dark
    // 'https://images.unsplash.com/photo-1550684847-75994168e35b?q=80&w=1000&auto=format&fit=crop', // Geometric
    'https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1000&auto=format&fit=crop', // Paint
    'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?q=80&w=1000&auto=format&fit=crop', // Minimal
    'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1000&auto=format&fit=crop', // Gradient
  ];

  static const String _storageKey = 'wallpaper_settings';

  WallpaperStyle get style => _style;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;
  double get fontSize => _fontSize;
  TextAlign get textAlign => _textAlign;
  List<Color> get gradientColors => _gradientColors;
  String get fontFamily => _fontFamily;
  int get selectedArtIndex => _selectedArtIndex;
  double get overlayOpacity => _overlayOpacity;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? settingsJson = prefs.getString(_storageKey);

      if (settingsJson != null) {
        final Map<String, dynamic> data = json.decode(settingsJson);

        _style = WallpaperStyle.values[data['style'] ?? 0];
        _backgroundColor = Color(data['backgroundColor'] ?? Colors.black.value);
        _textColor = Color(data['textColor'] ?? Colors.white.value);
        _fontSize = (data['fontSize'] ?? 24.0).toDouble();
        _textAlign = TextAlign.values[data['textAlign'] ?? 2];
        _fontFamily = data['fontFamily'] ?? 'Outfit';
        _selectedArtIndex = data['selectedArtIndex'] ?? 0;
        _overlayOpacity = (data['overlayOpacity'] ?? 0.4).toDouble();

        if (data['gradientColors'] != null) {
          _gradientColors = (data['gradientColors'] as List)
              .map((c) => Color(c))
              .toList();
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wallpaper settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {
        'style': _style.index,
        'backgroundColor': _backgroundColor.value,
        'textColor': _textColor.value,
        'fontSize': _fontSize,
        'textAlign': _textAlign.index,
        'fontFamily': _fontFamily,
        'selectedArtIndex': _selectedArtIndex,
        'overlayOpacity': _overlayOpacity,
        'gradientColors': _gradientColors.map((c) => c.value).toList(),
      };

      await prefs.setString(_storageKey, json.encode(data));
    } catch (e) {
      debugPrint('Error saving wallpaper settings: $e');
    }
  }

  void setStyle(WallpaperStyle style) {
    _style = style;
    _saveSettings();
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    _saveSettings();
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    _saveSettings();
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    _saveSettings();
    notifyListeners();
  }

  void setTextAlign(TextAlign align) {
    _textAlign = align;
    _saveSettings();
    notifyListeners();
  }

  void setGradientColors(List<Color> colors) {
    _gradientColors = colors;
    _saveSettings();
    notifyListeners();
  }

  void setFontFamily(String family) {
    _fontFamily = family;
    _saveSettings();
    notifyListeners();
  }

  void setArtIndex(int index) {
    _selectedArtIndex = index;
    _saveSettings();
    notifyListeners();
  }

  void setOverlayOpacity(double opacity) {
    _overlayOpacity = opacity;
    _saveSettings();
    notifyListeners();
  }
}
