import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Shared week-strip + close header used by every full-screen tracker sheet.
class _TrackerScaffold extends StatefulWidget {
  const _TrackerScaffold({
    required this.title,
    required this.headerColor,
    required this.builder,
  });

  final String title;
  final Color headerColor;
  final Widget Function(int dayIndex) builder;

  @override
  State<_TrackerScaffold> createState() => _TrackerScaffoldState();
}

class _TrackerScaffoldState extends State<_TrackerScaffold> {
  int _day = 0;
  static const _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  static const _nums = [6, 7, 8, 9, 10, 11, 12];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            color: widget.headerColor,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(widget.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CircleIconButton(
                        icon: Icons.close,
                        bg: Colors.white,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chevron_left),
                const Expanded(
                  child: Center(
                    child: Text('Week 1: October 6 - 12',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: List.generate(7, (i) {
                final on = i == _day;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _day = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: on ? AppColors.sagePill : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(_days[i],
                              style: TextStyle(
                                  fontSize: 12,
                                  color: on ? AppColors.black : AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text('${_nums[i]}',
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
          Expanded(child: widget.builder(_day)),
        ],
      ),
    );
  }
}

/// Hydration tracker (0 of 2,500 ml — tap value to enter via keypad).
class HydrationTracker {
  static Future<void> open(BuildContext context) {
    return Navigator.push(context,
        MaterialPageRoute(builder: (_) => const _HydrationScreen(), fullscreenDialog: true));
  }
}

class _HydrationScreen extends StatefulWidget {
  const _HydrationScreen();
  @override
  State<_HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<_HydrationScreen> {
  int _ml = 0;

  @override
  Widget build(BuildContext context) {
    return _TrackerScaffold(
      title: 'Hydration',
      headerColor: const Color(0xFF5C5A52),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _amountField(
              value: '$_ml',
              onTap: () async {
                final v = await _numberEntry(context, _ml, 'ml');
                if (v != null) setState(() => _ml = v);
              },
            ),
            const SizedBox(height: 10),
            const Text('of 2,500 ml', style: AppText.title),
            const SizedBox(height: 40),
            const Text('Your average daily water consumption in this Program is:',
                textAlign: TextAlign.center, style: AppText.body),
            const SizedBox(height: 16),
            const Text('0 ml', style: AppText.h1),
            const Spacer(),
            SageButton(label: 'DONE', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

/// Steps tracker.
class StepsTracker {
  static Future<void> open(BuildContext context) {
    return Navigator.push(context,
        MaterialPageRoute(builder: (_) => const _StepsScreen(), fullscreenDialog: true));
  }
}

class _StepsScreen extends StatefulWidget {
  const _StepsScreen();
  @override
  State<_StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<_StepsScreen> {
  int _steps = 5008;

  @override
  Widget build(BuildContext context) {
    return _TrackerScaffold(
      title: 'Steps',
      headerColor: const Color(0xFF5A5750),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _amountField(
              value: '$_steps',
              onTap: () async {
                final v = await _numberEntry(context, _steps, 'steps');
                if (v != null) setState(() => _steps = v);
              },
            ),
            const SizedBox(height: 10),
            const Text('of 10,000', style: AppText.title),
            const SizedBox(height: 40),
            const Text('Your average daily steps in this Program are:',
                textAlign: TextAlign.center, style: AppText.body),
            const SizedBox(height: 16),
            const Text('0 steps', style: AppText.h1),
            const Spacer(),
            SageButton(label: 'DONE', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

/// Sleep tracker (slider 0-12 hours).
class SleepTracker {
  static Future<void> open(BuildContext context) {
    return Navigator.push(context,
        MaterialPageRoute(builder: (_) => const _SleepScreen(), fullscreenDialog: true));
  }
}

class _SleepScreen extends StatefulWidget {
  const _SleepScreen();
  @override
  State<_SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<_SleepScreen> {
  double _hours = 7;

  @override
  Widget build(BuildContext context) {
    return _TrackerScaffold(
      title: 'Sleep',
      headerColor: const Color(0xFF6F7176),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text('${_hours.round()} hours', style: AppText.h1),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.sageTrack,
                inactiveTrackColor: AppColors.sageLight,
                thumbColor: Colors.white,
                trackHeight: 5,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _hours,
                min: 0,
                max: 12,
                onChanged: (v) => setState(() => _hours = v),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Your average nightly sleep in this Program is:',
                textAlign: TextAlign.center, style: AppText.body),
            const SizedBox(height: 16),
            const Text('0.0 hours', style: AppText.h1),
            const Spacer(),
            SageButton(label: 'DONE', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

Widget _amountField({required String value, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(value,
          style: const TextStyle(
              fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
    ),
  );
}

Future<int?> _numberEntry(BuildContext context, int initial, String unit) {
  final controller = TextEditingController(text: '$initial');
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(unit, style: AppText.bodyMuted),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(ctx, int.tryParse(controller.text) ?? initial),
                  child: const Text('Done'),
                ),
              ],
            ),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ],
        ),
      ),
    ),
  );
}
