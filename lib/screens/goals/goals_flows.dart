import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Nutrition compliance — read-only summary rings.
class NutritionComplianceScreen extends StatelessWidget {
  const NutritionComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Nutrition')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          const Text('Your Nutrition Compliance', style: AppText.h2),
          const SizedBox(height: 20),
          Center(
            child: MacroRing(label: 'Compliance', value: 0, goal: 7, size: 140, color: AppColors.sageTrack),
          ),
          const SizedBox(height: 24),
          const Text('Tick off your meals each day to build your weekly compliance score. Aim to hit your calorie goal at least 5 days a week for best results.',
              style: AppText.body),
        ],
      ),
    );
  }
}

/// Daily Goal Setting — up to several goals with an "add more" affordance.
class DailyGoalSettingScreen extends StatefulWidget {
  const DailyGoalSettingScreen({super.key});

  @override
  State<DailyGoalSettingScreen> createState() => _DailyGoalSettingScreenState();
}

class _DailyGoalSettingScreenState extends State<DailyGoalSettingScreen> {
  final List<String> _labels = ['1st Goal', '2nd Goal', '3rd Goal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Daily Goal Setting')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          const Text('Set your goals for today', style: AppText.h2),
          const SizedBox(height: 20),
          for (final l in _labels)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CreamField(label: l, hint: 'Enter a goal…'),
            ),
          InkWell(
            onTap: () => setState(() => _labels.add('${_labels.length + 1}th Goal')),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(children: [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 12),
                Text('Add more', style: AppText.body),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: SageButton(label: 'DONE', onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}

/// Multi-step daily reflection ending in a completion screen.
class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({super.key});

  @override
  State<DailyReflectionScreen> createState() => _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends State<DailyReflectionScreen> {
  int _step = 0;
  double _sleep = 7;
  final Set<int> _goalsDone = {};

  void _next() {
    if (_step < 5) {
      setState(() => _step++);
    } else {
      Navigator.pop(context);
    }
  }

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back),
        title: const Text('Reflection'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: _step == 5 ? _completed() : _stepBody(),
        ),
      ),
    );
  }

  Widget _stepBody() {
    final titles = [
      'How did you sleep?',
      'Did you complete your goals?',
      'What are you grateful for?',
      'Something you love about yourself',
      "You're a goal setter!",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titles[_step], style: AppText.h1),
        const SizedBox(height: 24),
        Expanded(child: SingleChildScrollView(child: _stepContent())),
        SageButton(label: _step == 4 ? 'COMPLETE' : 'NEXT', onPressed: _next),
      ],
    );
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return Column(
          children: [
            Text('${_sleep.round()} hours', style: AppText.h1),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.sageTrack,
                inactiveTrackColor: AppColors.sageLight,
                thumbColor: Colors.white,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(value: _sleep, min: 0, max: 12, onChanged: (v) => setState(() => _sleep = v)),
            ),
          ],
        );
      case 1:
        const goals = ['Drink 2L water', 'Hit 10k steps', 'Complete workout'];
        return Column(
          children: [
            for (int i = 0; i < goals.length; i++)
              GestureDetector(
                onTap: () => setState(() =>
                    _goalsDone.contains(i) ? _goalsDone.remove(i) : _goalsDone.add(i)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(_goalsDone.contains(i) ? Icons.check_circle : Icons.circle_outlined,
                          color: _goalsDone.contains(i) ? AppColors.sageDeep : AppColors.textSecondary),
                      const SizedBox(width: 14),
                      Text(goals[i], style: AppText.body.copyWith(fontSize: 17)),
                    ],
                  ),
                ),
              ),
          ],
        );
      case 2:
      case 3:
        return Container(
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(18)),
          child: const TextField(
            maxLines: null,
            decoration: InputDecoration(border: InputBorder.none, hintText: 'Write here…'),
          ),
        );
      default:
        return Column(
          children: const [
            SizedBox(height: 30),
            Icon(Icons.emoji_events, size: 90, color: AppColors.sageDeep),
            SizedBox(height: 20),
            Text('Amazing work reflecting on your day. Consistency is key!',
                textAlign: TextAlign.center, style: AppText.body),
          ],
        );
    }
  }

  Widget _completed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(color: AppColors.sage, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 64, color: Colors.white),
        ),
        const SizedBox(height: 24),
        const Text('Reflection Completed', style: AppText.h1, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text('See you again tomorrow 💚', style: AppText.bodyMuted),
        const Spacer(),
        SageButton(label: 'DONE', onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

/// Goals Information accordion.
class GoalsInfoScreen extends StatefulWidget {
  const GoalsInfoScreen({super.key});

  @override
  State<GoalsInfoScreen> createState() => _GoalsInfoScreenState();
}

class _GoalsInfoScreenState extends State<GoalsInfoScreen> {
  final _open = <int>{};

  static const _sections = {
    'WHY SET GOALS?':
        'Setting daily goals keeps you accountable and motivated. Small, consistent actions compound over time into meaningful results.',
    'SLEEP & RECOVERY':
        'Aim for 7-9 hours of quality sleep each night. Recovery is when your body adapts and grows stronger.',
    'HYDRATION':
        'Staying hydrated supports energy, digestion and recovery. Aim for around 2-2.5 litres of water per day.',
    'DAILY REFLECTION':
        'Take a moment each day to reflect on your wins, express gratitude and set intentions for tomorrow.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          const Text('Goals Information', style: AppText.h1),
          const SizedBox(height: 10),
          for (int i = 0; i < _sections.length; i++) ...[
            InkWell(
              onTap: () => setState(() => _open.contains(i) ? _open.remove(i) : _open.add(i)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_sections.keys.elementAt(i),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    Icon(_open.contains(i) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            if (_open.contains(i))
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Text(_sections.values.elementAt(i), style: AppText.body),
              ),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
