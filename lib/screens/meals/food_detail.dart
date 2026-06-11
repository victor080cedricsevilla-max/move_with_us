import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key, required this.name, required this.calories});
  final String name;
  final int calories;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  double _quantity = 100;
  bool _fav = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: Icon(_fav ? Icons.favorite : Icons.favorite_border,
                color: _fav ? Colors.red : AppColors.black),
            onPressed: () => setState(() => _fav = !_fav),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          Text(widget.name, style: AppText.h1),
          const SizedBox(height: 6),
          Text('${widget.calories} Calories', style: AppText.body.copyWith(fontSize: 18)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CreamField(
                  label: 'Serving',
                  controller: TextEditingController(text: '1'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: CreamField(
                  label: 'Quantity',
                  controller: TextEditingController(text: _quantity.toInt().toString()),
                  suffixText: 'Grams',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.sageTrack,
              inactiveTrackColor: AppColors.ringTrack,
              thumbColor: Colors.white,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: _quantity,
              min: 0,
              max: 500,
              onChanged: (v) => setState(() => _quantity = v),
            ),
          ),
          const SizedBox(height: 12),
          MacroRow(
            protein: [(_quantity / 50).round(), 119],
            fats: [(_quantity / 250).round(), 54],
            carbs: [(_quantity / 16).round(), 113],
            fibre: [0, 15],
            size: 66,
          ),
          const SizedBox(height: 24),
          SageButton(
            label: 'ADD TO MEAL GUIDE',
            onPressed: () async {
              final navigator = Navigator.of(context);
              final ok = await showIOSAlert(context,
                  title: 'Check Your Macros!',
                  message: 'We recommend closely hitting your daily targets for best results. If you\'re confident with these changes, press "Confirm".',
                  confirmText: 'Confirm');
              if (ok == true) navigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
