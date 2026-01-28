import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import '../models/wallpaper_model.dart';
import '../models/brain_text.dart';
import '../services/database_service.dart';

enum WallpaperStyle { solid, gradient, pattern }

class WallpaperProvider with ChangeNotifier {
  static const List<String> artImages = [
    'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?q=80&w=1000&auto=format&fit=crop', // Abstract
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1000&auto=format&fit=crop', // Nature Dark
    'https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1000&auto=format&fit=crop', // Paint
    'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?q=80&w=1000&auto=format&fit=crop', // Minimal
    'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1000&auto=format&fit=crop', // Gradient
  ];

  WallpaperModel _activeWallpaper = WallpaperModel(
    id: 'default',
    style: WallpaperStyle.solid,
    backgroundColor: Colors.black.value,
    textColor: Colors.white.value,
    fontSize: 24.0,
    fontFamily: 'Inter',
    textAlign: 2,
    gradientColors: [Colors.blue.value, Colors.purple.value],
    selectedArtIndex: 0,
    overlayOpacity: 0.4,
    texts: [],
    createdAt: DateTime.now(),
  );

  final List<WallpaperModel> _savedWallpapers = [];
  final _store = stringMapStoreFactory.store('wallpapers');
  final _activeKey = 'active_wallpaper_id';
  final _metaStore = StoreRef<String, String>('metadata');

  WallpaperModel get activeWallpaper => _activeWallpaper;
  List<WallpaperModel> get savedWallpapers => _savedWallpapers;

  WallpaperStyle get style => _activeWallpaper.style;
  Color get backgroundColor => Color(_activeWallpaper.backgroundColor);
  Color get textColor => Color(_activeWallpaper.textColor);
  double get fontSize => _activeWallpaper.fontSize;
  TextAlign get textAlign => TextAlign.values[_activeWallpaper.textAlign];
  List<Color> get gradientColors =>
      _activeWallpaper.gradientColors.map((c) => Color(c)).toList();
  String get fontFamily => _activeWallpaper.fontFamily;
  int get selectedArtIndex => _activeWallpaper.selectedArtIndex;
  double get overlayOpacity => _activeWallpaper.overlayOpacity;

  Future<void> loadSettings() async {
    try {
      final db = await DatabaseService.instance.database;

      final snapshots = await _store.find(db);
      debugPrint('Loaded ${snapshots.length} wallpapers from DB');

      _savedWallpapers.clear();
      _savedWallpapers.addAll(
        snapshots.map((s) => WallpaperModel.fromJson(s.value)).toList(),
      );

      final activeId = await _metaStore.record(_activeKey).get(db);
      debugPrint('Active wallpaper ID from DB: $activeId');

      if (activeId != null) {
        final activeSnapshot = await _store.record(activeId).get(db);
        if (activeSnapshot != null) {
          _activeWallpaper = WallpaperModel.fromJson(activeSnapshot);
          debugPrint('Active wallpaper loaded: ${_activeWallpaper.id}');
        }
      } else if (_savedWallpapers.isNotEmpty) {
        _activeWallpaper = _savedWallpapers.first;
        debugPrint(
          'No active ID found, using first saved: ${_activeWallpaper.id}',
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading wallpaper settings: $e');
    }
  }

  Future<void> saveCurrentAsNew(String name) async {
    final newWallpaper = _activeWallpaper.copyWith(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
      isActive: true,
    );

    _savedWallpapers.add(newWallpaper);
    _activeWallpaper = newWallpaper;

    await _saveWallpaperToDb(newWallpaper);
    await _setActiveId(newWallpaper.id);
    notifyListeners();
  }

  Future<void> _saveWallpaperToDb(WallpaperModel wallpaper) async {
    try {
      final db = await DatabaseService.instance.database;
      await _store.record(wallpaper.id).put(db, wallpaper.toJson());
      debugPrint('Saved wallpaper to DB: ${wallpaper.id}');

      // Update local list to keep gallery fresh
      final index = _savedWallpapers.indexWhere((w) => w.id == wallpaper.id);
      if (index != -1) {
        _savedWallpapers[index] = wallpaper;
      } else {
        _savedWallpapers.add(wallpaper);
      }
    } catch (e) {
      debugPrint('Error saving wallpaper to DB: $e');
    }
  }

  Future<void> _setActiveId(String id) async {
    try {
      final db = await DatabaseService.instance.database;
      await _metaStore.record(_activeKey).put(db, id);
    } catch (e) {
      debugPrint('Error setting active ID: $e');
    }
  }

  void setStyle(WallpaperStyle style) {
    _activeWallpaper = _activeWallpaper.copyWith(style: style);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _activeWallpaper = _activeWallpaper.copyWith(backgroundColor: color.value);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _activeWallpaper = _activeWallpaper.copyWith(textColor: color.value);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setFontSize(double size) {
    _activeWallpaper = _activeWallpaper.copyWith(fontSize: size);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setTextAlign(TextAlign align) {
    _activeWallpaper = _activeWallpaper.copyWith(textAlign: align.index);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setGradientColors(List<Color> colors) {
    _activeWallpaper = _activeWallpaper.copyWith(
      gradientColors: colors.map((c) => c.value).toList(),
    );
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setFontFamily(String family) {
    _activeWallpaper = _activeWallpaper.copyWith(fontFamily: family);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setArtIndex(int index) {
    _activeWallpaper = _activeWallpaper.copyWith(selectedArtIndex: index);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void setOverlayOpacity(double opacity) {
    _activeWallpaper = _activeWallpaper.copyWith(overlayOpacity: opacity);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  Future<void> createNew() async {
    // Save current before switching
    await _saveWallpaperToDb(_activeWallpaper);

    final newId = const Uuid().v4();
    _activeWallpaper = WallpaperModel(
      id: newId,
      name: 'Wallpaper ${DateTime.now().hour}:${DateTime.now().minute}',
      style: WallpaperStyle.solid,
      backgroundColor: Colors.black.value,
      textColor: Colors.white.value,
      fontSize: 24.0,
      fontFamily: 'Inter',
      textAlign: 2,
      gradientColors: [Colors.blue.value, Colors.purple.value],
      selectedArtIndex: 0,
      overlayOpacity: 0.4,
      texts: [],
      createdAt: DateTime.now(),
    );

    // Persist the new one and set as active
    await _saveWallpaperToDb(_activeWallpaper);
    await _setActiveId(newId);

    notifyListeners();
  }

  void setActiveWallpaper(WallpaperModel wallpaper) {
    _activeWallpaper = wallpaper;
    _setActiveId(wallpaper.id);
    notifyListeners();
  }

  void setTexts(List<BrainText> texts) {
    _activeWallpaper = _activeWallpaper.copyWith(texts: texts);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void addText(String text) {
    if (text.isEmpty) return;
    final newText = BrainText(text: text);
    final updatedTexts = List<BrainText>.from(_activeWallpaper.texts)
      ..add(newText);
    _activeWallpaper = _activeWallpaper.copyWith(texts: updatedTexts);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void removeText(String id) {
    final updatedTexts = _activeWallpaper.texts
        .where((t) => t.id != id)
        .toList();
    _activeWallpaper = _activeWallpaper.copyWith(texts: updatedTexts);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }

  void clearAllTexts() {
    _activeWallpaper = _activeWallpaper.copyWith(texts: []);
    _saveWallpaperToDb(_activeWallpaper);
    notifyListeners();
  }
}
