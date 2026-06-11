import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'workout_detail.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exercise});
  final Exercise exercise;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late String _name = widget.exercise.name;
  final String _swap = 'DEADBUGS';
  String? _note;

  static const _steps = [
    'Begin on your hands and knees. Engage your core.',
    'From this position, slowly extend your left leg behind you while reaching your right arm forward. Keep your hips and shoulders square and make sure your lower back does not arch.',
    'Return your arm/leg to the starting position.',
  ];

  Future<void> _addNote() async {
    final weight = TextEditingController(text: '15');
    final unit = TextEditingController(text: 'KG');
    final secs = TextEditingController(text: '30');
    final rounds = TextEditingController(text: '3');
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Workout Notes', style: AppText.h2),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _miniField(weight)),
                const SizedBox(width: 12),
                Expanded(child: _miniField(unit)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _miniField(secs)),
                const SizedBox(width: 12),
                Expanded(child: _miniField(rounds)),
              ]),
              const SizedBox(height: 12),
              Container(
                height: 80,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: notes,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: 'Add Notes…', border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinePillButton(
                        label: 'CANCEL', height: 52, onPressed: () => Navigator.pop(ctx, false)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SageButton(
                        label: 'ENTER', height: 52, onPressed: () => Navigator.pop(ctx, true)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true) {
      setState(() => _note =
          '06 OCT 2025\n${weight.text}.0 kg   ${secs.text} Secs   ${rounds.text} Rounds');
    }
  }

  Widget _miniField(TextEditingController c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: c,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Future<void> _openSwap() async {
    final swapped = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const _SwapDetailScreen(name: 'Deadbugs')),
    );
    if (swapped == true) setState(() => _name = 'Deadbugs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
        children: [
          const PhotoPlaceholder(height: 280, color: Color(0xFFD9D7CF), icon: Icons.directions_run),
          const SizedBox(height: 20),
          Text(_name, style: AppText.h1),
          const SizedBox(height: 8),
          Text(widget.exercise.detail, style: AppText.body),
          const SizedBox(height: 18),
          for (int i = 0; i < _steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 26, child: Text('${i + 1}', style: AppText.body)),
                  Expanded(child: Text(_steps[i], style: AppText.body)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Workout Notes', style: AppText.h2),
              const Spacer(),
              GestureDetector(
                onTap: _addNote,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.sagePill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          if (_note != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(_note!, style: AppText.body),
            ),
          ],
          const SizedBox(height: 22),
          const Text('Swap', style: AppText.h2),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openSwap,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const PhotoPlaceholder(width: 48, height: 48, radius: 8, color: Color(0xFFD9D7CF)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Exercise Swap', style: AppText.bodyMuted),
                      Text(_swap, style: AppText.title.copyWith(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapDetailScreen extends StatelessWidget {
  const _SwapDetailScreen({required this.name});
  final String name;

  static const _steps = [
    'Start lying on your back with your arms pointed towards the ceiling and knees bent to 90-degrees.',
    'Maintain your arm position and gently engage your abdominal muscles.',
    'Lower one leg down to touch the floor, simultaneously lower your opposite arm behind you. Return to the starting position, alternate and repeat.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
        children: [
          const PhotoPlaceholder(height: 280, color: Color(0xFFD9D7CF), icon: Icons.self_improvement),
          const SizedBox(height: 20),
          Text(name, style: AppText.h1),
          const SizedBox(height: 8),
          const Text('3 Rounds,  30 Secs', style: AppText.body),
          const SizedBox(height: 18),
          for (int i = 0; i < _steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 26, child: Text('${i + 1}', style: AppText.body)),
                  Expanded(child: Text(_steps[i], style: AppText.body)),
                ],
              ),
            ),
          const SizedBox(height: 20),
          SageButton(
            label: 'SWAP WITH THIS EXERCISE',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}
