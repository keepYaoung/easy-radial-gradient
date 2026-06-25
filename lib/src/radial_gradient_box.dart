import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'easy_radial_gradient.dart';
import 'radial_stop.dart';

/// A box painted with an [EasyRadialGradient], with optional Gaussian blur on
/// the gradient itself and an optional backdrop (frosted-glass) blur of
/// whatever is rendered behind it.
///
/// [EasyRadialGradient]로 칠해지는 박스로, 그라디언트 자체에 거는 가우시안
/// 블러와 박스 뒤 내용에 거는 백드롭(프로스티드 글래스) 블러를 선택적으로
/// 지원합니다.
///
/// ```dart
/// RadialGradientBox(
///   width: 200,
///   height: 200,
///   colorStops: const [
///     RadialStop.start(color: Colors.cyan),
///     RadialStop.end(color: Colors.cyan, opacity: 0.0),
///   ],
///   blur: 16,          // soften the glow itself
///   backdropBlur: 8,   // frost the content behind the box
///   child: Text('Hi'),
/// );
/// ```
///
/// ## Layering / 레이어 구성
///
/// * The gradient is painted into a shape ([shape] = circle or rounded
///   rectangle).
/// * [blur] applies a Gaussian blur to the **gradient layer only**. Any [child]
///   is drawn sharply on top, so you get a blurred glow behind crisp content.
/// * [backdropBlur] blurs everything painted *behind* this widget, clipped to
///   [shape], producing a frosted-glass effect that shows through the
///   transparent parts of the gradient.
///
/// * 그라디언트는 [shape](원 또는 둥근 사각형)으로 칠해집니다.
/// * [blur]는 **그라디언트 레이어에만** 가우시안 블러를 적용합니다. [child]는
///   그 위에 선명하게 그려져, 또렷한 콘텐츠 뒤에 흐릿한 글로우를 얻습니다.
/// * [backdropBlur]는 이 위젯 *뒤*에 그려진 모든 것을 [shape]로 클리핑해
///   흐리게 만들어, 그라디언트의 투명한 부분으로 비치는 프로스티드 글래스
///   효과를 냅니다.
class RadialGradientBox extends StatelessWidget {
  /// Creates a radial-gradient box.
  ///
  /// [colorStops] must contain at least two [RadialStop]s.
  ///
  /// 라디얼 그라디언트 박스를 생성합니다. [colorStops]에는 최소 두 개의
  /// [RadialStop]이 필요합니다.
  const RadialGradientBox({
    super.key,
    required this.colorStops,
    this.center = Alignment.center,
    this.radius = 0.5,
    this.tileMode = TileMode.clamp,
    this.focal,
    this.focalRadius = 0.0,
    this.transform,
    this.width,
    this.height,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.blur = 0.0,
    this.backdropBlur = 0.0,
    this.clipBehavior = Clip.antiAlias,
    this.alignment = Alignment.center,
    this.padding,
    this.child,
  }) : assert(blur >= 0.0, 'blur must be >= 0.'),
       assert(backdropBlur >= 0.0, 'backdropBlur must be >= 0.'),
       assert(
         shape != BoxShape.circle || borderRadius == null,
         'borderRadius is only valid when shape is BoxShape.rectangle.',
       );

  /// Design-tool-style gradient stops (position + color + opacity).
  ///
  /// 디자인 툴 스타일 그라디언트 스톱(위치 + 색 + 투명도)입니다.
  final List<RadialStop> colorStops;

  /// Center of the gradient. See [RadialGradient.center].
  ///
  /// 그라디언트의 중심입니다. [RadialGradient.center] 참고.
  final AlignmentGeometry center;

  /// Radius of the gradient as a fraction of the shortest box side. See
  /// [RadialGradient.radius].
  ///
  /// 박스의 짧은 변에 대한 비율로 표현한 그라디언트 반지름입니다.
  /// [RadialGradient.radius] 참고.
  final double radius;

  /// How the gradient tiles outside its [radius]. See [RadialGradient.tileMode].
  ///
  /// [radius] 바깥에서 그라디언트가 어떻게 반복되는지입니다.
  /// [RadialGradient.tileMode] 참고.
  final TileMode tileMode;

  /// Optional focal point for a two-point conical gradient. See
  /// [RadialGradient.focal].
  ///
  /// 두-점 원뿔형 그라디언트를 위한 선택적 초점입니다. [RadialGradient.focal]
  /// 참고.
  final AlignmentGeometry? focal;

  /// Radius of the [focal] point. See [RadialGradient.focalRadius].
  ///
  /// [focal] 점의 반지름입니다. [RadialGradient.focalRadius] 참고.
  final double focalRadius;

  /// Optional gradient transform. See [RadialGradient.transform].
  ///
  /// 선택적 그라디언트 변환입니다. [RadialGradient.transform] 참고.
  final GradientTransform? transform;

  /// Fixed width of the box. If null, the box expands to its constraints (or to
  /// [child] when one is provided).
  ///
  /// 박스의 고정 너비입니다. null이면 제약 조건(또는 [child]가 있으면 그
  /// 크기)에 맞춰 늘어납니다.
  final double? width;

  /// Fixed height of the box. If null, the box expands to its constraints (or
  /// to [child] when one is provided).
  ///
  /// 박스의 고정 높이입니다. null이면 제약 조건(또는 [child]가 있으면 그
  /// 크기)에 맞춰 늘어납니다.
  final double? height;

  /// Shape used to clip the gradient (and the backdrop blur). Defaults to
  /// [BoxShape.circle].
  ///
  /// 그라디언트(및 백드롭 블러)를 클리핑하는 도형입니다. 기본값은
  /// [BoxShape.circle]입니다.
  final BoxShape shape;

  /// Corner radius used when [shape] is [BoxShape.rectangle]. Ignored for
  /// circles.
  ///
  /// [shape]가 [BoxShape.rectangle]일 때 사용하는 모서리 반경입니다. 원에서는
  /// 무시됩니다.
  final BorderRadiusGeometry? borderRadius;

  /// Sigma of the Gaussian blur applied to the gradient layer. `0` disables it.
  ///
  /// 그라디언트 레이어에 적용하는 가우시안 블러의 시그마입니다. `0`이면
  /// 비활성화됩니다.
  final double blur;

  /// Sigma of the backdrop blur applied to content behind the box. `0` disables
  /// it.
  ///
  /// 박스 뒤 내용에 적용하는 백드롭 블러의 시그마입니다. `0`이면
  /// 비활성화됩니다.
  final double backdropBlur;

  /// Clip behavior for the shape and backdrop clips.
  ///
  /// 도형 및 백드롭 클리핑의 클립 동작입니다.
  final Clip clipBehavior;

  /// Alignment of [child] within the box.
  ///
  /// 박스 안에서 [child]의 정렬입니다.
  final AlignmentGeometry alignment;

  /// Optional padding around [child].
  ///
  /// [child] 주위의 선택적 여백입니다.
  final EdgeInsetsGeometry? padding;

  /// Optional content drawn sharply on top of the (possibly blurred) gradient.
  ///
  /// (블러 처리됐을 수 있는) 그라디언트 위에 선명하게 그려지는 선택적
  /// 콘텐츠입니다.
  final Widget? child;

  /// The [EasyRadialGradient] this widget paints. Exposed so callers can reuse
  /// the exact same gradient elsewhere.
  ///
  /// 이 위젯이 칠하는 [EasyRadialGradient]입니다. 호출자가 동일한 그라디언트를
  /// 다른 곳에서 재사용할 수 있도록 노출합니다.
  EasyRadialGradient get gradient => EasyRadialGradient(
    colorStops: colorStops,
    center: center,
    radius: radius,
    tileMode: tileMode,
    focal: focal,
    focalRadius: focalRadius,
    transform: transform,
  );

  ShapeBorder get _shapeBorder => switch (shape) {
    BoxShape.circle => const CircleBorder(),
    BoxShape.rectangle => RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.zero,
    ),
  };

  @override
  Widget build(BuildContext context) {
    // The gradient fill, clipped to the requested shape.
    Widget gradientLayer = DecoratedBox(
      decoration: ShapeDecoration(shape: _shapeBorder, gradient: gradient),
    );

    // Gaussian-blur the gradient layer only (child stays crisp).
    if (blur > 0) {
      gradientLayer = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
          tileMode: TileMode.decal,
        ),
        child: gradientLayer,
      );
    }

    // Compose the gradient with an optional sharp child on top.
    Widget content;
    if (child != null) {
      content = Stack(
        alignment: alignment,
        children: [
          Positioned.fill(child: gradientLayer),
          Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ],
      );
    } else {
      content = gradientLayer;
    }

    content = SizedBox(width: width, height: height, child: content);

    // Frosted-glass backdrop blur, clipped to the same shape so it doesn't
    // bleed past the box.
    if (backdropBlur > 0) {
      content = ClipPath(
        clipper: ShapeBorderClipper(shape: _shapeBorder),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: backdropBlur,
            sigmaY: backdropBlur,
          ),
          child: content,
        ),
      );
    }

    return content;
  }
}
