import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

/// A single radial gradient stop, expressed the way design tools (Figma,
/// Sketch, Adobe XD) do: one entry that bundles a **position**, a **color**
/// and an **opacity** together.
///
/// This is the core ergonomic win over Flutter's [RadialGradient], where you
/// pass two parallel lists (`colors` + `stops`) and have to keep them aligned
/// by index. Here every stop is self-describing:
///
/// ```dart
/// RadialStop(position: 0.0, color: Colors.orange)            // opaque center
/// RadialStop(position: 1.0, color: Colors.orange, opacity: 0) // fades out
/// ```
@immutable
class RadialStop {
  /// Creates a gradient stop.
  ///
  /// [position] must be within `0.0..1.0` (0 = gradient center, 1 = edge).
  /// [opacity] is an extra multiplier applied on top of [color]'s own alpha,
  /// so `Colors.black.withValues(alpha: 0.5)` with `opacity: 0.5` yields an
  /// effective alpha of `0.25` — exactly like stacking opacity in a design
  /// tool.
  const RadialStop({
    required this.position,
    required this.color,
    this.opacity = 1.0,
  })  : assert(
          position >= 0.0 && position <= 1.0,
          'RadialStop.position must be between 0.0 and 1.0 (got $position).',
        ),
        assert(
          opacity >= 0.0 && opacity <= 1.0,
          'RadialStop.opacity must be between 0.0 and 1.0 (got $opacity).',
        );

  /// A stop pinned to the gradient **center** (`position: 0.0`).
  ///
  /// ```dart
  /// RadialStop.start(color: Colors.orange);
  /// ```
  const RadialStop.start({
    required Color color,
    double opacity = 1.0,
  }) : this(position: 0.0, color: color, opacity: opacity);

  /// A stop pinned to the gradient **edge** (`position: 1.0`).
  ///
  /// ```dart
  /// RadialStop.end(color: Colors.orange, opacity: 0.0);
  /// ```
  const RadialStop.end({
    required Color color,
    double opacity = 1.0,
  }) : this(position: 1.0, color: color, opacity: opacity);

  /// A stop at an arbitrary [position] (`0.0..1.0`), reading naturally inline:
  ///
  /// ```dart
  /// RadialStop.at(0.5, color: Colors.orange, opacity: 0.4);
  /// ```
  const RadialStop.at(
    double position, {
    required Color color,
    double opacity = 1.0,
  }) : this(position: position, color: color, opacity: opacity);

  /// Convenience for a fully transparent stop at [position] of [color].
  ///
  /// Useful for the common "fade to nothing at the edge" case:
  /// `RadialStop.transparent(position: 1, color: Colors.orange)`.
  const RadialStop.transparent({
    required double position,
    required Color color,
  }) : this(position: position, color: color, opacity: 0.0);

  /// Where this stop sits along the radius, from `0.0` (center) to `1.0`
  /// (the edge defined by the gradient's radius).
  final double position;

  /// The stop color. Its own alpha channel is respected and further scaled by
  /// [opacity].
  final Color color;

  /// An additional opacity multiplier in `0.0..1.0`, applied on top of
  /// [color]'s alpha. Defaults to `1.0` (no change).
  final double opacity;

  /// The resolved color that is actually handed to the underlying gradient:
  /// [color] with its alpha multiplied by [opacity].
  Color get effectiveColor =>
      opacity == 1.0 ? color : color.withValues(alpha: color.a * opacity);

  /// Returns a copy of this stop with the given fields replaced.
  RadialStop copyWith({double? position, Color? color, double? opacity}) {
    return RadialStop(
      position: position ?? this.position,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }

  /// Linearly interpolates between two stops.
  ///
  /// Returns `null` only if both [a] and [b] are `null`.
  static RadialStop? lerp(RadialStop? a, RadialStop? b, double t) {
    if (identical(a, b)) return a;
    if (a == null) return b!.copyWith(opacity: b.opacity * t);
    if (b == null) return a.copyWith(opacity: a.opacity * (1.0 - t));
    return RadialStop(
      position: a.position + (b.position - a.position) * t,
      color: Color.lerp(a.color, b.color, t)!,
      opacity: a.opacity + (b.opacity - a.opacity) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RadialStop &&
      other.position == position &&
      other.color == color &&
      other.opacity == opacity;

  @override
  int get hashCode => Object.hash(position, color, opacity);

  @override
  String toString() =>
      'RadialStop(position: $position, color: $color, opacity: $opacity)';
}
