import 'dart:async';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'share_selfie.dart';

class _Move {
  const _Move(this.name, this.reps);
  final String name;
  final String reps;
}

enum _Phase { countdown, exercise, rest }

class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({super.key, required this.title});
  final String title;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  static const _moves = [
    _Move('Banded Lying Lateral Raises', '10 reps'),
    _Move('Banded Dumbbell Glute Bridges', '12 reps'),
    _Move('Banded Clams', '10 reps'),
  ];

  _Phase _phase = _Phase.countdown;
  int _index = 0;
  int _set = 1;
  int _seconds = 9;
  bool _paused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          _advance();
        }
      });
    });
  }

  void _advance() {
    switch (_phase) {
      case _Phase.countdown:
        _phase = _Phase.exercise;
        _seconds = 20;
        break;
      case _Phase.exercise:
        _phase = _Phase.rest;
        _seconds = _index == _moves.length - 1 ? 20 : 5;
        break;
      case _Phase.rest:
        if (_index < _moves.length - 1) {
          _index++;
        } else if (_set < 3) {
          _set++;
          _index = 0;
        } else {
          _finish();
          return;
        }
        _phase = _Phase.exercise;
        _seconds = 20;
        break;
    }
  }

  void _finish() {
    _timer?.cancel();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const ShareSelfieScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _phase == _Phase.exercise ? _exerciseView() : _timerView(),
      ),
    );
  }

  Widget _timerView() {
    final isRest = _phase == _Phase.rest;
    final next = _index < _moves.length - 1 ? _moves[_index + 1] : _moves[0];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: _seconds / (isRest ? 20 : 9),
                    strokeWidth: 6,
                    backgroundColor: AppColors.sageLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.sageTrack),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isRest ? 'REST' : 'START',
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                    Text('$_seconds',
                        style: const TextStyle(
                            fontSize: 52, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const PhotoPlaceholder(height: 140, color: Color(0xFFE9E7DF), icon: Icons.directions_run),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Text('Next:  ', style: TextStyle(fontWeight: FontWeight.w700)),
                Expanded(child: Text(next.name, style: AppText.body)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SageButton(
            label: isRest ? 'START NEXT  ▶' : 'START WORKOUT',
            onPressed: () => setState(_advance),
          ),
        ],
      ),
    );
  }

  Widget _exerciseView() {
    final m = _moves[_index];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(widget.title, style: AppText.title),
          Text('Set $_set/3', style: AppText.bodyMuted),
          const SizedBox(height: 20),
          const PhotoPlaceholder(height: 240, color: Color(0xFFE9E7DF), icon: Icons.directions_run),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name, style: AppText.h2),
                    const SizedBox(height: 6),
                    const Text('Tempo: 2010', style: AppText.bodyMuted),
                  ],
                ),
              ),
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.sageTrack, width: 5),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(m.reps.split(' ').first,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
                    const Text('reps', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _playerBtn(Icons.skip_previous, () {
                if (_index > 0) setState(() => _index--);
              }),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _paused = !_paused),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Icon(_paused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white, size: 34),
                ),
              ),
              const SizedBox(width: 8),
              _playerBtn(Icons.skip_next, () => setState(_advance)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Text('Next:  ', style: TextStyle(fontWeight: FontWeight.w700)),
                Expanded(child: Text(m.name, style: AppText.body)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
