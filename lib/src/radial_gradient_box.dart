import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'easy_radial_gradient.dart';
import 'radial_stop.dart';

/// A box painted with an [EasyRadialGradient], with optional Gaussian blur on
/// the gradient itself and an optional backdrop (frosted-glass) blur of
/// whatever is rendered behind it.
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
/// ## Layering
///
/// * The gradient is painted into a shape ([shape] = circle or rounded
///   rectangle).
/// * [blur] applies a Gaussian blur to the **gradient layer only**. Any [child]
///   is drawn sharply on top, so you get a blurred glow behind crisp content.
/// * [backdropBlur] blurs everything painted *behind* this widget, clipped to
///   [shape], producing a frosted-glass effect that shows through the
///   transparent parts of the gradient.
class RadialGradientBox extends StatelessWidget {
  /// Creates a radial-gradient box.
  ///
  /// [colorStops] must contain at least two [RadialStop]s.
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
  })  : assert(blur >= 0.0, 'blur must be >= 0.'),
        assert(backdropBlur >= 0.0, 'backdropBlur must be >= 0.'),
        assert(
          shape != BoxShape.circle || borderRadius == null,
          'borderRadius is only valid when shape is BoxShape.rectangle.',
        );

  /// Design-tool-style gradient stops (position + color + opacity).
  final List<RadialStop> colorStops;

  /// Center of the gradient. See [RadialGradient.center].
  final AlignmentGeometry center;

  /// Radius of the gradient as a fraction of the shortest box side. See
  /// [RadialGradient.radius].
  final double radius;

  /// How the gradient tiles outside its [radius]. See [RadialGradient.tileMode].
  final TileMode tileMode;

  /// Optional focal point for a two-point conical gradient. See
  /// [RadialGradient.focal].
  final AlignmentGeometry? focal;

  /// Radius of the [focal] point. See [RadialGradient.focalRadius].
  final double focalRadius;

  /// Optional gradient transform. See [RadialGradient.transform].
  final GradientTransform? transform;

  /// Fixed width of the box. If null, the box expands to its constraints (or to
  /// [child] when one is provided).
  final double? width;

  /// Fixed height of the box. If null, the box expands to its constraints (or
  /// to [child] when one is provided).
  final double? height;

  /// Shape used to clip the gradient (and the backdrop blur). Defaults to
  /// [BoxShape.circle].
  final BoxShape shape;

  /// Corner radius used when [shape] is [BoxShape.rectangle]. Ignored for
  /// circles.
  final BorderRadiusGeometry? borderRadius;

  /// Sigma of the Gaussian blur applied to the gradient layer. `0` disables it.
  final double blur;

  /// Sigma of the backdrop blur applied to content behind the box. `0` disables
  /// it.
  final double backdropBlur;

  /// Clip behavior for the shape and backdrop clips.
  final Clip clipBehavior;

  /// Alignment of [child] within the box.
  final AlignmentGeometry alignment;

  /// Optional padding around [child].
  final EdgeInsetsGeometry? padding;

  /// Optional content drawn sharply on top of the (possibly blurred) gradient.
  final Widget? child;

  /// The [EasyRadialGradient] this widget paints. Exposed so callers can reuse
  /// the exact same gradient elsewhere.
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
