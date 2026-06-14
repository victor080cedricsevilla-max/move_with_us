import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_images.dart';
import '../../widgets/common.dart';

class ShareSelfieScreen extends StatefulWidget {
  const ShareSelfieScreen({super.key});

  @override
  State<ShareSelfieScreen> createState() => _ShareSelfieScreenState();
}

class _ShareSelfieScreenState extends State<ShareSelfieScreen> {
  bool _hasSelfie = false;

  Future<void> _addSelfie() async {
    final choice = await showIOSSheet<String>(context, actions: const [
      (label: 'Take Photo', value: 'take', destructive: false),
      (label: 'Choose Photo', value: 'choose', destructive: false),
    ]);
    if (choice != null) setState(() => _hasSelfie = true);
  }

  void _share() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Share Workout Selfie', style: AppText.title),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _ShareIcon(Icons.facebook),
                  SizedBox(width: 24),
                  _ShareIcon(Icons.camera_alt),
                  SizedBox(width: 24),
                  _ShareIcon(Icons.ios_share),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: PhotoPlaceholder(radius: 0, color: Color(0xFF6F6258), icon: Icons.person, asset: AppImages.mirrorPink),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleIconButton(
                    icon: Icons.close,
                    bg: Colors.black26,
                    fg: Colors.white,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Center(
                    child: Column(
                      children: [
                        Text('Day 1',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        SizedBox(height: 6),
                        Text('STRONG PROGRAM LEVEL 1',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        Text('with Rachel Dillon',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 58,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _addSelfie,
                        child: Center(
                          child: Text(_hasSelfie ? 'REMOVE SELFIE' : 'ADD SELFIE',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SageButton(label: 'SHARE ACHIEVEMENT', onPressed: _share),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  const _ShareIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.black,
      child: Icon(icon, color: Colors.white),
    );
  }
}
