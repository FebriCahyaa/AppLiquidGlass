# AppLiquidGlass Framework Architecture

## Direction
- Android native UI: Kotlin + Jetpack Compose.
- Flutter: separate cross-platform target, not mixed into the Android Activity.
- Existing XML/ViewPager2 UI remains during the migration so the project stays buildable.

## Migration order
1. Keep current XML navigation as the stable fallback.
2. Add Compose design tokens and reusable glass components.
3. Migrate one screen at a time using `ComposeView` or a Compose destination.
4. Move navigation and state to a single source of truth.
5. Remove XML only after Compose parity and CI tests pass.

## Stability rules
- No blocking work on the main thread.
- Use stable keys and immutable UI state.
- Keep animations interruptible and respect reduced-motion preferences.
- Test configuration changes, process recreation, dark mode, and low-memory conditions.
- Flutter is maintained under `flutter/` with its own CI/build target.
