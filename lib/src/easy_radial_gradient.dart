import 'package:flutter/widgets.dart';

import 'radial_stop.dart';

/// A drop-in [RadialGradient] whose stops are described with [RadialStop]s
/// (position + color + opacity together) instead of the parallel `colors` /
/// `stops` lists that vanilla Flutter requires.
///
/// Because it extends [RadialGradient], you can use it anywhere a [Gradient]
/// is accepted — most commonly [BoxDecoration.gradient]:
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     shape: BoxShape.circle,
///     gradient: EasyRadialGradient(
///       colorStops: const [
///         RadialStop.start(color: Colors.orange),
///         RadialStop.end(color: Colors.orange, opacity: 0.0),
///       ],
///     ),
///   ),
/// );
/// ```
///
/// Stops are sorted by [RadialStop.position] automatically, so you don't have
/// to declare them in order.
class EasyRadialGradient extends RadialGradient {
  /// Creates a radial gradient from a list of [RadialStop]s.
  ///
  /// [colorStops] must contain at least two entries. The remaining parameters
  /// mirror [RadialGradient] one-to-one ([center], [radius], [tileMode],
  /// [focal], [focalRadius], [transform]).
  EasyRadialGradient({
    required List<RadialStop> colorStops,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    TileMode tileMode = TileMode.clamp,
    AlignmentGeometry? focal,
    double focalRadius = 0.0,
    GradientTransform? transform,
  }) : this._(
          _sortStops(colorStops),
          center: center,
          radius: radius,
          tileMode: tileMode,
          focal: focal,
          focalRadius: focalRadius,
          transform: transform,
        );

  /// A two-stop gradient that fades a single [color] from fully opaque at the
  /// center to fully transparent at the edge — the classic radial "glow".
  ///
  /// ```dart
  /// EasyRadialGradient.glow(Colors.cyan);
  /// ```
  factory EasyRadialGradient.glow(
    Color color, {
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    double innerOpacity = 1.0,
    GradientTransform? transform,
  }) {
    return EasyRadialGradient(
      center: center,
      radius: radius,
      transform: transform,
      colorStops: [
        RadialStop.start(color: color, opacity: innerOpacity),
        RadialStop.end(color: color, opacity: 0.0),
      ],
    );
  }

  EasyRadialGradient._(
    List<RadialStop> sortedStops, {
    required super.center,
    required super.radius,
    required super.tileMode,
    required super.focal,
    required super.focalRadius,
    required super.transform,
  })  : radialStops = sortedStops,
        super(
          colors: [for (final s in sortedStops) s.effectiveColor],
          stops: [for (final s in sortedStops) s.position],
        );

  /// The original, design-tool-style stops backing this gradient, sorted by
  /// position.
  final List<RadialStop> radialStops;

  static List<RadialStop> _sortStops(List<RadialStop> stops) {
    assert(
      stops.length >= 2,
      'EasyRadialGradient needs at least 2 stops (got ${stops.length}).',
    );
    return [...stops]..sort((a, b) => a.position.compareTo(b.position));
  }

  /// Returns a copy of this gradient with the given fields replaced.
  EasyRadialGradient copyWith({
    List<RadialStop>? colorStops,
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
  }) {
    return EasyRadialGradient(
      colorStops: colorStops ?? radialStops,
      center: center ?? this.center,
      radius: radius ?? this.radius,
      tileMode: tileMode ?? this.tileMode,
      focal: focal ?? this.focal,
      focalRadius: focalRadius ?? this.focalRadius,
      transform: transform ?? this.transform,
    );
  }
}
