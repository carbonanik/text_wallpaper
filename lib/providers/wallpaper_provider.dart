import 'package:flutter/material.dart';

enum WallpaperStyle { solid, gradient, pattern }

class WallpaperProvider with ChangeNotifier {
  WallpaperStyle _style = WallpaperStyle.solid;
  Color _backgroundColor = Colors.black;
  Color _textColor = Colors.white;
  double _fontSize = 24.0;
  TextAlign _textAlign = TextAlign.center;
  List<Color> _gradientColors = [Colors.blue, Colors.purple];

  WallpaperStyle get style => _style;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;
  double get fontSize => _fontSize;
  TextAlign get textAlign => _textAlign;
  List<Color> get gradientColors => _gradientColors;

  void setStyle(WallpaperStyle style) {
    _style = style;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setTextAlign(TextAlign align) {
    _textAlign = align;
    notifyListeners();
  }

  void setGradientColors(List<Color> colors) {
    _gradientColors = colors;
    notifyListeners();
  }
}
