import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _items = <(String, String)>[
    ('Chicken Breast (No Skin) (Raw)', '1400 g'),
    ('White Basmati Rice (Raw)', '329 g'),
    ('Non-Starchy Vegetables', '1540 g'),
    ('Honey', '70 g'),
    ('Rolled Oats (Raw) (Gluten Free Optional)', '315 g'),
    ('Whey Protein Powder', '210 g'),
    ('Peanut Butter', '175 g'),
    ('Almonds', '203 g'),
    ('Wholemeal Bread', '560 g'),
    ('Ham (Leg) (Lean)', '630 g'),
    ('Cheddar Cheese', '231 g'),
    ('Bagels (Plain)', '315 g'),
    ('Avocado', '315 g'),
  ];
  final Set<int> _checked = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _welcome());
  }

  Future<void> _welcome() async {
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                children: [
                  Text('Welcome to your Shopping List!', textAlign: TextAlign.center, style: AppText.h2),
                  SizedBox(height: 12),
                  Text(
                    "The quantities displayed here are to cover a week's worth of your default Meal Guide foods. You can pop any additional items underneath the default list!\n\nPressing the little shaker button in the top right corner will take you to the Flavour Boosters section.\n\nEnjoy your meal prep!",
                    textAlign: TextAlign.center,
                    style: AppText.bodyMuted,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            InkWell(
              onTap: () => Navigator.pop(ctx),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Ok', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FlavourBoostersScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const _ShoppingInfoScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text('Meal Guide Ingredients', style: AppText.title),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _checked.clear()),
                  child: const Text('Reset', style: AppText.body),
                ),
              ],
            ),
          ),
          for (int i = 0; i < _items.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() =>
                        _checked.contains(i) ? _checked.remove(i) : _checked.add(i)),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _checked.contains(i) ? AppColors.sagePill : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: AppColors.textSecondary),
                      ),
                      child: _checked.contains(i) ? const Icon(Icons.check, size: 18) : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(_items[i].$1, style: AppText.body.copyWith(fontSize: 17))),
                  Text(_items[i].$2, style: AppText.body),
                ],
              ),
            ),
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text('Additional Items', style: AppText.title),
          ),
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [Icon(Icons.add_circle_outline), SizedBox(width: 12), Text('Add another item', style: AppText.body)]),
            ),
          ),
        ],
      ),
    );
  }
}

class FlavourBoostersScreen extends StatelessWidget {
  const FlavourBoostersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: const [
          Text('Flavour Boosters', style: AppText.h1),
          SizedBox(height: 18),
          Text(
            'Here is a list of our pantry must-haves! Try to keep them available at all times to add some "oomph" to any meal.',
            style: AppText.body,
          ),
          SizedBox(height: 12),
          Text("These options are all low-calorie and we don't track them in addition to other foods.",
              style: AppText.body),
          SizedBox(height: 24),
          _BoosterRow('Soy Sauce (Salt Reduced)'),
          _BoosterRow('Sugar Free Sweet Chilli Sauce'),
          _BoosterRow('Dijon Mustard'),
          _BoosterRow('Garlic & Herbs'),
          _BoosterRow('Lemon & Lime Juice'),
          _BoosterRow('Hot Sauce'),
        ],
      ),
    );
  }
}

class _BoosterRow extends StatelessWidget {
  const _BoosterRow(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.local_dining, size: 20),
          const SizedBox(width: 14),
          Text(name, style: AppText.body.copyWith(fontSize: 17)),
        ],
      ),
    );
  }
}

class _ShoppingInfoScreen extends StatelessWidget {
  const _ShoppingInfoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: const [
          Text('Shopping list info', style: AppText.h1),
          SizedBox(height: 18),
          Text('Welcome to your Shopping List!', style: AppText.body),
          SizedBox(height: 12),
          Text("The quantities displayed here are to cover a week's worth of your default Meal Guide foods, starting from the current day.\n\nEnjoy your meal prep!",
              style: AppText.body),
          SizedBox(height: 18),
          Text('UPDATING YOUR SHOPPING LIST', style: AppText.title),
          SizedBox(height: 10),
          Text('Your shopping list refreshes automatically at midnight every day to reflect the current day + 6 following days.\n\nIf you have made some changes to this period and want them to reflect immediately, use the Reset button at the top right of the screen.',
              style: AppText.body),
          SizedBox(height: 18),
          Text('ADDING YOUR OWN ITEMS', style: AppText.title),
          SizedBox(height: 10),
          Text('In addition to the items in your Meal Guide, you can also add more to your list - those can be anything you like!',
              style: AppText.body),
        ],
      ),
    );
  }
}
