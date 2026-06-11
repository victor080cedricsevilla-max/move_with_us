import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Big sage pill CTA (CONTINUE, CREATE MY ACCOUNT, START WORKOUT ...).
class SageButton extends StatelessWidget {
  const SageButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = AppColors.sage,
    this.textColor = AppColors.textPrimary,
    this.height = 60,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double height;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(height / 2),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: Text(
                label,
                style: AppText.button.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined (black border) pill button — secondary actions, START PROGRAM, etc.
class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 58,
    this.filledBlack = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool filledBlack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        color: filledBlack ? AppColors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              border: Border.all(color: AppColors.black, width: 1.4),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppText.button.copyWith(
                color: filledBlack ? Colors.white : AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cream rounded "pill" input field used across forms.
class CreamField extends StatelessWidget {
  const CreamField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscure = false,
    this.trailing,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.suffixText,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? trailing;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null)
                  Text(label!, style: AppText.label.copyWith(fontSize: 13)),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  readOnly: readOnly,
                  onTap: onTap,
                  keyboardType: keyboardType,
                  style: AppText.body.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: AppText.body.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 18,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          if (suffixText != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(suffixText!, style: AppText.body),
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Page-dots used on the onboarding / tutorial carousels.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.textSecondary : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// A circular macro progress ring with `value / goal` text in the centre.
class MacroRing extends StatelessWidget {
  const MacroRing({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    this.size = 70,
    this.color = AppColors.sageTrack,
  });

  final String label;
  final int value;
  final int goal;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = goal == 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(pct, color),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$value',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  Container(
                    width: size * 0.42,
                    height: 1,
                    color: AppColors.textPrimary,
                  ),
                  Text('$goal',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppText.bodyMuted.copyWith(fontSize: 14)),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.pct, this.color);
  final double pct;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.09;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.width - stroke) / 2;
    final track = Paint()
      ..color = AppColors.ringTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final prog = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * pct,
      false,
      prog,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.pct != pct || old.color != color;
}

/// The four Protein/Fats/Carbs/Fibre rings used on Home + Meals.
class MacroRow extends StatelessWidget {
  const MacroRow({
    super.key,
    this.protein = const [86, 120],
    this.fats = const [35, 69],
    this.carbs = const [143, 237],
    this.fibre = const [16, 25],
    this.size = 70,
  });

  final List<int> protein, fats, carbs, fibre;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MacroRing(label: 'Protein', value: protein[0], goal: protein[1], size: size),
        MacroRing(label: 'Fats', value: fats[0], goal: fats[1], size: size),
        MacroRing(label: 'Carbs', value: carbs[0], goal: carbs[1], size: size),
        MacroRing(label: 'Fibre', value: fibre[0], goal: fibre[1], size: size),
      ],
    );
  }
}

/// Calorie progress bar (Calorie Goal  1233 of 1850).
class CalorieBar extends StatelessWidget {
  const CalorieBar({super.key, required this.value, required this.goal});
  final int value;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final pct = goal == 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Calorie Goal', style: AppText.title),
            Text('$value of $goal', style: AppText.title),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 9,
            backgroundColor: AppColors.ringTrack,
            valueColor: const AlwaysStoppedAnimation(AppColors.sageTrack),
          ),
        ),
      ],
    );
  }
}

/// Soft grey placeholder used wherever a photo/video would appear.
class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    super.key,
    this.height,
    this.width,
    this.radius = 18,
    this.label,
    this.icon = Icons.image_outlined,
    this.color = const Color(0xFFD9D7CF),
    this.child,
  });

  final double? height;
  final double? width;
  final double radius;
  final String? label;
  final IconData icon;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.75)],
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: child ??
          (label != null
              ? Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                )
              : Icon(icon, color: Colors.white70, size: 34)),
    );
  }
}

/// Two-or-more option segmented control (METRIC/US, My Stats/My Entries, ...).
class SegmentedPill extends StatelessWidget {
  const SegmentedPill({
    super.key,
    required this.options,
    required this.index,
    required this.onChanged,
    this.height = 52,
  });

  final List<String> options;
  final int index;
  final ValueChanged<int> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.sagePill,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: selected ? AppColors.cream : Colors.transparent,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Circular icon button (close X, back chevron) like the iOS sheets use.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.bg = AppColors.field,
    this.fg = AppColors.textPrimary,
    this.size = 38,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: size * 0.5, color: fg),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// iOS-style helpers
/// ------------------------------------------------------------------

/// Two-button iOS alert (Cancel / Confirm). Returns true when confirmed.
Future<bool?> showIOSAlert(
  BuildContext context, {
  required String title,
  String? message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool destructive = false,
}) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: message == null ? null : Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          isDestructiveAction: destructive,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

/// Single-button "Okay" notice dialog (Macros Updated, You're all set, ...).
Future<void> showIOSNotice(
  BuildContext context, {
  required String title,
  String? message,
  String okText = 'OK',
}) {
  return showCupertinoDialog(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: message == null ? null : Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(ctx),
          child: Text(okText),
        ),
      ],
    ),
  );
}

/// iOS action sheet (Take Photo / Choose Photo / Cancel etc.).
Future<T?> showIOSSheet<T>(
  BuildContext context, {
  String? title,
  required List<({String label, T value, bool destructive})> actions,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: title == null ? null : Text(title),
      actions: [
        for (final a in actions)
          CupertinoActionSheetAction(
            isDestructiveAction: a.destructive,
            onPressed: () => Navigator.pop(ctx, a.value),
            child: Text(a.label),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Cancel'),
      ),
    ),
  );
}

/// A re-usable green "ghost" achievement/progress card image header.
class GradientBanner extends StatelessWidget {
  const GradientBanner({
    super.key,
    required this.child,
    this.height = 200,
    this.colors = const [Color(0xFFBFC9A8), Color(0xFF9FB07F)],
    this.radius = 22,
  });

  final Widget child;
  final double height;
  final List<Color> colors;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

/// Small rounded chip used for workout tags / meal categories.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.onTap,
    this.onClose,
    this.leading,
    this.selected = false,
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final Widget? leading;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.sagePill : AppColors.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            if (onClose != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
