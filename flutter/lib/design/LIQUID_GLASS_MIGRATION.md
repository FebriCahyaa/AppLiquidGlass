# Liquid Glass migration

Use these building blocks throughout the app:

- `LiquidGlassTheme.dark()` as the app theme.
- `LiquidGlassBackground` as the root background.
- `LiquidGlassSurface` for cards, sheets, dialogs and settings groups.
- `LiquidGlassNavigation` inside `Scaffold.bottomNavigationBar`.
- Wrap page bodies in `SafeArea` and `SingleChildScrollView` where content can exceed the viewport.
- Keep the selected navigation index in the app shell and animate page changes with `AnimatedSwitcher`.
