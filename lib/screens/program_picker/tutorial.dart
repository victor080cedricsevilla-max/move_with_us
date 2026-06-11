import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../program/questionnaire.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _controller = PageController();
  int _index = 0;
  static const _count = 7;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _count - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 240), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QuestionnaireScreen()),
    );
  }

  String get _cta {
    switch (_index) {
      case 0:
        return 'Get Started';
      case 5:
        return 'Continue';
      case 6:
        return 'Start Now!';
      default:
        return 'Next';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  _welcome(),
                  _home(),
                  _workouts(),
                  _meals(),
                  _simple('Track Your Progress', 3, const [
                    'The **Tracking** icon allows you to log your measurements and check in every 2 weeks.',
                    'Keep track of your progress and stay motivated.',
                  ]),
                  _simple('Log and Achieve Your\nGoals', 4, const [
                    'The **Goals** icon helps you log sleep, water intake, and daily steps.',
                    'View your nutrition compliance, set daily goals, and reflect on your progress.',
                  ]),
                  _ready(),
                ],
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 18,
                child: Column(
                  children: [
                    SageButton(
                      label: _cta,
                      color: AppColors.sageLight,
                      textColor: Colors.white,
                      onPressed: _next,
                    ),
                    const SizedBox(height: 16),
                    PageDots(count: _count, index: _index),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniTabs(int active) {
    const labels = ['Home', 'Workouts', 'Meals', 'Tracking', 'Goals'];
    const icons = [
      Icons.home_outlined,
      Icons.fitness_center,
      Icons.restaurant,
      Icons.bar_chart,
      Icons.emoji_events_outlined,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final on = i == active;
        return Column(
          children: [
            Icon(icons[i],
                size: 24, color: on ? AppColors.black : AppColors.textMuted),
            const SizedBox(height: 4),
            Text(labels[i],
                style: TextStyle(
                    fontSize: 12,
                    color: on ? AppColors.black : AppColors.textMuted)),
          ],
        );
      }),
    );
  }

  Widget _pageScaffold(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _bullets(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final t in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: AppText.body),
                Expanded(child: _richBold(t)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _richBold(String text) {
    final parts = text.split('**');
    return Text.rich(
      TextSpan(
        style: AppText.body.copyWith(fontSize: 18),
        children: [
          for (int i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd
                  ? const TextStyle(fontWeight: FontWeight.w800)
                  : null,
            ),
        ],
      ),
    );
  }

  Widget _welcome() => _pageScaffold([
        const SizedBox(height: 20),
        const Center(
            child: Text('Welcome to\nMove With Us',
                textAlign: TextAlign.center, style: AppText.h1)),
        const SizedBox(height: 24),
        const Text('Your Journey to a Better You Starts Here.',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontSize: 18, height: 1.3)),
        const SizedBox(height: 14),
        _bullets(const [
          'Discover the features of the App through this guide.',
          'For more details, visit our **Support Page** for helpful videos and screenshots.',
        ]),
      ]);

  Widget _home() => _pageScaffold([
        _miniTabs(0),
        const SizedBox(height: 24),
        const Text('Explore Your Home\nScreen', style: AppText.h1),
        const SizedBox(height: 16),
        _bullets(const [
          'The **Home** icon shows your daily macro split, calorie intake, water intake, steps, and sleep hours.',
        ]),
        const SizedBox(height: 8),
        const Text('My Meals', style: AppText.title),
        const SizedBox(height: 10),
        const CalorieBar(value: 1233, goal: 2050),
        const SizedBox(height: 18),
        const MacroRow(),
        const SizedBox(height: 22),
        const Text('Goal Tracking', style: AppText.title),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _goalCard('2,000 ml', 'Water', const Color(0xFFB9A03C))),
            const SizedBox(width: 10),
            Expanded(child: _goalCard('5,321', 'Steps', const Color(0xFF566066))),
            const SizedBox(width: 10),
            Expanded(child: _goalCard('8 hours', 'Sleep', const Color(0xFF8A8F94))),
          ],
        ),
      ]);

  Widget _goalCard(String value, String label, Color c) {
    return PhotoPlaceholder(
      height: 120,
      color: c,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _workouts() => _pageScaffold([
        _miniTabs(1),
        const SizedBox(height: 24),
        const Text('Navigate Your Workouts', style: AppText.h1),
        const SizedBox(height: 16),
        _bullets(const [
          'The **Workouts** icon displays your weekly training plan.',
          'Read the instructions for information on how to perform the exercises!',
          'Press the play button next to the day for a group exercise block.',
        ]),
        const SizedBox(height: 8),
        SageButton(label: 'START WORKOUT', color: AppColors.sage, onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Glutes Weighted', style: AppText.title),
        const SizedBox(height: 6),
        Row(children: const [
          Icon(Icons.access_time, size: 18),
          SizedBox(width: 6),
          Text('40 mins'),
        ]),
        const SizedBox(height: 10),
        const Text('FOCUS: GLUTES',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ]);

  Widget _meals() => _pageScaffold([
        _miniTabs(2),
        const SizedBox(height: 24),
        const Text('Plan Your Meals', style: AppText.h1),
        const SizedBox(height: 16),
        _bullets(const [
          'The **Meals** icon provides your daily Meal Plan.',
          'Tick the box next to a recipe to check off macros against your calorie goal.',
          'Add new recipes from our library or swap ingredients to keep your meals varied.',
        ]),
        const SizedBox(height: 8),
        const Text('Meals', style: AppText.h2),
        const SizedBox(height: 12),
        const CalorieBar(value: 1233, goal: 1850),
        const SizedBox(height: 18),
        const MacroRow(),
      ]);

  Widget _simple(String title, int tab, List<String> bullets) => _pageScaffold([
        _miniTabs(tab),
        const SizedBox(height: 24),
        Text(title, style: AppText.h1),
        const SizedBox(height: 16),
        _bullets(bullets),
      ]);

  Widget _ready() => _pageScaffold([
        const SizedBox(height: 30),
        const Center(
            child: Text("You're Ready to Go!", style: AppText.h1)),
        const SizedBox(height: 30),
        const Text('Start exploring the MWU App and unlock your full potential.',
            style: AppText.body),
        const SizedBox(height: 12),
        const Text('Remember, consistency is key to achieving your goals.',
            style: AppText.body),
      ]);
}
