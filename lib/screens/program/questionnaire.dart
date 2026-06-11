import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../shell/app_shell.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _step = 0; // 0=start date, 1=welcome, 2=activity, 3=nutrition, 4=dietary, 5=calorie

  String? _startDate;
  final String _weight = '57';
  int _height = 151;
  bool _heightSet = false;
  int _activity = 0; // ACTIVE
  int _nutrition = 0; // LOSE BODY FAT
  final Set<String> _diet = {'No Restrictions'};
  int _calorieTracking = 1; // No

  void _go(int step) => setState(() => _step = step);

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
    }
  }

  Future<void> _pickStartDate() async {
    DateTime temp = DateTime(2025, 10, 6);
    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                onPressed: () {
                  setState(() => _startDate =
                      'Oct ${temp.day}, ${temp.year}');
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: temp,
                onDateTimeChanged: (d) => temp = d,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickHeight() async {
    int temp = _height;
    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _height = temp;
                      _heightSet = true;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController:
                    FixedExtentScrollController(initialItem: _height - 120),
                onSelectedItemChanged: (i) => temp = 120 + i,
                children: [
                  for (int cm = 120; cm <= 210; cm++) Center(child: Text('$cm cm')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmMeasurements() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Measurement Confirmation', style: AppText.h2),
              const SizedBox(height: 12),
              const Text('Please double-check you have entered the correct values!',
                  textAlign: TextAlign.center, style: AppText.bodyMuted),
              const SizedBox(height: 16),
              _confirmRow('Weight', '$_weight kg'),
              const SizedBox(height: 6),
              _confirmRow('Height', '$_height cm'),
              const SizedBox(height: 20),
              SageButton(
                  label: 'ALL CORRECT!',
                  onPressed: () => Navigator.pop(ctx, true)),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('GO BACK',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true) _go(2);
  }

  Widget _confirmRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: AppText.title),
        const SizedBox(width: 14),
        Text(value, style: AppText.bodyMuted.copyWith(fontSize: 16)),
      ],
    );
  }

  Future<void> _finish() async {
    // notification permission prompt
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('"Move With Us" Would Like to Send You Notifications'),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
              'Notifications may include alerts, sounds, and icon badges. These can be configured in Settings.'),
        ),
        actions: [
          CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx), child: const Text("Don't Allow")),
          CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx), child: const Text('Allow')),
        ],
      ),
    );
    if (!mounted) return;
    // generating screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _GeneratingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_step == 0 ? Icons.close : Icons.arrow_back, size: 26),
          onPressed: _back,
        ),
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    switch (_step) {
      case 0:
        return _startDatePage();
      case 1:
        return _welcomePage();
      case 2:
        return _activityPage();
      case 3:
        return _nutritionPage();
      case 4:
        return _dietaryPage();
      default:
        return _caloriePage();
    }
  }

  Widget _progress(int filled) {
    return Row(
      children: List.generate(5, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == 4 ? 0 : 8),
            height: 8,
            decoration: BoxDecoration(
              color: i < filled ? AppColors.sageDeep : AppColors.sageLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _pageWrap({
    required String title,
    int? progress,
    required List<Widget> children,
    required String cta,
    bool ctaEnabled = true,
    required VoidCallback onCta,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.display),
          if (progress != null) ...[
            const SizedBox(height: 18),
            _progress(progress),
          ],
          const SizedBox(height: 22),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          SageButton(
            label: cta,
            color: ctaEnabled ? AppColors.sage : AppColors.sageLight,
            textColor: ctaEnabled ? AppColors.textPrimary : Colors.white,
            enabled: ctaEnabled,
            onPressed: onCta,
          ),
        ],
      ),
    );
  }

  Widget _startDatePage() {
    return _pageWrap(
      title: 'STRONG Program Level 1',
      cta: 'CONTINUE',
      ctaEnabled: _startDate != null,
      onCta: () => _go(1),
      children: [
        const Text('Please select your preferred start date to continue.',
            style: AppText.body),
        const SizedBox(height: 24),
        CreamField(
          label: 'Start Date',
          readOnly: true,
          onTap: _pickStartDate,
          controller: TextEditingController(text: _startDate ?? ''),
          trailing: _startDate == null
              ? null
              : GestureDetector(
                  onTap: () => setState(() => _startDate = null),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.black,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _welcomePage() {
    return _pageWrap(
      title: 'Welcome!',
      progress: 1,
      cta: 'CONTINUE',
      onCta: _confirmMeasurements,
      children: [
        const Text('Welcome to your STRONG Program Level 1, Julia!',
            style: AppText.body),
        const SizedBox(height: 12),
        const Text("Let's start by recording your height and weight!",
            style: AppText.body),
        const SizedBox(height: 24),
        CreamField(
          label: 'Weight',
          controller: TextEditingController(text: _weight),
          keyboardType: TextInputType.number,
          suffixText: 'kg',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        CreamField(
          label: 'Height',
          readOnly: true,
          onTap: _pickHeight,
          controller: TextEditingController(
              text: _heightSet ? '${_height.toDouble()}' : ''),
          suffixText: 'cm',
        ),
      ],
    );
  }

  Widget _activityPage() {
    const options = ['ACTIVE', 'MODERATE', 'SEDENTARY'];
    return _pageWrap(
      title: 'Physical Activity Level',
      progress: 2,
      cta: 'CONTINUE',
      onCta: () => _go(3),
      children: [
        const Text('How would you describe your current activity level?',
            style: AppText.body),
        const SizedBox(height: 20),
        for (int i = 0; i < options.length; i++) ...[
          _choicePill(options[i], _activity == i, () => setState(() => _activity = i)),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 10),
        _bullet('Physically demanding job such as: labourer, healthcare worker, personal trainer'),
        _bullet('Will be completing 5-6 workouts per week (300 minutes)'),
      ],
    );
  }

  Widget _nutritionPage() {
    const options = ['LOSE BODY FAT', 'GAIN MUSCLE', 'BOTH', 'MAINTENANCE'];
    return _pageWrap(
      title: 'Nutrition Goal',
      progress: 3,
      cta: 'CONTINUE',
      onCta: () => _go(4),
      children: [
        const Text('Read the descriptions carefully and pick an option that reflects your current priorities',
            style: AppText.body),
        const SizedBox(height: 20),
        for (int i = 0; i < options.length; i++) ...[
          _choicePill(options[i], _nutrition == i, () => setState(() => _nutrition = i)),
          SizedBox(height: i == 2 ? 24 : 14),
        ],
        const SizedBox(height: 4),
        _bullet('Your main goal is to significantly reduce your weight'),
        _bullet('You can sustain a higher calorie deficit without experiencing too much discomfort'),
        _bullet("It's best to follow this goal for a maximum of 12 weeks - after this time, we encourage you to switch to a different goal"),
      ],
    );
  }

  Widget _dietaryPage() {
    const items = [
      'No Restrictions', 'Gluten Free', 'Dairy Free', 'Seafood Free',
      'Red Meat Free', 'Nut Free', 'Pescetarian', 'Vegetarian', 'Vegan',
    ];
    return _pageWrap(
      title: 'Dietary Requirements',
      progress: 4,
      cta: 'CONTINUE',
      onCta: () => _go(5),
      children: [
        const Text('Please select your dietary requirements from the available combinations below:',
            style: AppText.body),
        const SizedBox(height: 18),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GestureDetector(
              onTap: () => setState(() {
                if (item == 'No Restrictions') {
                  _diet
                    ..clear()
                    ..add(item);
                } else {
                  _diet.remove('No Restrictions');
                  _diet.contains(item) ? _diet.remove(item) : _diet.add(item);
                  if (_diet.isEmpty) _diet.add('No Restrictions');
                }
              }),
              child: Row(
                children: [
                  _checkbox(_diet.contains(item)),
                  const SizedBox(width: 14),
                  Text(item,
                      style: AppText.body.copyWith(
                        fontSize: 19,
                        color: _diet.contains(item)
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _caloriePage() {
    return _pageWrap(
      title: 'Calorie Intake',
      progress: 5,
      cta: 'CONTINUE',
      onCta: _finish,
      children: [
        const Text('Have you been consistently tracking your calorie intake over the past 4-6 weeks?',
            style: AppText.body),
        const SizedBox(height: 20),
        _radio('Yes', 0),
        const SizedBox(height: 8),
        _radio('No', 1),
      ],
    );
  }

  Widget _radio(String label, int value) {
    final on = _calorieTracking == value;
    return GestureDetector(
      onTap: () => setState(() => _calorieTracking = value),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: on ? AppColors.sageDeep : AppColors.border, width: 2),
            ),
            child: on
                ? Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                          color: AppColors.sageDeep, shape: BoxShape.circle),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Text(label, style: AppText.body.copyWith(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _choicePill(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected ? AppColors.sage : Colors.transparent,
          borderRadius: BorderRadius.circular(29),
          border: Border.all(
              color: selected ? AppColors.sage : AppColors.black, width: 1.4),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7, right: 12),
            child: CircleAvatar(radius: 4, backgroundColor: AppColors.black),
          ),
          Expanded(child: Text(text, style: AppText.body)),
        ],
      ),
    );
  }

  Widget _checkbox(bool value) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: value ? AppColors.sagePill : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: value ? AppColors.sagePill : AppColors.textSecondary,
            width: 1.6),
      ),
      child: value ? const Icon(Icons.check, size: 20) : null,
    );
  }
}

class _GeneratingScreen extends StatefulWidget {
  const _GeneratingScreen();

  @override
  State<_GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<_GeneratingScreen> {
  @override
  void initState() {
    super.initState();
    // Brief "generating" splash then land in the app shell.
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AppShell(firstDay: true)),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 40),
              Text('Generating your\nMeal Guide',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.black)),
              SizedBox(height: 18),
              Text(
                'Your Meal Guide has not been tailored for pregnancy and may include foods that are not recommended during pregnancy. Please consult your healthcare provider before making dietary changes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.4, color: AppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
