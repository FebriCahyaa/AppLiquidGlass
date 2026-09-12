#!/usr/bin/env bash
set -Eeuo pipefail

# AppLiquidGlass — full iOS-inspired Liquid Glass UI/UX migration helper
# Run from repository root. No Gradle build is required locally.

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP=".uiux-backup-$STAMP"
mkdir -p "$BACKUP"

log(){ printf '\n\033[1;36m[LiquidGlass]\033[0m %s\n' "$*"; }
warn(){ printf '\n\033[1;33m[Warning]\033[0m %s\n' "$*"; }

log "Repository: $ROOT"

# Detect project type
HAS_FLUTTER=0
HAS_ANDROID=0
[[ -f pubspec.yaml || -d flutter ]] && HAS_FLUTTER=1
[[ -d android || -f settings.gradle || -f settings.gradle.kts ]] && HAS_ANDROID=1

if [[ "$HAS_FLUTTER" -eq 0 && "$HAS_ANDROID" -eq 0 ]]; then
  warn "Flutter/Android structure was not detected. Nothing was changed."
  exit 1
fi

# Backup relevant files before modifying anything.
for path in \
  lib/main.dart \
  flutter/lib/main.dart \
  lib/design \
  lib/widgets \
  android/app/src/main/res/values/themes.xml \
  android/app/src/main/res/values/styles.xml \
  android/app/src/main/res/values/colors.xml; do
  if [[ -e "$path" ]]; then
    mkdir -p "$BACKUP/$(dirname "$path")"
    cp -a "$path" "$BACKUP/$path"
  fi
done

log "Backup created at $BACKUP"

# Resolve Flutter source root.
FLUTTER_ROOT=""
if [[ -f pubspec.yaml ]]; then
  FLUTTER_ROOT="."
elif [[ -f flutter/pubspec.yaml ]]; then
  FLUTTER_ROOT="flutter"
fi

if [[ -n "$FLUTTER_ROOT" ]]; then
  mkdir -p "$FLUTTER_ROOT/lib/design" "$FLUTTER_ROOT/lib/widgets"

  cat > "$FLUTTER_ROOT/lib/design/liquid_glass_design_system.dart" <<'DART'
import 'dart:ui';
import 'package:flutter/material.dart';

abstract final class LiquidGlassColors {
  static const violet = Color(0xFF8B7CFF);
  static const cyan = Color(0xFF61E7E0);
  static const pink = Color(0xFFFF8FC7);
  static const ink = Color(0xFF101018);
  static const text = Color(0xFFF8F7FF);
  static const muted = Color(0xFFB9B6C9);
}

abstract final class LiquidGlassTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LiquidGlassColors.violet,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: LiquidGlassColors.ink,
      fontFamily: 'SF Pro Display',
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class LiquidGlassSurface extends StatelessWidget {
  const LiquidGlassSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 28,
    this.opacity = .12,
    this.blur = 22,
    this.borderOpacity = .22,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double opacity;
  final double blur;
  final double borderOpacity;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: opacity + .04),
                    Colors.white.withValues(alpha: opacity),
                  ],
                ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .20),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class LiquidGlassBackground extends StatelessWidget {
  const LiquidGlassBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: LiquidGlassColors.ink),
        Positioned(top: -150, left: -110, child: _orb(LiquidGlassColors.violet, 340)),
        Positioned(top: 180, right: -160, child: _orb(LiquidGlassColors.cyan, 360)),
        Positioned(bottom: -180, left: 40, child: _orb(LiquidGlassColors.pink, 380)),
        child,
      ],
    );
  }

  Widget _orb(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .20),
        ),
      ),
    );
  }
}
DART

  cat > "$FLUTTER_ROOT/lib/widgets/liquid_glass_navigation.dart" <<'DART'
import 'package:flutter/material.dart';
import '../design/liquid_glass_design_system.dart';

class LiquidGlassNavigation extends StatelessWidget {
  const LiquidGlassNavigation({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  static const items = <({IconData icon, String label})>[
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.explore_rounded, label: 'Explore'),
    (icon: Icons.insights_rounded, label: 'Activity'),
    (icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Center(
        child: LiquidGlassSurface(
          padding: const EdgeInsets.all(7),
          radius: 32,
          opacity: .14,
          blur: 28,
          borderOpacity: .25,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++)
                _Item(
                  selected: i == index,
                  icon: items[i].icon,
                  label: items[i].label,
                  onTap: () => onChanged(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 16 : 13,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: selected
                ? const LinearGradient(
                    colors: [
                      LiquidGlassColors.violet,
                      LiquidGlassColors.pink,
                    ],
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: LiquidGlassColors.violet.withValues(alpha: .28),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: selected ? 1.0 : .94,
                child: Icon(icon, size: 21),
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  child: selected
                      ? Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
DART

  # Add a reusable migration note for the app entrypoint.
  cat > "$FLUTTER_ROOT/lib/design/LIQUID_GLASS_MIGRATION.md" <<'MD'
# Liquid Glass migration

Use these building blocks throughout the app:

- `LiquidGlassTheme.dark()` as the app theme.
- `LiquidGlassBackground` as the root background.
- `LiquidGlassSurface` for cards, sheets, dialogs and settings groups.
- `LiquidGlassNavigation` inside `Scaffold.bottomNavigationBar`.
- Wrap page bodies in `SafeArea` and `SingleChildScrollView` where content can exceed the viewport.
- Keep the selected navigation index in the app shell and animate page changes with `AnimatedSwitcher`.
MD

  # Replace deprecated opacity calls in all Dart files, without changing behavior.
  if command -v perl >/dev/null 2>&1; then
    find "$FLUTTER_ROOT/lib" -type f -name '*.dart' -print0 |
      xargs -0 -r perl -pi -e 's/\.withOpacity\(([^()]*)\)/.withValues(alpha: $1)/g'
  fi

  log "Flutter Liquid Glass design system and animated floating navigation added."
else
  warn "No Flutter pubspec found. Android-only project detected; native UI files were not overwritten."
fi

# Add Android edge-to-edge defaults when the Android module exists.
if [[ "$HAS_ANDROID" -eq 1 && -d android/app/src/main ]]; then
  mkdir -p android/app/src/main/res/values
  cat > android/app/src/main/res/values/liquid_glass_colors.xml <<'XML'
<resources>
    <color name="liquid_glass_background">#101018</color>
    <color name="liquid_glass_violet">#8B7CFF</color>
    <color name="liquid_glass_cyan">#61E7E0</color>
    <color name="liquid_glass_pink">#FF8FC7</color>
</resources>
XML
  log "Android Liquid Glass color resources added."
fi

# Format if available; CI can do it later.
if [[ -n "$FLUTTER_ROOT" ]]; then
  if command -v dart >/dev/null 2>&1; then
    (cd "$FLUTTER_ROOT" && dart format lib/design lib/widgets) || warn "dart format failed; CI will report details."
  else
    warn "Dart is not installed locally. Formatting will be handled by GitHub Actions."
  fi
fi

log "UI/UX migration completed."
printf '\nNext steps:\n'
printf '  git status\n'
printf '  git add .\n'
printf '  git commit -m "feat: apply full liquid glass iOS-inspired UI UX"\n'
printf '  git push origin main\n'
printf '\nBackup: %s\n' "$BACKUP"
