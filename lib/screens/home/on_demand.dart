import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'video_detail.dart';

class _Vid {
  const _Vid(this.title, this.mins, {this.tag, this.isNew = false});
  final String title;
  final String mins;
  final String? tag;
  final bool isNew;
}

class OnDemandView extends StatefulWidget {
  const OnDemandView({super.key});

  @override
  State<OnDemandView> createState() => _OnDemandViewState();
}

class _OnDemandViewState extends State<OnDemandView> {
  static const _split = [
    _Vid('Full Body Pilates Sculpt 🔥', '35 Mins', tag: 'DAY ONE', isNew: true),
    _Vid('Toned Upper Body 💪', '32 Mins', tag: 'DAY TWO', isNew: true),
    _Vid('Booty Strength 🍑', '32 Mins', tag: 'DAY SIX', isNew: true),
    _Vid('Full Body Sunday Stretch 🧘', '13 Mins', tag: 'DAY SEVEN', isNew: true),
  ];
  static const _pregnancy = [
    _Vid('Incontinence aka Leaking', '72 Secs'),
    _Vid('SHAPES: When To Know', '6 Mins'),
  ];
  static const _pelvic = [
    _Vid('Pelvic Floor Basics', '8 Mins'),
    _Vid('Deep Core Connection', '11 Mins'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinePillButton(
                label: 'No Favourite Videos',
                height: 54,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const _FavouritesScreen())),
              ),
            ),
            const SizedBox(width: 12),
            CircleIconButton(
              icon: Icons.tune,
              bg: Colors.transparent,
              size: 44,
              onTap: _openFilter,
            ),
          ],
        ),
        const SizedBox(height: 22),
        _section('7 Day Training Split: Community Fav...', _split),
        const SizedBox(height: 22),
        _section('Pregnancy 101: Your Expert Guide', _pregnancy),
        const SizedBox(height: 22),
        _section('Pelvic Floor Series', _pelvic),
      ],
    );
  }

  Widget _section(String title, List<_Vid> vids) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h2.copyWith(fontSize: 20)),
            ),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => _ViewAllScreen(title: title, vids: vids))),
              child: const Text('View All',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: vids.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _videoTile(vids[i], width: 260),
          ),
        ),
      ],
    );
  }

  Widget _videoTile(_Vid v, {double width = 260}) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => VideoDetailScreen(title: v.title, mins: v.mins))),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PhotoPlaceholder(height: 150, width: width, color: const Color(0xFFC4BCB2)),
                const Positioned(
                  top: 10,
                  left: 10,
                  child: Icon(Icons.favorite_border, color: Colors.white),
                ),
                if (v.isNew)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                      ),
                      child: const Text('NEW',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                  ),
                if (v.tag != null)
                  Positioned.fill(
                    child: Center(
                      child: Text(v.tag!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(v.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.title),
            Text(v.mins, style: AppText.bodyMuted),
          ],
        ),
      ),
    );
  }

  Future<void> _openFilter() async {
    final found = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const WorkoutFilterScreen(), fullscreenDialog: true),
    );
    if (found == true && mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const _ResultsScreen()));
    }
  }
}

class _ViewAllScreen extends StatelessWidget {
  const _ViewAllScreen({required this.title, required this.vids});
  final String title;
  final List<_Vid> vids;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vids.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (_, i) {
          final v = vids[i];
          return GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => VideoDetailScreen(title: v.title, mins: v.mins))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    PhotoPlaceholder(height: 170, width: double.infinity, color: const Color(0xFFC4BCB2)),
                    const Positioned(top: 10, left: 10, child: Icon(Icons.favorite_border, color: Colors.white)),
                    if (v.tag != null)
                      Positioned.fill(child: Center(child: Text(v.tag!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(v.title, style: AppText.title),
                Text(v.mins, style: AppText.bodyMuted),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FavouritesScreen extends StatelessWidget {
  const _FavouritesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Your Favourites')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _FavTile('Full Body Pilates Sculpt 🔥', '35 Mins'),
          SizedBox(height: 18),
          _FavTile('Full Body Sunday Stretch 🧘', '13 Mins'),
          SizedBox(height: 18),
          _FavTile('Tempo Run', '37 Mins'),
        ],
      ),
    );
  }
}

class _FavTile extends StatelessWidget {
  const _FavTile(this.title, this.mins);
  final String title;
  final String mins;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            PhotoPlaceholder(height: 170, width: double.infinity, color: const Color(0xFFC4BCB2)),
            const Positioned(top: 10, left: 10, child: Icon(Icons.favorite, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Text(title, style: AppText.title),
        Text(mins, style: AppText.bodyMuted),
      ],
    );
  }
}

class _ResultsScreen extends StatelessWidget {
  const _ResultsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Results')),
      body: const Center(
        child: Text('No records found', style: AppText.h2),
      ),
    );
  }
}

/// Full-screen workout filter (Duration / Focus / Experience / Equipment / etc.)
class WorkoutFilterScreen extends StatefulWidget {
  const WorkoutFilterScreen({super.key});

  @override
  State<WorkoutFilterScreen> createState() => _WorkoutFilterScreenState();
}

class _WorkoutFilterScreenState extends State<WorkoutFilterScreen> {
  final Set<String> _sel = {'20 To 30 Minutes', 'Lower Body', 'Beginner', 'No Equipment', 'Cardio', 'Full Body Weighted', 'Emma Dillon'};

  static const _groups = {
    'Duration': ['10 To 20 Minutes', '20 To 30 Minutes', '30 To 40 Minutes', 'Longer Than 40 Minutes'],
    'Focus Area': ['Lower Body', 'Upper Body', 'Full Body'],
    'Experience Level': ['Beginner', 'Intermediate', 'Advanced', 'Pre & Post Natal Friendly'],
    'Equipment': ['No Equipment', 'Minimal Equipment'],
    'Training Style': ['Pilates', 'Cardio', 'Full Body Weighted', 'Core Work', 'Mobility And Stretch', 'Form & Technique', 'Yoga'],
    'Coach': ['Rachel Dillon', 'Emma Dillon', 'Lisa Nicolaisen', 'Olivia May', 'Annabelle Ronnfeldt'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        actions: [
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
        leading: const SizedBox(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          const Text('Select one or multiple options', style: AppText.body),
          const SizedBox(height: 16),
          for (final g in _groups.entries) ...[
            Text(g.key, style: AppText.h2.copyWith(fontSize: 22)),
            const SizedBox(height: 12),
            for (final opt in g.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() =>
                      _sel.contains(opt) ? _sel.remove(opt) : _sel.add(opt)),
                  child: Row(
                    children: [
                      _check(_sel.contains(opt)),
                      const SizedBox(width: 14),
                      Text(opt, style: AppText.body.copyWith(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 14),
          ],
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: SageButton(
          label: 'FIND WORKOUTS',
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
    );
  }

  Widget _check(bool value) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: value ? AppColors.sagePill : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
            color: value ? AppColors.sagePill : AppColors.textSecondary, width: 1.6),
      ),
      child: value ? const Icon(Icons.check, size: 18) : null,
    );
  }
}
