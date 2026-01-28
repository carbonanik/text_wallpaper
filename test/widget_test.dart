import 'package:brainpaper/main.dart';
import 'package:brainpaper/providers/wallpaper_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final wallpaperProvider = WallpaperProvider();
    await tester.pumpWidget(MyApp(wallpaperProvider: wallpaperProvider));

    // Verify that the app builds without errors
    expect(find.text('BrainPaper'), findsOneWidget);
  });
}
