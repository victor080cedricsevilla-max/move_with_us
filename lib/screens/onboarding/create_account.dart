import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../paywall/membership_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, required this.email});
  final String email;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _first = TextEditingController(text: 'Julia');
  final _last = TextEditingController(text: 'Screens');
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  DateTime? _dob;
  bool _showPass = false;
  bool _showConfirm = false;
  bool _faceId = false;
  bool _metric = true;
  bool _marketing = true;
  bool _hasPhoto = false;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final choice = await showIOSSheet<String>(
      context,
      actions: const [
        (label: 'Take Photo', value: 'take', destructive: false),
        (label: 'Choose Photo', value: 'choose', destructive: false),
      ],
    );
    if (choice != null) setState(() => _hasPhoto = true);
  }

  Future<void> _pickDob() async {
    DateTime temp = _dob ?? DateTime(1999, 6, 17);
    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 320,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                CupertinoButton(
                  onPressed: () {
                    setState(() => _dob = temp);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: temp,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (d) => temp = d,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _dobText => _dob == null
      ? ''
      : '${_dob!.day} ${_months[_dob!.month - 1]} ${_dob!.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account', style: AppText.display),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  style: AppText.body,
                  children: [
                    const TextSpan(text: "Welcome! Let's create your account for "),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: AppColors.sage,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _hasPhoto
                        ? const PhotoPlaceholder(
                            radius: 60,
                            icon: Icons.person,
                            color: Color(0xFFB9A79A),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 56,
                                color: AppColors.sageDeep,
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: const Text(
                                  'Add Profile\nImage',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              CreamField(label: 'First Name', controller: _first),
              const SizedBox(height: 16),
              CreamField(label: 'Last Name', controller: _last),
              const SizedBox(height: 16),
              CreamField(
                label: 'Date of Birth',
                readOnly: true,
                onTap: _pickDob,
                controller: TextEditingController(text: _dobText),
              ),
              const SizedBox(height: 16),
              CreamField(
                hint: 'Password',
                controller: _pass,
                obscure: !_showPass,
                trailing: IconButton(
                  icon: Icon(
                    _showPass ? Icons.visibility : Icons.remove_red_eye_outlined,
                  ),
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
              ),
              const SizedBox(height: 16),
              CreamField(
                hint: 'Confirm Password',
                controller: _confirm,
                obscure: !_showConfirm,
                trailing: IconButton(
                  icon: Icon(
                    _showConfirm ? Icons.visibility : Icons.remove_red_eye_outlined,
                  ),
                  onPressed: () => setState(() => _showConfirm = !_showConfirm),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Use Face ID to login',
                    style: AppText.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _faceId,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.sage,
                    onChanged: (v) => setState(() => _faceId = v),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Select A Measurement System',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _unitButton('METRIC', 'Cm / Kg', _metric, () => setState(() => _metric = true))),
                  const SizedBox(width: 16),
                  Expanded(child: _unitButton('US UNITS', 'In / Lbs', !_metric, () => setState(() => _metric = false))),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _checkbox(_marketing, () => setState(() => _marketing = !_marketing)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Email me with important updates about this purchase + news and marketing information',
                      style: AppText.body,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SageButton(
                label: 'CREATE MY ACCOUNT',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MembershipScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _unitButton(String title, String sub, bool selected, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: selected ? AppColors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.black, width: 1.4),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: selected ? Colors.white : AppColors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(sub, style: AppText.bodyMuted),
      ],
    );
  }

  Widget _checkbox(bool value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: value ? AppColors.sage : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value ? AppColors.sage : AppColors.textSecondary,
            width: 1.6,
          ),
        ),
        child: value
            ? const Icon(Icons.check, size: 18, color: AppColors.black)
            : null,
      ),
    );
  }
}
