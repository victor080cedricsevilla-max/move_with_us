import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'meal_models.dart';

class MealEditScreen extends StatefulWidget {
  const MealEditScreen({super.key, required this.meals});
  final List<Meal> meals;

  @override
  State<MealEditScreen> createState() => _MealEditScreenState();
}

class _MealEditScreenState extends State<MealEditScreen> {
  late final List<Meal> _meals = widget.meals;

  Future<void> _save() async {
    final scope = await showIOSSheet<String>(
      context,
      title: 'Save Changes',
      actions: const [
        (label: 'Selected Day', value: 'day', destructive: false),
        (label: 'All Days of this Week', value: 'week', destructive: false),
        (label: 'All Days', value: 'all', destructive: false),
      ],
    );
    if (scope == null || !mounted) return;
    final ok = await showIOSAlert(context,
        title: 'Are you sure?',
        message: 'The Meal guide will be applied from the selected day to all days of this week.',
        confirmText: 'Confirm');
    if (ok == true && mounted) Navigator.pop(context, _meals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Edit Meals')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        itemCount: _meals.length,
        onReorder: (oldI, newI) => setState(() {
          if (newI > oldI) newI--;
          _meals.insert(newI, _meals.removeAt(oldI));
        }),
        itemBuilder: (_, i) {
          final m = _meals[i];
          return Dismissible(
            key: ValueKey(m.name + i.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: Colors.red,
              child: const Text('Delete',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            onDismissed: (_) => setState(() => _meals.removeAt(i)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _meals.removeAt(i)),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.remove, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PhotoPlaceholder(width: 70, height: 70, radius: 12, color: m.color, icon: Icons.restaurant),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: AppText.title.copyWith(fontSize: 16)),
                        Text('CAL:${m.cal} P:${m.p} F:${m.f} C:${m.c}', style: AppText.bodyMuted),
                      ],
                    ),
                  ),
                  ReorderableDragStartListener(
                    index: i,
                    child: const Icon(Icons.drag_handle, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(
          children: [
            Expanded(
              child: SageButton(
                label: 'DISCARD',
                color: AppColors.field,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SageButton(label: 'SAVE CHANGES', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
