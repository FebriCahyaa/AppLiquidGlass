# Apple Liquid Glass Template

Native Android Kotlin + XML template inspired by modern Apple Liquid Glass concepts.

## Features
- Dynamic glass-style surfaces and translucent layers
- Animated floating navbar pill
- Light and dark resources
- XML Views, no Compose
- GitHub Actions debug APK build

## Build locally
```bash
gradle :app:assembleDebug
```

APK: `app/build/outputs/apk/debug/app-debug.apk`

## GitHub Actions
Push to `main` or `master`, or run **Android Debug APK** manually from Actions. The generated APK is uploaded as an artifact.

## Android 17 / API 37 support

- `compileSdk = 37` and `targetSdk = 37`.
- Edge-to-edge window configuration with safe fallback.
- Android 12+ blur capability detection via `Android17Features.supportsBlur()`.
- Android 13+ modern back capability detection via `Android17Features.supportsModernBack()`.
- `android:enableOnBackInvokedCallback="true"` enabled for modern back navigation.
- Maintains `minSdk = 26` for broad compatibility.

> Android 17-only platform APIs should be added only after their final SDK signatures are available. The compatibility layer avoids referencing unavailable APIs directly, so older devices continue to work.
