import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/onboarding/intro_carousel.dart';

void main() {
  runApp(const MoveWithUsApp());
}

class MoveWithUsApp extends StatelessWidget {
  const MoveWithUsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Move With Us',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const IntroCarousel(),
    );
  }
}
