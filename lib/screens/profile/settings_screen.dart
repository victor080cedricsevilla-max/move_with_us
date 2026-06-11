import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _metric = true;
  bool _appleHealth = false;
  bool _pregnancy = false;
  bool _social = true;
  bool _email = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _sectionLabel('Measurement System'),
          SegmentedPill(
            options: const ['Metric', 'US Units'],
            index: _metric ? 0 : 1,
            onChanged: (i) => setState(() => _metric = i == 0),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Integrations'),
          _switchRow('Apple Health', _appleHealth, (v) => setState(() => _appleHealth = v)),
          _switchRow('Pregnancy Mode', _pregnancy, (v) => setState(() => _pregnancy = v)),
          const SizedBox(height: 20),
          _sectionLabel('Notifications'),
          _switchRow('Social Notifications', _social, (v) => setState(() => _social = v)),
          _switchRow('Email Updates', _email, (v) => setState(() => _email = v)),
          const SizedBox(height: 28),
          _sectionLabel('Reboot'),
          OutlinePillButton(
            label: 'Reboot My Program',
            onPressed: () => showIOSAlert(context,
                title: 'Reboot My Program',
                message: 'This will restart your current program from week 1.',
                confirmText: 'Reboot'),
          ),
          const SizedBox(height: 14),
          OutlinePillButton(
            label: 'Reboot My Meal Guide',
            onPressed: () => showIOSAlert(context,
                title: 'Reboot My Meal Guide',
                message: 'This will reset your meal guide to the recommended default.',
                confirmText: 'Reboot'),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text, style: AppText.title),
      );

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppText.body.copyWith(fontSize: 17))),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.sage,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
