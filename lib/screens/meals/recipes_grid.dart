import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'food_search.dart';
import 'create_recipe.dart';

class RecipesGridScreen extends StatelessWidget {
  const RecipesGridScreen({super.key});

  static const _cats = [
    ('Budget Recipes', Color(0xFF7C8A6A), true),
    ('Favourites', Color(0xFFB85C4A), false),
    ('Most Popular', Color(0xFF8A7B5C), false),
    ('15 Min Meals', Color(0xFFC2A05A), false),
    ('Fakeaway Faves', Color(0xFF5C6670), false),
    ('Sweet Snacks', Color(0xFF8C6A4A), false),
    ('One Pot Meals', Color(0xFFA98C5C), false),
    ('Meal Prep', Color(0xFF6A8A7A), false),
    ('Breakfast', Color(0xFFC98C7A), false),
    ('Lunch & Dinner', Color(0xFF7A8A5C), false),
    ('Desserts', Color(0xFFB59A7A), false),
    ('Snacks, Sides & Sauces', Color(0xFF9A7A6A), false),
    ('Vegan & Vegetarian', Color(0xFF6A8A4A), false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Recipes'),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateRecipeScreen())),
            child: const Text('Add New',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(28)),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Wide Budget Recipes banner first
          _banner(context, _cats.first.$1, _cats.first.$2, isNew: true, wide: true),
          const SizedBox(height: 14),
          for (int i = 1; i < _cats.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Expanded(child: _banner(context, _cats[i].$1, _cats[i].$2)),
                  const SizedBox(width: 14),
                  if (i + 1 < _cats.length)
                    Expanded(child: _banner(context, _cats[i + 1].$1, _cats[i + 1].$2))
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _banner(BuildContext context, String title, Color color, {bool isNew = false, bool wide = false}) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => FoodSearchScreen(title: title))),
      child: PhotoPlaceholder(
        height: wide ? 150 : 130,
        radius: 14,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            if (isNew) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Text('NEW', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
