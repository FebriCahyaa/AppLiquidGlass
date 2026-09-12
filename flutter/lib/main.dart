import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const violet = Color(0xFF6C5CE7);
const cyan = Color(0xFF00B8B5);

void main() => runApp(const LiquidGlassApp());

class LiquidGlassApp extends StatelessWidget {
  const LiquidGlassApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const GlassShell()),
      ],
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: violet, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: violet, brightness: Brightness.dark),
      routerConfig: router,
    );
  }
}

class GlassShell extends StatefulWidget {
  const GlassShell({super.key});

  @override
  State<GlassShell> createState() => _GlassShellState();
}

class _GlassShellState extends State<GlassShell> {
  int selected = 0;
  final pages = const [
    ('Discover your flow.', 'A calm space for ideas, tasks, and inspiration.', 'Beautifully adaptive.', 'Translucent surfaces, soft depth, and expressive motion designed for Flutter.'),
    ('Explore new ideas.', 'Browse concepts and discover something unexpected.', 'A wider perspective.', 'A flexible visual language for dashboards, feeds, and creative experiences.'),
    ('Your activity.', 'Keep track of what matters and see your progress.', 'Small steps, real momentum.', 'Clear hierarchy and gentle motion help you stay focused.'),
    ('Make it yours.', 'Tune the experience, appearance, and interaction style.', 'Personal by design.', 'A reusable foundation with adaptable colors and native gestures.'),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final data = pages[selected];
    return Scaffold(
      extendBody: true,
      backgroundColor: dark ? const Color(0xFF101018) : const Color(0xFFF2F2F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning', style: TextStyle(color: dark ? Colors.white54 : Colors.black54)),
              const SizedBox(height: 8),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity < -100) setState(() => selected = (selected + 1).clamp(0, 3));
                    if (velocity > 100) setState(() => selected = (selected - 1).clamp(0, 3));
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: _GlassPage(key: ValueKey(selected), data: data, dark: dark),
                  ),
                ),
              ),
              _GlassNavigation(selected: selected, onSelected: (value) => setState(() => selected = value), dark: dark),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassPage extends StatelessWidget {
  const _GlassPage({super.key, required this.data, required this.dark});
  final (String, String, String, String) data;
  final bool dark;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(data.$1, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(data.$2, style: TextStyle(color: dark ? Colors.white60 : Colors.black54)),
      const SizedBox(height: 28),
      ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: dark ? Colors.white.withOpacity(.10) : Colors.white.withOpacity(.72),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.35)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('LIQUID GLASS SYSTEM', style: TextStyle(color: violet, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 10),
              Text(data.$3, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(data.$4, style: TextStyle(color: dark ? Colors.white60 : Colors.black54)),
            ]),
          ),
        ),
      ),
    ],
  );
}

class _GlassNavigation extends StatelessWidget {
  const _GlassNavigation({required this.selected, required this.onSelected, required this.dark});
  final int selected;
  final ValueChanged<int> onSelected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Explore', 'Activity', 'Settings'];
    const icons = [Icons.home_outlined, Icons.explore_outlined, Icons.insights_outlined, Icons.settings_outlined];
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(6),
          color: dark ? const Color(0x331F1F2C) : Colors.white.withOpacity(.80),
          child: Row(
            children: List.generate(labels.length, (index) {
              final active = index == selected;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: active ? violet : Colors.transparent, borderRadius: BorderRadius.circular(24)),
                    child: Column(children: [
                      Icon(icons[index], color: active ? Colors.white : (dark ? Colors.white70 : Colors.black54)),
                      const SizedBox(height: 2),
                      Text(labels[index], style: TextStyle(fontSize: 11, color: active ? Colors.white : (dark ? Colors.white70 : Colors.black54))),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
