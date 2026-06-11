import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'sign_in.dart';

class IntroCarousel extends StatefulWidget {
  const IntroCarousel({super.key});

  @override
  State<IntroCarousel> createState() => _IntroCarouselState();
}

class _IntroSlide {
  const _IntroSlide(this.title, this.body, this.colors);
  final String title;
  final String body;
  final List<Color> colors;
}

class _IntroCarouselState extends State<IntroCarousel> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    _IntroSlide(
      'Personalised Programs',
      'Choose from 10+ expert-built programs designed around your goals and experience level.',
      [Color(0xFF9FB0C4), Color(0xFF6E8096)],
    ),
    _IntroSlide(
      'Workouts That Fit You',
      'Train at home or the gym with follow-along sessions, circuits and on-demand classes.',
      [Color(0xFFC8A9A0), Color(0xFF9A766C)],
    ),
    _IntroSlide(
      'Nutrition Made Simple',
      'Customisable meal guides and 1500+ macro-friendly recipes tailored to your goals.',
      [Color(0xFFB7C2A4), Color(0xFF8A9A6F)],
    ),
    _IntroSlide(
      'Progress Tracking and\nAccountability',
      'Set daily tasks and track your hydration, activity, steps, nutrition, sleep, and more.',
      [Color(0xFF9CB4C9), Color(0xFF5F7488)],
    ),
    _IntroSlide(
      'Support and Guidance',
      'Our friendly team and community are here to assist and support you every step of the way!',
      [Color(0xFFCDBCA6), Color(0xFF9C8C73)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final s = _slides[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: s.colors,
                  ),
                ),
                child: Stack(
                  children: [
                    // subtle "person" silhouette feel via translucent shapes
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'M O V E . W I T H U S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 26),
                            Text(
                              s.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                height: 1.1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              s.body,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Dots + CTA
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Column(
              children: [
                PageDots(count: _slides.length, index: _index),
                const SizedBox(height: 22),
                SizedBox(
                  height: 62,
                  width: double.infinity,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: _next,
                      child: const Center(
                        child: Text(
                          "LET'S GET STARTED",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
