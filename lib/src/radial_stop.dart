import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

/// A single radial gradient stop, expressed the way design tools (Figma,
/// Sketch, Adobe XD) do: one entry that bundles a **position**, a **color**
/// and an **opacity** together.
///
/// This is the core ergonomic win over Flutter's [RadialGradient], where you
/// pass two parallel lists (`colors` + `stops`) and have to keep them aligned
/// by index. Here every stop is self-describing.
///
/// 디자인 툴(Figma, Sketch, Adobe XD)과 동일한 방식의 단일 라디얼 그라디언트
/// 스톱입니다. **위치(position)**, **색(color)**, **투명도(opacity)**를 한
/// 항목에 함께 묶습니다. Flutter의 [RadialGradient]는 `colors`와 `stops` 두
/// 리스트를 인덱스로 맞춰야 하지만, 여기서는 각 스톱이 스스로를 설명합니다.
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
  ///
  /// 그라디언트 스톱을 생성합니다. [position]은 `0.0..1.0` 범위여야 합니다
  /// (0 = 중심, 1 = 가장자리). [opacity]는 [color] 자체 알파 위에 추가로
  /// 곱해지는 배수입니다. 예를 들어 `Colors.black.withValues(alpha: 0.5)`에
  /// `opacity: 0.5`를 주면 최종 알파는 `0.25`가 되며, 디자인 툴에서 투명도를
  /// 겹치는 것과 동일하게 동작합니다.
  const RadialStop({
    required this.position,
    required this.color,
    this.opacity = 1.0,
  }) : assert(
         position >= 0.0 && position <= 1.0,
         'RadialStop.position must be between 0.0 and 1.0 (got $position).',
       ),
       assert(
         opacity >= 0.0 && opacity <= 1.0,
         'RadialStop.opacity must be between 0.0 and 1.0 (got $opacity).',
       );

  /// A stop pinned to the gradient **center** (`position: 0.0`).
  ///
  /// 그라디언트 **중심**(`position: 0.0`)에 고정된 스톱입니다.
  ///
  /// ```dart
  /// RadialStop.start(color: Colors.orange);
  /// ```
  const RadialStop.start({required Color color, double opacity = 1.0})
    : this(position: 0.0, color: color, opacity: opacity);

  /// A stop pinned to the gradient **edge** (`position: 1.0`).
  ///
  /// 그라디언트 **가장자리**(`position: 1.0`)에 고정된 스톱입니다.
  ///
  /// ```dart
  /// RadialStop.end(color: Colors.orange, opacity: 0.0);
  /// ```
  const RadialStop.end({required Color color, double opacity = 1.0})
    : this(position: 1.0, color: color, opacity: opacity);

  /// A stop at an arbitrary [position] (`0.0..1.0`), reading naturally inline.
  ///
  /// 임의의 [position](`0.0..1.0`)에 놓이는 스톱으로, 인라인에서 자연스럽게
  /// 읽힙니다.
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
  /// Useful for the common "fade to nothing at the edge" case.
  ///
  /// [color]를 [position]에서 완전히 투명하게 만드는 편의 생성자입니다.
  /// "가장자리에서 서서히 사라지는" 흔한 경우에 유용합니다.
  ///
  /// ```dart
  /// RadialStop.transparent(position: 1, color: Colors.orange);
  /// ```
  const RadialStop.transparent({required double position, required Color color})
    : this(position: position, color: color, opacity: 0.0);

  /// Where this stop sits along the radius, from `0.0` (center) to `1.0`
  /// (the edge defined by the gradient's radius).
  ///
  /// 반지름 상에서 이 스톱의 위치로, `0.0`(중심)부터 `1.0`(그라디언트 radius로
  /// 정의된 가장자리)까지입니다.
  final double position;

  /// The stop color. Its own alpha channel is respected and further scaled by
  /// [opacity].
  ///
  /// 스톱 색상입니다. 색 자체의 알파 채널이 유지되며 [opacity]로 추가
  /// 조정됩니다.
  final Color color;

  /// An additional opacity multiplier in `0.0..1.0`, applied on top of
  /// [color]'s alpha. Defaults to `1.0` (no change).
  ///
  /// [color] 알파 위에 곱해지는 `0.0..1.0`의 추가 투명도 배수입니다. 기본값은
  /// `1.0`(변화 없음)입니다.
  final double opacity;

  /// The resolved color that is actually handed to the underlying gradient:
  /// [color] with its alpha multiplied by [opacity].
  ///
  /// 실제로 내부 그라디언트에 전달되는 최종 색상으로, [color]의 알파에
  /// [opacity]를 곱한 값입니다.
  Color get effectiveColor =>
      opacity == 1.0 ? color : color.withValues(alpha: color.a * opacity);

  /// Returns a copy of this stop with the given fields replaced.
  ///
  /// 주어진 필드만 교체한 복사본을 반환합니다.
  RadialStop copyWith({double? position, Color? color, double? opacity}) {
    return RadialStop(
      position: position ?? this.position,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }

  /// Linearly interpolates between two stops.
  /// Returns `null` only if both [a] and [b] are `null`.
  ///
  /// 두 스톱 사이를 선형 보간합니다. [a]와 [b]가 모두 `null`일 때만 `null`을
  /// 반환합니다.
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
