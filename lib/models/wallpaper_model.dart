import '../providers/wallpaper_provider.dart';
import 'brain_text.dart';

class WallpaperModel {
  final String id;
  final String? name;
  final WallpaperStyle style;
  final int backgroundColor;
  final int textColor;
  final double fontSize;
  final String fontFamily;
  final int textAlign;
  final List<int> gradientColors;
  final int selectedArtIndex;
  final double overlayOpacity;
  final List<BrainText> texts;
  final DateTime createdAt;
  final bool isActive;

  WallpaperModel({
    required this.id,
    this.name,
    required this.style,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.fontFamily,
    required this.textAlign,
    required this.gradientColors,
    required this.selectedArtIndex,
    required this.overlayOpacity,
    required this.texts,
    required this.createdAt,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'style': style.index,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'textAlign': textAlign,
      'gradientColors': gradientColors,
      'selectedArtIndex': selectedArtIndex,
      'overlayOpacity': overlayOpacity,
      'texts': texts.map((t) => t.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      style: WallpaperStyle.values[json['style'] as int? ?? 0],
      backgroundColor: json['backgroundColor'] as int,
      textColor: json['textColor'] as int,
      fontSize: (json['fontSize'] as num).toDouble(),
      fontFamily: json['fontFamily'] as String,
      textAlign: json['textAlign'] as int? ?? 2,
      gradientColors: (json['gradientColors'] as List<dynamic>).cast<int>(),
      selectedArtIndex: json['selectedArtIndex'] as int? ?? 0,
      overlayOpacity: (json['overlayOpacity'] as num).toDouble(),
      texts:
          (json['texts'] as List<dynamic>?)
              ?.map((t) => BrainText.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  WallpaperModel copyWith({
    String? id,
    String? name,
    WallpaperStyle? style,
    int? backgroundColor,
    int? textColor,
    double? fontSize,
    String? fontFamily,
    int? textAlign,
    List<int>? gradientColors,
    int? selectedArtIndex,
    double? overlayOpacity,
    List<BrainText>? texts,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return WallpaperModel(
      id: id ?? this.id,
      name: name ?? this.name,
      style: style ?? this.style,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
      gradientColors: gradientColors ?? this.gradientColors,
      selectedArtIndex: selectedArtIndex ?? this.selectedArtIndex,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      texts: texts ?? this.texts,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
