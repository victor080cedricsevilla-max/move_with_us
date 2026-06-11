import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../onboarding/intro_carousel.dart';
import '../paywall/membership_screen.dart';
import 'edit_profile.dart';
import 'settings_screen.dart';
import 'update_macros.dart';
import 'progress_photos.dart';
import 'support_chat.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  void _signOut(BuildContext context) async {
    final ok = await showIOSAlert(context,
        title: 'Sign Out', message: 'Are you sure you want to sign out?', confirmText: 'Sign Out');
    if (ok == true && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const IntroCarousel()),
        (route) => false,
      );
    }
  }

  void _delete(BuildContext context) async {
    final ok = await showIOSAlert(context,
        title: 'Delete Account',
        message: 'This will permanently delete your account and all data. This cannot be undone.',
        confirmText: 'Delete',
        destructive: true);
    if (ok == true && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const IntroCarousel()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.workspace_premium, size: 18, color: AppColors.sageDeep),
                    SizedBox(width: 6),
                    Text('Platinum', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                child: const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFFB9A79A),
                  child: Icon(Icons.person, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Julia Screens', style: AppText.h2),
                  SizedBox(height: 4),
                  Text('screensdesigntest@gmail.com', style: AppText.bodyMuted),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _row(context, Icons.fitness_center, 'STRONG Program'),
          _row(context, Icons.swap_horiz, 'Change Program'),
          _row(context, Icons.card_membership, 'Manage Membership',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MembershipScreen(standalone: true)))),
          _row(context, Icons.person_outline, 'My Account',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
          _row(context, Icons.settings_outlined, 'Settings',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          _row(context, Icons.pie_chart_outline, 'Update My Macros',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UpdateMacrosScreen()))),
          _row(context, Icons.photo_camera_outlined, 'My Progress',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProgressPhotosScreen()))),
          _row(context, Icons.podcasts, 'Podcasts'),
          _row(context, Icons.facebook, 'Facebook Group'),
          _row(context, Icons.chat_bubble_outline, 'Chat with us',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SupportChatScreen()))),
          _row(context, Icons.description_outlined, 'Terms & Conditions'),
          _row(context, Icons.privacy_tip_outlined, 'Privacy Policy'),
          const SizedBox(height: 8),
          const Divider(),
          _row(context, Icons.delete_outline, 'Delete Account',
              danger: true, onTap: () => _delete(context)),
          _row(context, Icons.logout, 'Sign out', onTap: () => _signOut(context)),
          const SizedBox(height: 20),
          const Center(
            child: Text('v5.4.5', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label,
      {VoidCallback? onTap, bool danger = false}) {
    final color = danger ? Colors.red.shade400 : AppColors.textPrimary;
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label,
                  style: AppText.body.copyWith(fontSize: 17, color: color)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
