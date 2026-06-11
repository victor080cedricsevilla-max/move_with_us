import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../shell/app_shell.dart';
import '../profile/profile_menu.dart';
import 'workout_detail.dart';
import 'training_info.dart';
import 'add_extra.dart';

class _Day {
  _Day(this.name, this.blocks, {this.rest = false});
  final String name;
  List<String> blocks;
  final bool rest;
}

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  int _day = 0;
  bool _editing = false;
  final Set<String> _completed = {};

  static const _dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  static const _dayNums = [6, 7, 8, 9, 10, 11, 12];

  final _days = [
    _Day('MONDAY', ['Activation Circuit', 'Full Body Weighted', 'Core Circuit']),
    _Day('TUESDAY', [], rest: true),
    _Day('WEDNESDAY', ['LISS Cardio']),
    _Day('THURSDAY', ['Activation Circuit', 'Full Body Weighted', 'Core Circuit']),
    _Day('FRIDAY', ['Activation Circuit', 'Full Body Weighted', 'Core Circuit']),
    _Day('SATURDAY', [], rest: true),
    _Day('SUNDAY', [], rest: true),
  ];

  Future<void> _saveEdits() async {
    final choice = await showIOSSheet<String>(
      context,
      title: 'I would like to',
      actions: const [
        (label: 'Save Changes', value: 'save', destructive: false),
        (label: 'Discard Changes', value: 'discard', destructive: false),
      ],
    );
    if (choice != null) setState(() => _editing = false);
  }

  Future<void> _refreshMenu() async {
    await showIOSSheet<String>(
      context,
      title: 'I would like to',
      actions: const [
        (label: 'Update My Workouts', value: 'update', destructive: false),
        (label: 'Refresh My Workouts', value: 'refresh', destructive: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _weekStrip(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                children: [
                  for (final d in _days) _dayCard(d),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        onPressed: () => _editing ? _saveEdits() : setState(() => _editing = true),
        child: Icon(_editing ? Icons.check : Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Row(
        children: [
          const Text('Workouts', style: AppText.display),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.info, size: 26),
            onPressed: _editing
                ? _refreshMenu
                : () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TrainingInfoScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined, size: 26),
            onPressed: () => AppShell.of(context).goTo(0),
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
    );
  }

  Widget _weekStrip() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Icon(Icons.chevron_left),
              Expanded(
                child: Center(
                  child: Text('Week 1: October 6 - 12',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: List.generate(7, (i) {
              final on = i == _day;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _day = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: on ? AppColors.sagePill : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(_dayNames[i],
                            style: TextStyle(
                                fontSize: 12,
                                color: on ? AppColors.black : AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('${_dayNums[i]}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: on ? AppColors.black : AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _dayCard(_Day d) {
    final selected = _days[_day].name == d.name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.sagePill : Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.black, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      if (!d.rest)
                        const Icon(Icons.play_arrow, size: 22),
                      if (!d.rest) const SizedBox(width: 10),
                      Text(d.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      if (d.rest)
                        const Text('Rest Day',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 28),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddExtraScreen())),
              ),
            ],
          ),
          if (d.blocks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 4),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final b in d.blocks)
                    _blockChip(d, b),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _blockChip(_Day d, String b) {
    final done = _completed.contains('${d.name}/$b');
    return GestureDetector(
      onTap: _editing
          ? null
          : () async {
              final completed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => WorkoutDetailScreen(title: b)),
              );
              if (completed == true) {
                setState(() => _completed.add('${d.name}/$b'));
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(done ? Icons.check : Icons.play_arrow, size: 18),
            const SizedBox(width: 8),
            Text(b, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            if (_editing) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => d.blocks = List.of(d.blocks)..remove(b)),
                child: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
