import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class MealGuideScreen extends StatelessWidget {
  const MealGuideScreen({super.key});

  static const _cats = [
    ('ALL', Color(0xFF9AA47A)),
    ('♡ FAVOURITES', Color(0xFF8A9A6A)),
    ('NEW MEAL GUIDES', Color(0xFF7A8A5A)),
    ('BACK TO BASICS', Color(0xFF6A7A4A)),
    ('BUSY GIRL', Color(0xFFB59A6A)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Meal Guide')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(28)),
            child: const TextField(
              decoration: InputDecoration(hintText: 'Search', border: InputBorder.none, icon: Icon(Icons.search)),
            ),
          ),
          const SizedBox(height: 16),
          for (final c in _cats)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => _MealCategoryScreen(title: c.$1.replaceAll('♡ ', '')))),
                child: PhotoPlaceholder(
                  height: 130,
                  radius: 14,
                  color: c.$2,
                  label: c.$1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MealCategoryScreen extends StatefulWidget {
  const _MealCategoryScreen({required this.title});
  final String title;

  @override
  State<_MealCategoryScreen> createState() => _MealCategoryScreenState();
}

class _MealCategoryScreenState extends State<_MealCategoryScreen> {
  // Two example meal-guide bundles, each favouritable.
  final _bundles = <List<String>>[
    ['Banana & Peanut Butter Smoothie', 'Rice Crackers & Avocado', 'Ham & Cheese Toastie', 'Almonds', 'Steak, Chips & Salad'],
    ['Cream Cheese & Smoked Salmon Bagel', 'Rice Cakes & Peanut Butter', 'Chicken Burrito Bowl', 'Fruit & Trail Mix', 'Spaghetti Bolognese'],
  ];
  final Set<int> _faved = {0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text(widget.title)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.cream,
            child: const Text('Calories: 1600   P: 128   F: 58   C: 141', style: AppText.bodyMuted),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _bundles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _bundleCard(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bundleCard(int index) {
    final faved = _faved.contains(index);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (final meal in _bundles[index])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const PhotoPlaceholder(width: 50, height: 50, radius: 10, color: Color(0xFFC4BCB2), icon: Icons.restaurant),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(meal, style: AppText.body.copyWith(fontSize: 17))),
                ],
              ),
            ),
          const Divider(),
          GestureDetector(
            onTap: () => setState(() => faved ? _faved.remove(index) : _faved.add(index)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(faved ? Icons.favorite : Icons.favorite_border,
                      color: faved ? Colors.red : AppColors.black),
                  const SizedBox(width: 10),
                  Text(faved ? 'Added to favourites' : 'Add to favourites',
                      style: AppText.body.copyWith(fontSize: 17)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
