import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'food_detail.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key, this.title = 'Recipes'});
  final String title;

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final _search = TextEditingController();

  static const _foods = [
    ('Raspberry Choc Yoghurt', 182),
    ('Grilled Sweet Chilli Tofu Skewers', 183),
    ('Edamame Dip On Rice Cakes', 183),
    ('Kiwi Fruit Popsicles', 184),
    ('Breakfast Egg Muffins', 184),
    ('Mango Frozen Parfait', 185),
    ('Mini Apple Pies', 185),
    ('Strawberry Popsicles', 186),
    ('Pasta Sauce Traditional (Val Verde)', 34),
    ('Tomato Basil Pasta Sauce (Barilla)', 58),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.toLowerCase();
    final results = _foods.where((f) => f.$1.toLowerCase().contains(q)).toList();
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        ),
        leadingWidth: 80,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(28)),
                    child: TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: _openFilters,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                const Text('Recipes', style: AppText.h2),
                const SizedBox(height: 8),
                for (final f in results) _row(f.$1, f.$2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String name, int cal) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(name: name, calories: cal))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const PhotoPlaceholder(width: 64, height: 64, radius: 12, color: Color(0xFFC4BCB2), icon: Icons.restaurant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppText.title.copyWith(fontSize: 17)),
                  const SizedBox(height: 4),
                  Text('$cal Calories', style: AppText.bodyMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  bool _calories = false;
  bool _protein = true;
  bool _fatsCarbs = false;
  bool _dietary = false;
  bool _categories = false;
  RangeValues _proteinRange = const RangeValues(0, 75);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              const Spacer(),
              const Text('Filters', style: AppText.h2),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Remaining Macros', style: AppText.title),
          const Text('CALORIES: 1600   P: 128  F: 58  C: 141', style: AppText.bodyMuted),
          const SizedBox(height: 18),
          _check('Filter Calories', _calories, (v) => setState(() => _calories = v)),
          const Divider(),
          _check('Filter Protein', _protein, (v) => setState(() => _protein = v)),
          if (_protein)
            RangeSlider(
              values: _proteinRange,
              min: 0,
              max: 150,
              activeColor: AppColors.sageTrack,
              labels: RangeLabels('${_proteinRange.start.round()}', '${_proteinRange.end.round()}'),
              onChanged: (v) => setState(() => _proteinRange = v),
            ),
          const Divider(),
          _check('Filter Fats and Carbs', _fatsCarbs, (v) => setState(() => _fatsCarbs = v)),
          const Divider(),
          _check('Dietary Restrictions', _dietary, (v) => setState(() => _dietary = v)),
          const Divider(),
          _check('Meal Categories', _categories, (v) => setState(() => _categories = v)),
          const SizedBox(height: 24),
          SageButton(label: 'APPLY', onPressed: () => Navigator.pop(context)),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLEAR',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _check(String label, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: value ? AppColors.sagePill : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: value ? AppColors.sagePill : AppColors.textSecondary),
              ),
              child: value ? const Icon(Icons.check, size: 18) : null,
            ),
            const SizedBox(width: 14),
            Text(label, style: AppText.body.copyWith(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
