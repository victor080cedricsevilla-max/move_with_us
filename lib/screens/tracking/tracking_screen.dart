import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../profile/profile_menu.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _range = 0; // 1/3/6 months
  int _view = 0; // 0 = My Stats, 1 = My Entries

  Future<void> _updateMeasurements() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update Measurements', style: AppText.h2),
            const SizedBox(height: 16),
            for (final m in ['Chest', 'Waist', 'Hips', 'Arm', 'Thigh', 'Weight'])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CreamField(
                    label: m,
                    keyboardType: TextInputType.number,
                    suffixText: m == 'Weight' ? 'kg' : 'cm'),
              ),
            const SizedBox(height: 8),
            SageButton(label: 'SAVE', onPressed: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                const Text('Tracking', style: AppText.display),
                const Spacer(),
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
            const SizedBox(height: 14),
            SegmentedPill(
              options: const ['1 Month', '3 Months', '6 Months'],
              index: _range,
              onChanged: (i) => setState(() => _range = i),
            ),
            const SizedBox(height: 20),
            _chart(),
            const SizedBox(height: 8),
            const Text('06/10', style: AppText.bodyMuted),
            const SizedBox(height: 18),
            _measurementGrid(),
            const SizedBox(height: 22),
            SageButton(
              label: 'UPDATE MEASUREMENTS',
              color: AppColors.field,
              textColor: AppColors.textSecondary,
              onPressed: _updateMeasurements,
            ),
            const SizedBox(height: 22),
            SegmentedPill(
              options: const ['My Stats', 'My Entries'],
              index: _view,
              onChanged: (i) => setState(() => _view = i),
            ),
            const SizedBox(height: 16),
            if (_view == 0) _myStats() else _myEntries(),
          ],
        ),
      ),
    );
  }

  Widget _chart() {
    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final y in [60, 50, 40, 30, 20, 10, 0])
                Text('$y', style: AppText.bodyMuted),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomPaint(
              painter: _ChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _measurementGrid() {
    final rows = [
      [('CHEST', '0 cm', AppColors.chest), ('WAIST', '0 cm', AppColors.waist), ('HIPS', '0 cm', AppColors.hips)],
      [('ARM', '0 cm', AppColors.arm), ('THIGH', '0 cm', AppColors.thigh), ('WEIGHT', '57 kg', AppColors.weight)],
    ];
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                for (final m in row)
                  Expanded(
                    child: Column(
                      children: [
                        Text(m.$1,
                            style: TextStyle(
                                color: m.$3, fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(m.$2, style: AppText.h2),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _myStats() {
    final stats = [
      ('Start Weight', '57 KG'),
      ('Weight Difference', '0 KG'),
      ('Start Chest', '0 CM'),
      ('Chest Difference', '0 CM'),
      ('Start Waist', '0 CM'),
      ('Waist Difference', '0 CM'),
      ('Start Hips', '0 CM'),
      ('Hips Difference', '0 CM'),
      ('Start Arm', '0 CM'),
      ('Arm Difference', '0 CM'),
    ];
    return Column(
      children: [
        for (final s in stats)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(s.$1, style: AppText.title.copyWith(fontSize: 17)),
                const Spacer(),
                Text(s.$2, style: AppText.title.copyWith(fontSize: 17)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _myEntries() {
    return Column(
      children: [
        for (final d in ['06 October 2025'])
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d, style: AppText.title),
                const SizedBox(height: 8),
                const Text('Weight 57 kg   •   Chest 0 cm   •   Waist 0 cm', style: AppText.bodyMuted),
              ],
            ),
          ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (int i = 0; i <= 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // weight point (green, ~57) and a measurement point (orange, ~0)
    final cx = size.width * 0.5;
    final greenY = size.height * (1 - 57 / 60);
    final orangeY = size.height * (1 - 1 / 60);
    void ring(Offset c, Color color) {
      canvas.drawCircle(
          c,
          7,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }

    ring(Offset(cx, greenY), AppColors.weight);
    ring(Offset(cx, orangeY), AppColors.thigh);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
