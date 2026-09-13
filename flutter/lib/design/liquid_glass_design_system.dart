import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
        Positioned(
            top: -150, left: -110, child: _orb(LiquidGlassColors.violet, 340)),
        Positioned(
            top: 180, right: -160, child: _orb(LiquidGlassColors.cyan, 360)),
        Positioned(
            bottom: -180, left: 40, child: _orb(LiquidGlassColors.pink, 380)),
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
