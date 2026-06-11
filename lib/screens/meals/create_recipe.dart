import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  String _type = 'Food Item';
  final _title = TextEditingController();
  final List<int> _ingredients = [0];
  final List<int> _steps = [0];

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecipe = _type == 'Recipe';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Create Food Item Or Recipe'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          _dropdown(),
          const SizedBox(height: 16),
          CreamField(hint: 'Title', controller: _title),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: CreamField(hint: 'Protein', keyboardType: TextInputType.number)),
            const SizedBox(width: 14),
            Expanded(child: CreamField(hint: 'Fats', keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: CreamField(hint: 'Carbs', keyboardType: TextInputType.number)),
            const SizedBox(width: 14),
            Expanded(child: CreamField(hint: 'Fibre', keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 16),
          CreamField(label: 'Calories', controller: TextEditingController(text: '0'), keyboardType: TextInputType.number),
          if (!isRecipe) ...[
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: CreamField(hint: 'Serving Qty', keyboardType: TextInputType.number)),
              const SizedBox(width: 14),
              Expanded(child: CreamField(hint: 'Serving Unit')),
            ]),
          ],
          const SizedBox(height: 24),
          const Text('Additional Information', style: AppText.h2),
          const SizedBox(height: 12),
          _imageDrop(),
          if (isRecipe) ...[
            const SizedBox(height: 22),
            const Text('Ingredients', style: AppText.h2),
            const SizedBox(height: 12),
            for (int i = 0; i < _ingredients.length; i++) _ingredientRow(i),
            _addRow('Add another ingredient', () => setState(() => _ingredients.add(0))),
            const SizedBox(height: 22),
            const Text('Method', style: AppText.h2),
            const SizedBox(height: 12),
            for (int i = 0; i < _steps.length; i++) _stepRow(i),
            _addRow('Add another step', () => setState(() => _steps.add(0))),
          ],
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: SageButton(
          label: 'SAVE',
          onPressed: () {
            final name = _title.text.isEmpty ? 'New Item' : _title.text;
            final messenger = ScaffoldMessenger.of(context);
            Navigator.pop(context);
            messenger.showSnackBar(
              SnackBar(content: Text('Added: $name, you can now search for it in the database')),
            );
          },
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 2),
            child: Text('Food Type', style: AppText.label),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _type,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Food Item', child: Text('Food Item')),
                DropdownMenuItem(value: 'Recipe', child: Text('Recipe')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageDrop() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.black, width: 2, style: BorderStyle.solid),
      ),
      child: const Center(child: Icon(Icons.image_outlined, size: 56)),
    );
  }

  Widget _ingredientRow(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: CreamField(hint: 'Ingredient')),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _ingredients.removeAt(i)),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFD81B60),
                  child: Icon(Icons.delete_outline, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: CreamField(hint: 'Measure')),
            const SizedBox(width: 14),
            Expanded(child: CreamField(label: 'Qty', controller: TextEditingController(text: '1.00'))),
          ]),
        ],
      ),
    );
  }

  Widget _stepRow(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Step ${i + 1}', style: AppText.title),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _steps.removeAt(i)),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFD81B60),
                  child: Icon(Icons.delete_outline, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 90,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(16)),
            child: const TextField(
              maxLines: null,
              decoration: InputDecoration(border: InputBorder.none, hintText: '…'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addRow(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline),
            const SizedBox(width: 12),
            Text(label, style: AppText.body.copyWith(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
