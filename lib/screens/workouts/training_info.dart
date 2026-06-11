import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class TrainingInfoScreen extends StatelessWidget {
  const TrainingInfoScreen({super.key});

  static const _sections = {
    'WEIGHTED SESSIONS GUIDE':
        "Ladies, let's get to work!\n\nBut first, we need to choose our weapons! Correct weight selection is a very important part of your training, and it's easily one of the most common questions I get.\n\nPlease keep in mind that this is a GUIDE, not a rule book - weight selection differs widely per individual!\n\nThere are two important questions you should ask yourself when selecting a weight:\n\n1. Is this weight challenging?\n2. Am I still performing good quality reps?\n\nWhile we recommend pushing yourself, you should never sacrifice your form to hit a more impressive number carved on a set of dumbbells.",
    'ALL ABOUT CARDIO':
        "Also known as cardi-NO…because let's face it, cardio is hardio!\n\n\"Cardio\" refers to any type of rhythmic physical activity that raises your heart rate. This has many benefits, from increased calorie burn to making your heart fit and strong.\n\nWe highly encourage you to think about cardio as a very useful tool to increase your overall fitness and reach your goals. You don't need to perform crazy amounts of cardio, and most certainly you don't need to do it every single day.",
    'TRAINING MUST KNOWS':
        'Warm up before every session and cool down afterwards. Listen to your body, focus on quality over quantity, and progress gradually over time.',
    'REST AND RECOVERY':
        'Rest days are just as important as training days. Aim for 7-9 hours of sleep, stay hydrated, and incorporate active recovery to keep your body moving without strain.',
    'REFERENCE TABLE':
        'Beginner — Upper Body: Dumbbells 2-4kgs, Kettlebells 2-4kgs. Lower Body: Dumbbells 5-10kgs.\n\nIntermediate — Upper Body: Dumbbells 4-6kgs. Lower Body: Dumbbells 8-12kgs.\n\nAdvanced — Upper Body: Dumbbells 6-10kgs. Lower Body: Dumbbells 12-20kgs.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleIconButton(
              icon: Icons.close,
              bg: const Color(0xFFBDBDBD),
              fg: Colors.white,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
        children: [
          const Text('Training Information', style: AppText.h1),
          const SizedBox(height: 10),
          for (final s in _sections.entries)
            _Accordion(title: s.key, body: s.value),
        ],
      ),
    );
  }
}

class _Accordion extends StatefulWidget {
  const _Accordion({required this.title, required this.body});
  final String title;
  final String body;

  @override
  State<_Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<_Accordion> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (_open)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(widget.body, style: AppText.body),
          ),
        const Divider(height: 1),
      ],
    );
  }
}
