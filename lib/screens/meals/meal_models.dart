import 'package:flutter/material.dart';

/// A single meal/recipe entry shown in the Meals list and detail screens.
class Meal {
  Meal(this.name, this.cal, this.p, this.f, this.c, this.color, {this.checked = false});
  final String name;
  final int cal, p, f, c;
  final Color color;
  bool checked;

  Meal copy() => Meal(name, cal, p, f, c, color, checked: checked);
}

/// Default Monday plan used by the Meals tab.
List<Meal> defaultPlan() => [
      Meal('Ham & Cheese Croissant (Post Workout)', 386, 21, 22, 25, const Color(0xFFCBA37A)),
      Meal('Mini Apple Pies', 185, 9, 4, 28, const Color(0xFFB7C49A)),
      Meal('Sweet Chilli Chicken Rice Noodles', 358, 40, 7, 34, const Color(0xFFC9554B)),
      Meal('Lamb Ragout', 356, 42, 11, 22, const Color(0xFF9A8B6F)),
      Meal('Ice Cream Cone', 291, 4, 14, 36, const Color(0xFFD8CBB4)),
    ];
