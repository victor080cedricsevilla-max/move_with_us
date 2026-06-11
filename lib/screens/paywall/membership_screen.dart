import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../program_picker/find_perfect_fit.dart';
import 'experience_walkthrough.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key, this.standalone = false});

  /// When opened from the profile menu we simply pop instead of advancing
  /// through onboarding.
  final bool standalone;

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool _annual = true;

  void _advance() {
    if (widget.standalone) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FindPerfectFitScreen()),
      );
    }
  }

  Future<void> _purchase() async {
    final confirmed = await _showAppStoreSheet();
    if (!mounted || confirmed != true) return;
    await showIOSNotice(
      context,
      title: "You're all set.",
      message: 'Your purchase was successful.',
      okText: 'OK',
    );
    if (mounted) _advance();
  }

  void _startTrial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienceWalkthrough(onDone: _advance),
      ),
    );
  }

  Future<bool?> _showAppStoreSheet() {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.sheetGrey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('App Store',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const Spacer(),
                CircleIconButton(
                  icon: Icons.close,
                  bg: const Color(0xFFDDDDDD),
                  onTap: () => Navigator.pop(ctx, false),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text('M',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_annual ? 'Annual Membership' : 'Monthly Membership',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)),
                            const Text('Move With Us  4+',
                                style: TextStyle(color: AppColors.textSecondary)),
                            const Text('Subscription',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('1-week free trial',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Starting today',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_annual ? '\$149.99 per year' : '\$18.99 per month',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.iosBlue, width: 2),
                    ),
                    child: const Icon(Icons.login, color: AppColors.iosBlue),
                  ),
                  const SizedBox(height: 8),
                  const Text('Confirm with Side Button',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tapping anywhere on the confirm row simulates the side-button press.
            SageButton(
              label: 'Double Click to Subscribe',
              color: AppColors.sageLight,
              onPressed: () => Navigator.pop(ctx, true),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => widget.standalone
                      ? Navigator.pop(context)
                      : _advance(),
                ),
              ),
              const SizedBox(height: 6),
              GradientBanner(
                height: 230,
                colors: const [Color(0xFF8E7F77), Color(0xFF5C5048)],
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.phone_iphone,
                          size: 120, color: Colors.white24),
                    ),
                    Positioned(
                      bottom: 14,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Save 33%',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _planCard(
                title: 'Annual Membership',
                price: '\$149.99 PER YEAR',
                badge: 'LIMITED TIME OFFER',
                selected: _annual,
                onTap: () => setState(() => _annual = true),
              ),
              const SizedBox(height: 14),
              _planCard(
                title: 'Monthly Membership',
                price: '\$18.99 PER MONTH',
                selected: !_annual,
                onTap: () => setState(() => _annual = false),
              ),
              const SizedBox(height: 18),
              const Text(
                'Membership unlocks full access to the Move With Us App, including all Programs & Levels, Challenges & Nutrition features.',
                style: AppText.body,
              ),
              const SizedBox(height: 20),
              SageButton(label: 'PURCHASE NOW', onPressed: _purchase),
              const SizedBox(height: 14),
              SageButton(
                label: 'START YOUR 7-DAY FREE TRIAL',
                color: AppColors.sageLight,
                onPressed: _startTrial,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 14),
              const Text('NOT READY TO START YOUR MEMBERSHIP?',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 14),
              const Text('EXPLORE OUR PROGRAMS',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              const SizedBox(height: 4),
              const Text('No Free Trial For Individual Programs Available',
                  style: AppText.bodyMuted),
              const SizedBox(height: 16),
              _exploreCard('BACK ON TRACK PROGRAM',
                  ['6 Weeks', 'Shape Physique', 'Define Core', 'Busy Gym'],
                  featured: true),
              const SizedBox(height: 16),
              _exploreCard('3-2-1 METHOD DEFINE EDITION PROGRAM',
                  ['4 Weeks', 'Strength', 'Pilates', 'Running']),
              const SizedBox(height: 16),
              _exploreCard('BIKINI BUILD PROGRAM',
                  ['8 Weeks', 'Build Muscle', 'Strength', 'Cardio']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String price,
    String? badge,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
        decoration: BoxDecoration(
          color: selected ? AppColors.cream : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.black : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h2),
                  const SizedBox(height: 6),
                  Text(price,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  if (badge != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 18, color: AppColors.sageDeep),
                        const SizedBox(width: 6),
                        Text(badge,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? AppColors.sage : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected ? AppColors.sage : AppColors.border),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exploreCard(String title, List<String> tags, {bool featured = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: AppColors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PhotoPlaceholder(
                  height: 150,
                  radius: 0,
                  color: const Color(0xFFB7A99B),
                ),
                if (featured)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(14)),
                      ),
                      child: const Text('FEATURED',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < tags.length; i++)
                        Column(
                          children: [
                            Icon(
                              [
                                Icons.calendar_today,
                                Icons.hourglass_empty,
                                Icons.self_improvement,
                                Icons.alarm
                              ][i % 4],
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            Text(tags[i],
                                style: AppText.bodyMuted.copyWith(fontSize: 13)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
