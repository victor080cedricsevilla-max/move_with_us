import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../profile/profile_menu.dart';
import 'meal_models.dart';
import 'recipe_detail.dart';
import 'meal_guide.dart';
import 'recipes_grid.dart';
import 'shopping_list.dart';
import 'nutrition_info.dart';
import 'meal_edit.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  int _day = 0;
  List<Meal> _meals = defaultPlan();

  static const _dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  static const _dayNums = [13, 14, 15, 16, 17, 18, 19];

  int get _eaten =>
      _meals.where((m) => m.checked).fold(0, (s, m) => s + m.cal);
  int _macro(int Function(Meal) sel) =>
      _meals.where((m) => m.checked).fold(0, (s, m) => s + sel(m));

  Future<void> _edit() async {
    final result = await Navigator.push<List<Meal>>(
      context,
      MaterialPageRoute(builder: (_) => MealEditScreen(meals: _meals.map((m) => m.copy()).toList())),
    );
    if (result != null) setState(() => _meals = result);
  }

  Future<void> _reset() async {
    final choice = await showIOSSheet<String>(
      context,
      title: 'Reset to Original Meal Guide',
      actions: const [
        (label: 'Selected Day', value: 'day', destructive: false),
        (label: 'All Days of this Week', value: 'week', destructive: false),
        (label: 'All Days', value: 'all', destructive: false),
      ],
    );
    if (choice == null || !mounted) return;
    final ok = await showIOSAlert(context,
        title: 'Are you sure?',
        message: 'This will reset the Meal Guide from the selected day to all days to MWU-recommended.',
        confirmText: 'Confirm');
    if (ok == true) setState(() => _meals = defaultPlan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _calendar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                children: [
                  CalorieBar(value: _eaten, goal: 1600),
                  const SizedBox(height: 18),
                  MacroRow(
                    protein: [_macro((m) => m.p), 128],
                    fats: [_macro((m) => m.f), 58],
                    carbs: [_macro((m) => m.c), 141],
                    fibre: [_macro((m) => (m.cal / 60).round().clamp(0, 25)), 25],
                  ),
                  const SizedBox(height: 18),
                  for (int i = 0; i < _meals.length; i++) _mealTile(_meals[i]),
                ],
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Row(
        children: [
          const Text('Meals', style: AppText.display),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ShoppingListScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NutritionInfoScreen())),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileMenuScreen())),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFB9A79A),
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Icon(Icons.chevron_left),
              Expanded(
                child: Center(
                  child: Text('October 13 - 19',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: List.generate(7, (i) {
              final on = i == _day;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _day = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: on ? AppColors.sagePill : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(_dayNames[i],
                            style: TextStyle(
                                fontSize: 12,
                                color: on ? AppColors.black : AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('${_dayNums[i]}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: on ? AppColors.black : AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 20),
      ],
    );
  }

  Widget _mealTile(Meal m) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => RecipeDetailScreen(meal: m)));
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const Icon(Icons.shuffle, size: 22),
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: PhotoPlaceholder(width: 90, height: 90, radius: 14, color: m.color, icon: Icons.restaurant),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.name, style: AppText.title.copyWith(fontSize: 17)),
                  const SizedBox(height: 4),
                  Text('CAL:${m.cal} P:${m.p} F:${m.f} C:${m.c}',
                      style: AppText.bodyMuted),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => m.checked = !m.checked),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: m.checked ? AppColors.sagePill : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: AppColors.textSecondary),
                ),
                child: m.checked ? const Icon(Icons.check, size: 20) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: SageButton(
              label: 'MEAL GUIDES',
              height: 50,
              color: AppColors.sagePill,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MealGuideScreen())),
            ),
          ),
          const SizedBox(width: 12),
          CircleIconButton(icon: Icons.edit, size: 46, onTap: _edit),
          const SizedBox(width: 12),
          Expanded(
            child: SageButton(
              label: 'RECIPES',
              height: 50,
              color: AppColors.sagePill,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RecipesGridScreen())),
            ),
          ),
        ],
      ),
    );
  }
}
