## 1.0.3

* Rewrite the example into a live code editor: a `RadialGradientBox` snippet
  whose numeric literals (radius, blur, stop position, opacities) are editable
  inline, updating a single radial-gradient circle in real time.
* Add `AGENTS.md` (guidance for AI coding agents) and `CONTRIBUTING.md`
  (contributor guide), plus a short "Support" section in the README.
* Add web support to the example and a live, in-browser demo of the playground
  (linked at the top of the README), with badges.

No changes to the public library API.

## 1.0.2

* Replace the package thumbnail with a "liquid glass" frosted-glass logo
  (a backdrop-blurred card floating over vivid blobs). No code changes.

## 1.0.1

* Add a package logo and a showcase image as pub.dev `screenshots` — the logo
  now appears as the package thumbnail. No code changes.

## 1.0.0

First stable release. No API changes from `0.0.1` — the public API
(`RadialStop`, `EasyRadialGradient`, `RadialGradientBox`) is now considered
stable, with bilingual (English/Korean) dartdoc and a 160/160 pana score.

## 0.0.1

Initial release.

* `RadialStop` — a design-tool-style gradient stop bundling position, color and
  opacity, with `.start` / `.at` / `.end` / `.transparent` named constructors
  for readable inline stops.
* `EasyRadialGradient` — a drop-in `RadialGradient` built from a `colorStops`
  list, with auto-sorted stops, `copyWith`, and an `EasyRadialGradient.glow`
  factory.
* `RadialGradientBox` — a widget that paints the gradient with optional Gaussian
  `blur` (gradient only, child stays sharp) and frosted-glass `backdropBlur`,
  clipped to a circle or rounded rectangle.
