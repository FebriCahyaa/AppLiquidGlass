# AppLiquidGlass

Complete dual-target Liquid Glass foundation.

## Android
- Kotlin
- Jetpack Compose
- Material 3
- Animated content transitions
- Swipe navigation
- Light/dark support
- Existing XML/ViewPager2 fallback retained for safe migration

## Flutter
- Dart 3
- Material 3
- GoRouter
- BackdropFilter glass surfaces
- Animated navigation
- Swipe navigation

## Android build

```bash
./gradlew lintDebug
./gradlew assembleDebug
```

## Flutter build

```bash
cd flutter
flutter pub get
flutter analyze
flutter test
flutter build apk
```

The XML activity remains the stable launcher. `LiquidGlassComposeActivity` is available as the Compose implementation and can be made the launcher after visual parity testing.

## GitHub Actions

The repository now includes separate workflows:

- `android.yml`: validation, duplicate-ID check, lint, unit tests, debug APK build, and APK artifact upload.
- `flutter.yml`: dependency installation, formatting, analyzer, tests, debug APK build, and APK artifact upload.

Both workflows support `push`, pull requests, and manual `workflow_dispatch`.
