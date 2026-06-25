import 'package:flutter/widgets.dart';

import 'radial_stop.dart';

/// A drop-in [RadialGradient] whose stops are described with [RadialStop]s
/// (position + color + opacity together) instead of the parallel `colors` /
/// `stops` lists that vanilla Flutter requires.
///
/// Because it extends [RadialGradient], you can use it anywhere a [Gradient]
/// is accepted — most commonly [BoxDecoration.gradient]. Stops are sorted by
/// [RadialStop.position] automatically, so you don't have to declare them in
/// order.
///
/// [RadialStop](위치 + 색 + 투명도)로 스톱을 기술하는, 그대로 갈아 끼울 수
/// 있는 [RadialGradient]입니다. 기본 Flutter가 요구하는 `colors` / `stops`
/// 병렬 리스트 대신 스톱 단위로 작성합니다. [RadialGradient]를 상속하므로
/// [Gradient]가 허용되는 어디서나(주로 [BoxDecoration.gradient]) 쓸 수 있고,
/// 스톱은 [RadialStop.position] 기준으로 자동 정렬되어 순서에 신경 쓰지 않아도
/// 됩니다.
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
class EasyRadialGradient extends RadialGradient {
  /// Creates a radial gradient from a list of [RadialStop]s.
  ///
  /// [colorStops] must contain at least two entries. The remaining parameters
  /// mirror [RadialGradient] one-to-one ([center], [radius], [tileMode],
  /// [focal], [focalRadius], [transform]).
  ///
  /// [RadialStop] 리스트로 라디얼 그라디언트를 생성합니다. [colorStops]에는
  /// 최소 두 개의 스톱이 필요합니다. 나머지 매개변수는 [RadialGradient]와
  /// 일대일로 대응합니다([center], [radius], [tileMode], [focal], [focalRadius],
  /// [transform]).
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
  /// 단일 [color]를 중심에서 완전 불투명, 가장자리에서 완전 투명으로
  /// 흐려지게 하는 두-스톱 그라디언트입니다 — 전형적인 라디얼 "글로우".
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
  }) : radialStops = sortedStops,
       super(
         colors: [for (final s in sortedStops) s.effectiveColor],
         stops: [for (final s in sortedStops) s.position],
       );

  /// The original, design-tool-style stops backing this gradient, sorted by
  /// position.
  ///
  /// 이 그라디언트의 바탕이 되는, 위치순으로 정렬된 디자인 툴 스타일 스톱
  /// 원본입니다.
  final List<RadialStop> radialStops;

  static List<RadialStop> _sortStops(List<RadialStop> stops) {
    assert(
      stops.length >= 2,
      'EasyRadialGradient needs at least 2 stops (got ${stops.length}).',
    );
    return [...stops]..sort((a, b) => a.position.compareTo(b.position));
  }

  /// Returns a copy of this gradient with the given fields replaced.
  ///
  /// 주어진 필드만 교체한 복사본을 반환합니다.
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
