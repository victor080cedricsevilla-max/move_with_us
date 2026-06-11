import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../profile/profile_menu.dart';
import 'trackers.dart';
import 'goals_flows.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <(String, IconData, Color, VoidCallback)>[
      ('Sleep', Icons.bedtime_outlined, const Color(0xFF6F7176), () => SleepTracker.open(context)),
      ('Nutrition', Icons.restaurant, const Color(0xFF8A9A6A), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionComplianceScreen()))),
      ('Hydration', Icons.water_drop_outlined, const Color(0xFF5C8AA0), () => HydrationTracker.open(context)),
      ('Steps', Icons.directions_walk, const Color(0xFF5A5750), () => StepsTracker.open(context)),
      ('Daily Goal Setting', Icons.checklist, const Color(0xFFB59A6A), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyGoalSettingScreen()))),
      ('Daily Reflection', Icons.self_improvement, const Color(0xFF9A7AA0), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyReflectionScreen()))),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                const Text('Goals', style: AppText.display),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const GoalsInfoScreen())),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileMenuScreen())),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFB9A79A),
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                for (final t in tiles)
                  GestureDetector(
                    onTap: t.$4,
                    child: PhotoPlaceholder(
                      color: t.$3,
                      radius: 18,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(t.$2, color: Colors.white, size: 38),
                          const SizedBox(height: 12),
                          Text(t.$1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
