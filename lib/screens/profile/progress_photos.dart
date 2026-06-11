import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class ProgressPhotosScreen extends StatefulWidget {
  const ProgressPhotosScreen({super.key});

  @override
  State<ProgressPhotosScreen> createState() => _ProgressPhotosScreenState();
}

class _ProgressPhotosScreenState extends State<ProgressPhotosScreen> {
  bool _hasBefore = false;
  bool _hasLatest = false;

  Future<void> _addPhoto(bool before) async {
    final choice = await showIOSSheet<String>(context, actions: const [
      (label: 'Take Photo', value: 'take', destructive: false),
      (label: 'Choose Photo', value: 'choose', destructive: false),
    ]);
    if (choice != null) {
      setState(() => before ? _hasBefore = true : _hasLatest = true);
    }
  }

  void _share() {
    showIOSSheet<String>(context, title: 'Share Progress', actions: const [
      (label: 'Facebook', value: 'fb', destructive: false),
      (label: 'Instagram', value: 'ig', destructive: false),
      (label: 'More…', value: 'more', destructive: false),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Progress'),
        actions: [
          IconButton(icon: const Icon(Icons.ios_share), onPressed: _share),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              Expanded(child: _slot('Before', _hasBefore, () => _addPhoto(true))),
              const SizedBox(width: 14),
              Expanded(child: _slot('Latest', _hasLatest, () => _addPhoto(false))),
            ],
          ),
          const SizedBox(height: 24),
          SageButton(label: 'SHARE PROGRESS', onPressed: _share),
        ],
      ),
    );
  }

  Widget _slot(String label, bool has, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: has
              ? PhotoPlaceholder(height: 260, color: const Color(0xFFB9A79A), icon: Icons.person)
              : Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.textMuted),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppText.title),
      ],
    );
  }
}
