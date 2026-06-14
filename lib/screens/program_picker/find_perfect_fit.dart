import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_images.dart';
import '../../widgets/common.dart';
import 'tutorial.dart';

class _Program {
  const _Program(this.title, this.desc);
  final String title;
  final String desc;
}

class _Category {
  const _Category(this.heading, this.programs, this.cta);
  final String heading;
  final List<_Program> programs;
  final String cta;
}

class FindPerfectFitScreen extends StatefulWidget {
  const FindPerfectFitScreen({super.key});

  @override
  State<FindPerfectFitScreen> createState() => _FindPerfectFitScreenState();
}

class _FindPerfectFitScreenState extends State<FindPerfectFitScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _categories = [
    _Category('Fit into Your Lifestyle', [
      _Program('Busy Girl Workouts Program',
          '6 Weeks | 2 Levels | Transform with workouts for your busy lifestyle | High-intensity Circuits, Core Workouts | 30-45 mins | Home or Gym.'),
      _Program('Express Strength Program',
          '6 Weeks | 2 Levels | Full-body transformation | Weighted Workouts, Mobility, Cardio | 30-45 mins | Home or Gym.'),
      _Program('Pilates Program',
          '6 Weeks | 1 Level | Improve flexibility, posture & stability | Sculpt Sessions, Full Body Sweat, Core | 30-45 mins | Home or Gym.'),
      _Program('Train Like Issy Program',
          '6 Weeks | 1 Level | Build confidence in the gym | Weighted Workouts, AMRAPs, Cardio | 30-60 mins | Home or Gym.'),
      _Program('Pregnancy Program',
          '31 Weeks | 1 Level | Weighted Workouts, Pilates and Pelvic Floor Routines | 40-60 mins | Home or Gym.'),
    ], 'Next'),
    _Category('Improve Performance', [
      _Program('Hybrid Program',
          '6 Weeks | 2 Levels | Improve endurance, running & strength | Weighted Workouts, Full Body Conditioning, Running | 20-60 mins | Home or Gym.'),
      _Program('Power Program',
          '6 Weeks | 1 Level | Achieve full-body strength & power | Weighted Workouts, Plyometrics, Core, Cardio | 40-60 mins | Home or Gym.'),
      _Program('Half Marathon Program',
          '16 Weeks | 1 Level | Get Half Marathon Ready | Running & Weighted Workouts | 30-120 mins | Home or Gym.'),
    ], 'Next'),
    _Category('Build Muscle and\nLose Weight', [
      _Program('Get Started Program',
          '6 Weeks | 1 Level | Perfect for beginners & pregnancy | Cardio, Weighted Workouts, Core Challenges | 30-45 mins | Home or Gym'),
      _Program('Back on Track Program',
          '6 Weeks | 1 Level | Rebuild consistency, Shape your body and build lean, defined muscle | Weighted Workouts | 40-60 mins | Home or Gym.'),
      _Program('Strong Program',
          '8 Weeks | 4 Levels | Build stronger legs, glutes, and core | Weighted Workouts, Core Circuits, Cardio | 40-70 mins | Home or Gym.'),
      _Program('Define Program',
          '6 Weeks | 1 Level | Full-body transformation with a focus on glutes | Resistance Training, Pilates-inspired, Running | 30-60 mins | Home or Gym.'),
    ], 'Next'),
    _Category('Build Muscle', [
      _Program('Build a Booty Program',
          '6 Weeks | 2 Levels | Shape and transform your booty | Glute-focused, Core Strength, Upper Body | 60-70 mins | Home or Gym'),
      _Program('Bikini Build Program',
          '8 Weeks | 4 Levels | Build muscle and full-body strength | Weighted Workouts, Cardio, Core Strength | 40-70 mins | Home or Gym.'),
      _Program('Lift & Sculpt Program',
          '8 Weeks | 1 Level | Build Strength, Sculpt and Transform | Weighted Workouts and Low Intensity Steady State Cardio | 60-90 minutes | Home or Gym'),
      _Program('Build & Sculpt Program',
          '8 Weeks | 1 Level | Build lean muscle, get stronger, and elevate your endurance | Weighted Workouts & Cardio | 35-75 mins | Home or Gym.'),
    ], 'Continue'),
    _Category('Lose Weight', [
      _Program('FIT Program',
          '4 Weeks | 4 Levels | Achieve your weight loss goals | Circuit-style HIIT, Strength & Cardio | 40-60 mins | Home or Gym'),
      _Program('3-2-1 Method Define Edition Program',
          '4 Weeks | 1 Level | Build Strong Glutes, Sculpted Arms & Defined Core | Weighted Workouts, Pilates and Running | 30-60 mins | Home or Gym'),
      _Program('Booty & Abs Pilates Program',
          '3 Weeks | 1 Level | Sculpt your Booty & Define your Core | Pilates | 30-35 mins | Home or Gym.'),
    ], 'Continue'),
  ];

  // total pages = intro + categories + ready
  int get _pageCount => _categories.length + 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _pageCount - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TutorialScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _introPage(),
                for (final c in _categories) _categoryPage(c),
                _readyPage(),
              ],
            ),
            Positioned(
              top: 8,
              right: 16,
              child: CircleIconButton(icon: Icons.close, onTap: _finish),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 18,
              child: Column(
                children: [
                  SageButton(
                    label: _ctaLabel,
                    color: AppColors.sageLight,
                    textColor: Colors.white,
                    onPressed: _next,
                  ),
                  const SizedBox(height: 16),
                  PageDots(count: _pageCount, index: _index),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _ctaLabel {
    if (_index == 0) return 'Find My Perfect Program';
    if (_index == _pageCount - 1) return 'Done';
    return _categories[_index - 1].cta;
  }

  Widget _introPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 80, 28, 120),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Find your Perfect Fit',
                textAlign: TextAlign.center, style: AppText.h1),
            SizedBox(height: 24),
            Text(
              'With so many Programs to choose from, we know it can be hard to decide where to start!',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
            SizedBox(height: 16),
            Text(
              "To help you out, we've created a quick guide to pick your first Program based on your fitness goals.",
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryPage(_Category c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 120),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.heading, style: AppText.h1),
            const SizedBox(height: 20),
            for (final p in c.programs)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhotoPlaceholder(
                      width: 86,
                      height: 110,
                      radius: 8,
                      color: const Color(0xFFB6A89A),
                      asset: AppImages.at(p.title.hashCode),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, style: AppText.title.copyWith(fontSize: 19)),
                          const SizedBox(height: 6),
                          Text(p.desc, style: AppText.body.copyWith(fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _readyPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 80, 28, 120),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(child: Text('Ready to Get Started?', style: AppText.h1)),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ', style: AppText.body),
                Expanded(
                  child: Text(
                    "Select a Program from the list and complete the Onboarding Questionnaire. Once finished, you'll unlock your workouts and personalised Meal Guide to kickstart your journey.",
                    style: AppText.body,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ', style: AppText.body),
                Expanded(
                  child: Text(
                    'Need help with the MWU App? Explore our educational resource or contact our CX Team anytime for support.',
                    style: AppText.body,
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
