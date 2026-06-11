import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class NutritionInfoScreen extends StatelessWidget {
  const NutritionInfoScreen({super.key});

  static const _sections = {
    'NUTRITION BASICS':
        'Adhering to an appropriate nutrition protocol can really make or break your results! We believe in the importance of understanding why certain nutrition protocols are being implemented. This ensures that even after your journey with me is complete, you are able to manage your nutrition like a boss and adjust it accordingly depending on your goals!\n\nIn this section, you will learn the basics of nutrition - including what nutrients are essential for your body, why you need them, and where to find them!\n\nThere are 2 main types of essential nutrients required to maintain optimal health: macronutrients and micronutrients.\n\nMacronutrients are nutrients that a person needs in relatively large amounts. These include protein, carbohydrates, and fats.',
    'FITNESS AND NUTRITION':
        'Nutrition and training go hand in hand. To get the most out of your workouts, fuel your body with adequate protein, carbohydrates and fats around your sessions.\n\nProtein supports muscle repair and growth, carbohydrates replenish energy stores, and fats support hormone function and recovery.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
        children: [
          const Text('Nutrition Information', style: AppText.h1),
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
