import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class VideoDetailScreen extends StatefulWidget {
  const VideoDetailScreen({super.key, required this.title, required this.mins});
  final String title;
  final String mins;

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  bool _playing = false;
  double _speed = 1.0;

  void _showSpeedMenu() {
    showMenu<double>(
      context: context,
      position: const RelativeRect.fromLTRB(120, 240, 16, 0),
      items: [
        const PopupMenuItem(enabled: false, child: Text('Playback Speed')),
        for (final s in [0.5, 1.0, 1.25, 1.5, 2.0])
          PopupMenuItem(
            value: s,
            child: Row(
              children: [
                if (s == _speed) const Icon(Icons.check, size: 18),
                if (s == _speed) const SizedBox(width: 8),
                Text('${s}x'),
              ],
            ),
          ),
      ],
    ).then((v) {
      if (v != null) setState(() => _speed = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _player(),
          Container(
            color: AppColors.card,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(widget.title, style: AppText.h2)),
                    const Icon(Icons.favorite_border, size: 28),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('With Lisa Nicolaisen', style: AppText.bodyMuted),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text('Workout Intensity', style: AppText.body),
                    const Spacer(),
                    const Icon(Icons.star, size: 20),
                    const Icon(Icons.star, size: 20),
                    const Text('  •  '),
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 4),
                    Text(widget.mins, style: AppText.body),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Get ready to sculpt your entire body and feel the burn, starting the week off with a pilates full-body sculpt class. Expect to target each muscle group with slow and controlled movements. This session is perfect to get your day started with some feel-good movement.',
              style: AppText.body,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("What's needed", style: AppText.title),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SageButton(label: 'START WORKOUT', onPressed: () {}),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _player() {
    return AspectRatio(
      aspectRatio: 16 / 11,
      child: Stack(
        children: [
          const PhotoPlaceholder(
            radius: 0,
            color: Color(0xFF7E6A57),
            icon: Icons.spa,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: const [
                Icon(Icons.fullscreen, color: Colors.white),
                SizedBox(width: 12),
                Icon(Icons.airplay, color: Colors.white),
              ],
            ),
          ),
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(Icons.volume_up, color: Colors.white),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.replay_10, color: Colors.white, size: 40),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () => setState(() => _playing = !_playing),
                  child: Icon(
                    _playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 54,
                  ),
                ),
                const SizedBox(width: 30),
                const Icon(Icons.forward_10, color: Colors.white, size: 40),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                const Text('00:00', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 3,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('-34:26', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showSpeedMenu,
                  child: const Icon(Icons.more_horiz, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
