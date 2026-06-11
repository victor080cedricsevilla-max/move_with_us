import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// "Your 7-Day MWU Experience Starts Now" — shown after starting the trial.
class ExperienceWalkthrough extends StatelessWidget {
  const ExperienceWalkthrough({super.key, required this.onDone});
  final VoidCallback onDone;

  static const _benefits = [
    '10+ Programs that fit every goal, no matter your preference or experience level.',
    '100+ On Demand Pilates, Yoga, and Running workouts to keep you moving anytime.',
    'Customisable Meal Guides tailored to your goals.',
    'A library of 1500+ macro-friendly recipes.',
    'Comprehensive Tracking Features to monitor your progress.',
    'Exclusive Platinum Member Content, including form videos to help you perfect your technique.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Your 7-Day MWU\nExperience Starts Now',
                        textAlign: TextAlign.center,
                        style: AppText.h1,
                      ),
                      const SizedBox(height: 30),
                      const Text('For the next 7 days, you now have access to:',
                          style: AppText.body),
                      const SizedBox(height: 16),
                      for (final b in _benefits)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('•  ', style: AppText.body),
                              Expanded(child: Text(b, style: AppText.body)),
                            ],
                          ),
                        ),
                      const Text(
                        'At the end of your 7 days, your payment will be processed for the Platinum Membership to continue using the MWU App. You can cancel anytime.',
                        style: AppText.bodyMuted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SageButton(
                label: 'Next',
                color: AppColors.sageLight,
                textColor: Colors.white,
                onPressed: onDone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
