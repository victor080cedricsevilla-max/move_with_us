import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'exercise_detail.dart';
import 'workout_player.dart';

class Exercise {
  Exercise(this.code, this.name, this.detail);
  final String code;
  final String name;
  final String detail;
}

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({super.key, required this.title, this.addMode = false});
  final String title;

  /// When opened from "Add an Extra" the CTA is ADD TO DAY instead of START.
  final bool addMode;

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final Set<int> _checked = {};
  bool _fav = false;

  late final bool _isCore = widget.title.toLowerCase().contains('core');

  List<Exercise> get _exercises => _isCore
      ? [
          Exercise('A1', 'Bird Dogs', '3 Rounds,  30 Secs'),
          Exercise('A2', 'Oblique Crunches', '3 Rounds, 30 Secs E/S'),
          Exercise('A3', 'Side Plank', '3 Rounds, 30 Secs E/S'),
        ]
      : [
          Exercise('A1', 'Banded Lying Lateral Raises', '3 Sets, 10 E/L Reps'),
          Exercise('A2', 'Banded Dumbbell Glute Bridges', '3 Sets, 12 Reps'),
          Exercise('A3', 'Banded Clams', '3 Sets, 10 E/L Reps'),
          Exercise('B1', 'Russian Planks (Hamstring Focused)', '3 Rounds, 30 Secs'),
          Exercise('B2', 'Plate Good Mornings', '3 Sets, 12 Reps'),
          Exercise('B3', 'Frog Kicks', '3 Sets, 12 Reps'),
          Exercise('C1', 'Resistance Band Lat Push Downs', '3 Sets, 12 Reps'),
          Exercise('C2', 'Resistance Band Single Arm Rows', '3 Sets, 12 E/A Reps'),
          Exercise('C3', 'Dumbbell Chest Supported Rows', '3 Sets, 12 Reps'),
        ];

  List<String> get _equipment => _isCore
      ? ['Yoga Mat']
      : ['Booty Band', 'Yoga Mat', 'Dumbbell', 'Benches', 'Plate', 'Bench', 'Resistance Band', 'Set of Dumbbells', 'Incline Bench'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(widget.addMode ? 'Gym' : 'Home',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                Icon(widget.addMode ? Icons.fitness_center : Icons.home),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title, style: AppText.display)),
              GestureDetector(
                onTap: () => setState(() => _fav = !_fav),
                child: Icon(_fav ? Icons.favorite : Icons.favorite_border,
                    size: 30, color: _fav ? Colors.red : AppColors.black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 6),
              Text(_isCore ? '12 mins' : '45 mins', style: AppText.body),
            ],
          ),
          const SizedBox(height: 18),
          if (!_isCore) ...[
            const Text('FOCUS: GLUTES & BACK',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
          ],
          Text(
            _isCore
                ? '30 seconds on, 20 seconds transition time to move between exercises.\n\n60 seconds rest after each set.'
                : 'Move quickly between the exercises in each mini circuit (A1, A2, A3 etc) and have no longer than 20 seconds rest between exercises.\n\nNo longer than 60 seconds rest between sets.',
            style: AppText.body,
          ),
          const SizedBox(height: 22),
          const Text("What's needed", style: AppText.h2),
          const SizedBox(height: 14),
          Wrap(
            spacing: 20,
            runSpacing: 14,
            children: [
              for (final e in _equipment)
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  child: Row(
                    children: [
                      const Icon(Icons.fitness_center, size: 22),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e, style: AppText.body)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),
          SageButton(
            label: widget.addMode ? 'ADD TO DAY' : 'START WORKOUT',
            onPressed: () {
              if (widget.addMode) {
                Navigator.pop(context);
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => WorkoutPlayerScreen(title: widget.title)));
              }
            },
          ),
          const Divider(height: 36),
          Row(
            children: [
              const Text('Exercises', style: AppText.h2),
              const Spacer(),
              const Icon(Icons.info, size: 24),
            ],
          ),
          const SizedBox(height: 14),
          _exerciseList(),
          const SizedBox(height: 24),
          OutlinePillButton(
            label: 'COMPLETE WORKOUT',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  Widget _exerciseList() {
    // group by letter prefix
    final groups = <String, List<MapEntry<int, Exercise>>>{};
    for (var i = 0; i < _exercises.length; i++) {
      final g = _exercises[i].code[0];
      groups.putIfAbsent(g, () => []).add(MapEntry(i, _exercises[i]));
    }
    return Column(
      children: [
        for (final entry in groups.entries)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (final e in entry.value) ...[
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExerciseDetailScreen(exercise: e.value))),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 34,
                            child: Text(e.value.code,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.value.name,
                                    style: AppText.body.copyWith(fontSize: 17)),
                                Text(e.value.detail, style: AppText.bodyMuted),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _checked.contains(e.key)
                                ? _checked.remove(e.key)
                                : _checked.add(e.key)),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _checked.contains(e.key)
                                    ? AppColors.sagePill
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.textSecondary),
                              ),
                              child: _checked.contains(e.key)
                                  ? const Icon(Icons.check, size: 18)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (e.key != entry.value.last.key)
                    const Divider(height: 1, indent: 14, endIndent: 14),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
