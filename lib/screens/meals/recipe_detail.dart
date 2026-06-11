import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'meal_models.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.meal, this.swapMode = true});
  final Meal meal;

  /// true → "SWAP WITH THIS MEAL"; false → "ADD TO MEAL GUIDE".
  final bool swapMode;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  double _servings = 1.5;
  bool _fav = false;

  static const _ingredients = [
    ('232 g', 'Chicken Breast (No Skin) (Raw)'),
    ('54 g', 'Rice Noodles (Raw)'),
    ('150 g', 'Mixed Capsicum'),
    ('80 g', 'Green Beans'),
  ];
  static const _boosters = [
    ('White Onion, to taste', ''),
    ('Sugar Free Sweet Chilli Sauce', '1.5 tbsp'),
  ];
  static const _method = [
    'Prepare vegetables: cut capsicum into thin strips, slice onion and chop ends off beans. Dice chicken or cut into thin strips.',
    'Heat a pan over medium-high heat and add oil. Once hot, add onion and cook for 2-3 minutes, until softened.',
    'Add chicken to pan and pour sugar free sweet chilli sauce over the top. Cook for 5-7 minutes or until cooked through, stirring occasionally.',
    'Add vegetables and cover pan to steam for 3-5 minutes.',
    'Prepare rice noodles as per packet instructions.',
    'Serve stir fry over rice noodles.',
  ];

  void _share() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('SHARE RECIPE', style: AppText.title),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(radius: 26, backgroundColor: AppColors.black, child: Icon(Icons.facebook, color: Colors.white)),
                  SizedBox(width: 22),
                  CircleAvatar(radius: 26, backgroundColor: AppColors.black, child: Icon(Icons.camera_alt, color: Colors.white)),
                  SizedBox(width: 22),
                  CircleAvatar(radius: 26, backgroundColor: AppColors.black, child: Icon(Icons.ios_share, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.meal;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              PhotoPlaceholder(height: 320, radius: 0, color: m.color, icon: Icons.restaurant),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleIconButton(icon: Icons.arrow_back, bg: Colors.white, onTap: () => Navigator.pop(context)),
                      const Spacer(),
                      CircleIconButton(icon: Icons.ios_share, bg: Colors.white, onTap: _share),
                      const SizedBox(width: 10),
                      CircleIconButton(
                        icon: _fav ? Icons.favorite : Icons.favorite_border,
                        bg: Colors.white,
                        fg: _fav ? Colors.red : AppColors.black,
                        onTap: () => setState(() => _fav = !_fav),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.name, style: AppText.h1),
                const SizedBox(height: 6),
                Text('${m.cal} Calories', style: AppText.body.copyWith(fontSize: 18)),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.35,
                    minHeight: 9,
                    backgroundColor: AppColors.ringTrack,
                    valueColor: const AlwaysStoppedAnimation(AppColors.sageTrack),
                  ),
                ),
                const SizedBox(height: 22),
                MacroRow(
                  protein: [m.p, 128],
                  fats: [m.f, 58],
                  carbs: [m.c, 141],
                  fibre: [(m.cal / 30).round().clamp(0, 25), 25],
                  size: 66,
                ),
                const SizedBox(height: 22),
                SageButton(
                  label: widget.swapMode ? 'SWAP WITH THIS MEAL' : 'ADD TO MEAL GUIDE',
                  onPressed: () {
                    if (widget.swapMode) {
                      Navigator.pop(context);
                    } else {
                      _confirmMacros();
                    }
                  },
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Text('Recipe', style: AppText.h1),
                    const Spacer(),
                    const Icon(Icons.people_outline),
                    const SizedBox(width: 8),
                    Text(_servings.toStringAsFixed(1), style: AppText.body),
                    const SizedBox(width: 10),
                    _stepper(),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text('Ingredients', style: AppText.h2),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.sagePill, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Swap', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < _ingredients.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              SizedBox(width: 70, child: Text(_ingredients[i].$1, style: AppText.body)),
                              Expanded(child: Text(_ingredients[i].$2, style: AppText.body)),
                            ],
                          ),
                        ),
                        if (i != _ingredients.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text('Flavour Boosters', style: AppText.h2),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < _boosters.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(child: Text(_boosters[i].$1, style: AppText.body)),
                              Text(_boosters[i].$2, style: AppText.bodyMuted),
                            ],
                          ),
                        ),
                        if (i != _boosters.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text('Method', style: AppText.h2),
                const SizedBox(height: 12),
                for (int i = 0; i < _method.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 26, child: Text('${i + 1}', style: AppText.body)),
                        Expanded(child: Text(_method[i], style: AppText.body)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmMacros() async {
    final ok = await showIOSAlert(context,
        title: 'Check Your Macros!',
        message: 'We recommend closely hitting your daily targets for best results. If you\'re confident with these changes, press "Confirm".',
        confirmText: 'Confirm');
    if (ok == true && mounted) Navigator.pop(context);
  }

  Widget _stepper() {
    return Container(
      decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            onPressed: () => setState(() => _servings = (_servings - 0.5).clamp(0.5, 10)),
          ),
          Container(width: 1, height: 24, color: AppColors.border),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: () => setState(() => _servings = (_servings + 0.5).clamp(0.5, 10)),
          ),
        ],
      ),
    );
  }
}
