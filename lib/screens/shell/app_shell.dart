import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../home/home_screen.dart';
import '../workouts/workouts_screen.dart';
import '../meals/meals_screen.dart';
import '../tracking/tracking_screen.dart';
import '../goals/goals_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.firstDay = false, this.initialIndex = 0});

  final bool firstDay;
  final int initialIndex;

  @override
  State<AppShell> createState() => AppShellState();

  /// Allows nested screens to switch the active tab.
  static AppShellState of(BuildContext context) =>
      context.findAncestorStateOfType<AppShellState>()!;
}

class AppShellState extends State<AppShell> {
  late int _index = widget.initialIndex;

  void goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(firstDay: widget.firstDay),
      const WorkoutsScreen(),
      const MealsScreen(),
      const TrackingScreen(),
      const GoalsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: _BottomBar(
        index: _index,
        onTap: goTo,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (label: 'Home', on: Icons.home, off: Icons.home_outlined),
    (label: 'Workouts', on: Icons.fitness_center, off: Icons.fitness_center),
    (label: 'Meals', on: Icons.restaurant, off: Icons.restaurant_outlined),
    (label: 'Tracking', on: Icons.bar_chart, off: Icons.bar_chart_outlined),
    (label: 'Goals', on: Icons.flag, off: Icons.flag_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final it = _items[i];
              final selected = i == index;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? it.on : it.off,
                        size: 26,
                        color: selected ? AppColors.black : AppColors.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        it.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color:
                              selected ? AppColors.black : AppColors.textMuted,
                        ),
                      ),
                    ],
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
