/// Catalog of bundled photo assets that live in `assets/images/`.
///
/// The source files keep their original (Instagram-style) names, so they are
/// referenced through these named constants to keep call sites readable and to
/// give a single place to swap artwork later.
class AppImages {
  AppImages._();

  static const String _dir = 'assets/images';

  static const String gymLavender =
      '$_dir/706297310_18590319403021730_7538272556023055594_n.jpg';
  static const String yogaStretch =
      '$_dir/714323600_18594329164021730_5124711115023277940_n.jpg';
  static const String mirrorPink =
      '$_dir/542040468_18525518518021730_731461651854607850_n.jpg';
  static const String gymBlue =
      '$_dir/670403307_18580315294021730_3109786534118662577_n.jpg';
  static const String mirrorGrey =
      '$_dir/669639819_18113161054619941_8243821912665341424_n.jpg';
  static const String lockerFront =
      '$_dir/670446708_18064909205353627_1997482184185426723_n.jpg';
  static const String lockerBack =
      '$_dir/670549961_17988874664963446_5861975531747457963_n.jpg';

  /// All photos, ordered for rotating through lists and grids.
  static const List<String> gallery = [
    gymLavender,
    lockerBack,
    yogaStretch,
    gymBlue,
    mirrorGrey,
    lockerFront,
    mirrorPink,
  ];

  /// Picks a photo for [index], wrapping around the gallery so any length list
  /// gets a stable image per row.
  static String at(int index) => gallery[index % gallery.length];
}
