import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ActiveRestDayScreen extends StatelessWidget {
  const ActiveRestDayScreen({super.key});

  static const _ideas = [
    'Walking/hiking',
    'Bike ride',
    'Mobility sessions',
    'Swimming',
    'Foam rolling',
    'Gentle stretching or yoga',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          const Text("Yay - it's Active Rest Day!", style: AppText.h1),
          const SizedBox(height: 18),
          const Text(
            'Lounging around all day is not necessarily the best option for recovery! Active rest days can be a great way to reduce muscle soreness and keep your body moving without putting any significant strain on your tissues, joints, and the nervous system.',
            style: AppText.body,
          ),
          const SizedBox(height: 24),
          const Text("If you're up for light activity on your rest day, some ideas include:",
              style: AppText.h2),
          const SizedBox(height: 16),
          for (final i in _ideas)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, right: 12),
                    child: CircleAvatar(radius: 4, backgroundColor: AppColors.black),
                  ),
                  Expanded(child: Text(i, style: AppText.body.copyWith(fontSize: 18))),
                ],
              ),
            ),
          const SizedBox(height: 14),
          const Text.rich(
            TextSpan(
              style: AppText.body,
              children: [
                TextSpan(text: 'Hot tip: ', style: TextStyle(fontWeight: FontWeight.w800)),
                TextSpan(
                    text:
                        "Take it easy - keep the intensity low, and don't overexert yourself, as this will defeat the purpose of active recovery."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
