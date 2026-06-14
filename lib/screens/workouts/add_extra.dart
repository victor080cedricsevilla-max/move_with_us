import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_images.dart';
import '../../widgets/common.dart';
import 'workout_detail.dart';

class _Coach {
  const _Coach(this.name, this.bio);
  final String name;
  final String bio;
}

class AddExtraScreen extends StatelessWidget {
  const AddExtraScreen({super.key});

  static const _coaches = [
    _Coach('Rachel Dillon',
        "Meet Rachel, 3x WBFF Bikini World Champion and Move With Us Body Sculpting Coach. Rachel's workouts feature a combination of circuit and resistance style sessions."),
    _Coach('Emma Dillon',
        'Join Emma as she guides you through weight-focused training, full-body sculpting sessions and dedicated booty building workouts.'),
    _Coach('Lisa Nicolaisen',
        'Lisa brings Pilates and mobility expertise with slow, controlled full-body sculpt sessions.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ADD AN EXTRA'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const PhotoPlaceholder(height: 200, color: Color(0xFFBFB2A4), icon: Icons.groups, asset: AppImages.gymBlue),
          const SizedBox(height: 20),
          _favCard(context),
          const SizedBox(height: 16),
          for (final c in _coaches) ...[
            _coachCard(c),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _favCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const _FavWorkoutsScreen())),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.favorite_border, size: 40),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favourites', style: AppText.title),
                  SizedBox(height: 4),
                  Text('From all your favourite trainers', style: AppText.bodyMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coachCard(_Coach c) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFB9A79A),
            child: Icon(Icons.person, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: AppText.title.copyWith(fontSize: 19)),
                const SizedBox(height: 6),
                Text(c.bio, style: AppText.body.copyWith(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavWorkoutsScreen extends StatelessWidget {
  const _FavWorkoutsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('FAVOURITES'), leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const WorkoutDetailScreen(
                        title: 'Full Body Weighted', addMode: true))),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Full Body Weighted (Rachel)', style: AppText.title),
                  SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.access_time, size: 18),
                    SizedBox(width: 6),
                    Text('45 mins'),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
