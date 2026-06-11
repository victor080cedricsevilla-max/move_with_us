import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../profile/profile_menu.dart';
import '../goals/trackers.dart';
import 'active_rest_day.dart';
import 'on_demand.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.firstDay = false});
  final bool firstDay;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seg = 0; // 0 = My Program, 1 = On-Demand
  final _bannerCtrl = PageController();
  int _banner = 0;

  @override
  void initState() {
    super.initState();
    if (widget.firstDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showFirstDay());
    }
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  Future<void> _showFirstDay() async {
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                children: [
                  Text('Today officially marks the first day of your Program!',
                      textAlign: TextAlign.center, style: AppText.h2),
                  SizedBox(height: 12),
                  Text(
                    'An incredible journey is about to begin, and we want to let you know that you are capable of achieving anything that you set your mind to.',
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
                child: Text("LET'S DO THIS!",
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
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
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedPill(
                options: const ['My Program', 'On-Demand'],
                index: _seg,
                onChanged: (i) => setState(() => _seg = i),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _seg == 0 ? _myProgram() : const OnDemandView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          const Text('M O V E . W I T H U S',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 1)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileMenuScreen())),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFB9A79A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                Positioned(
                  bottom: -2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: AppColors.sageDeep, shape: BoxShape.circle),
                      child: const Icon(Icons.workspace_premium,
                          size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myProgram() {
    final banners = [
      _BannerData('Budget Recipes', 'EXPLORE NOW', const [Color(0xFF7C8A6A), Color(0xFF566048)]),
      _BannerData('CHOOSE YOUR\nSeason', 'DOWNLOAD', const [Color(0xFFA9C0D6), Color(0xFF7E99B3)]),
      _BannerData('We built your perfect\n7 Day Training Split', 'WATCH NOW', const [Color(0xFFBFAfa0), Color(0xFF8C7C6E)]),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _bannerCtrl,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _banner = i),
            itemBuilder: (_, i) {
              final b = banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GradientBanner(
                  height: 230,
                  colors: b.colors,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(b.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 200,
                          child: SageButton(
                            label: b.cta,
                            height: 48,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        PageDots(count: banners.length, index: _banner),
        const SizedBox(height: 22),
        const Text('STRONG Program Level 1', style: AppText.h2),
        const SizedBox(height: 14),
        SageButton(
          label: 'ACTIVE REST DAY',
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ActiveRestDayScreen())),
        ),
        const SizedBox(height: 26),
        const Text('My Meals', style: AppText.h2),
        const SizedBox(height: 12),
        const CalorieBar(value: 0, goal: 1600),
        const SizedBox(height: 18),
        const MacroRow(
          protein: [0, 128],
          fats: [0, 58],
          carbs: [0, 141],
          fibre: [0, 25],
        ),
        const SizedBox(height: 26),
        const Text('Goal Tracking', style: AppText.h2),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _goalCard('0 ml', 'Water', const Color(0xFFB9A03C),
                  () => HydrationTracker.open(context)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _goalCard('0', 'Steps', const Color(0xFF566066),
                  () => StepsTracker.open(context)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _goalCard('0 hours', 'Sleep', const Color(0xFF8A8F94),
                  () => SleepTracker.open(context)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _goalCard(String value, String label, Color c, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: PhotoPlaceholder(
        height: 120,
        color: c,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _BannerData {
  const _BannerData(this.title, this.cta, this.colors);
  final String title;
  final String cta;
  final List<Color> colors;
}
