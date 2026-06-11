import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class UpdateMacrosScreen extends StatelessWidget {
  const UpdateMacrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Update My Macros')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          const Text('Adjust your daily targets', style: AppText.h2),
          const SizedBox(height: 8),
          const Text('We recommend closely hitting your daily targets for best results.',
              style: AppText.bodyMuted),
          const SizedBox(height: 24),
          CreamField(label: 'Calories', controller: TextEditingController(text: '1600'), suffixText: 'kcal'),
          const SizedBox(height: 16),
          CreamField(label: 'Protein', controller: TextEditingController(text: '128'), suffixText: 'g'),
          const SizedBox(height: 16),
          CreamField(label: 'Fats', controller: TextEditingController(text: '58'), suffixText: 'g'),
          const SizedBox(height: 16),
          CreamField(label: 'Carbs', controller: TextEditingController(text: '141'), suffixText: 'g'),
          const SizedBox(height: 16),
          CreamField(label: 'Fibre', controller: TextEditingController(text: '25'), suffixText: 'g'),
          const SizedBox(height: 32),
          SageButton(
            label: 'UPDATE MACROS',
            onPressed: () => showIOSNotice(context,
                title: 'Macros Updated',
                message: 'Your updated Meal Guide is now available!',
                okText: 'Okay'),
          ),
        ],
      ),
    );
  }
}
