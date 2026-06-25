/// Design-tool-style radial gradients for Flutter.
///
/// Instead of vanilla Flutter's parallel `colors` / `stops` lists, describe
/// each stop as a single [RadialStop] (position + color + opacity) — the same
/// mental model as Figma, Sketch and Adobe XD. Comes with an optional Gaussian
/// blur and frosted-glass backdrop blur via [RadialGradientBox].
library;

export 'src/easy_radial_gradient.dart';
export 'src/radial_gradient_box.dart';
export 'src/radial_stop.dart';
