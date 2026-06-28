# Contributing

Thanks for your interest in **easy_radial_gradient**! This guide covers local
setup, the conventions this repo follows, and how to cut a release.

(AI agents working in this repo: read [`AGENTS.md`](AGENTS.md) first.)

## Prerequisites

- Flutter (stable) ≥ 3.27, Dart ≥ 3.11
- Verify with `flutter --version`

## Setup

```sh
git clone https://github.com/keepYaoung/easy-radial-gradient.git
cd easy-radial-gradient
flutter pub get
```

## Day-to-day commands

```sh
flutter analyze       # static analysis — keep it clean
dart format .         # format — required before committing
flutter test          # run unit + widget + golden tests
```

Run the demo app:

```sh
cd example && flutter run
```

## Project structure

```
lib/
  easy_radial_gradient.dart      # public barrel: exports + library doc
  src/
    radial_stop.dart             # RadialStop (position + color + opacity)
    easy_radial_gradient.dart    # EasyRadialGradient (RadialGradient subclass)
    radial_gradient_box.dart     # RadialGradientBox (blur / backdrop blur)
test/                            # unit, widget, and golden tests
doc/images/                      # generated showcase + logo (goldens)
example/                         # runnable demo
```

## Conventions

- **Bilingual docs.** Public API dartdoc is written English first, then a Korean
  translation. Keep both updated together.
- **Formatting.** `dart format .` must produce no changes.
- **Tests.** Add or update tests for any behavior change. Aim to keep a 160/160
  [pana](https://pub.dev/packages/pana) score (`pana .`).
- **Visual assets are goldens.** The showcase and logo PNGs are generated, not
  hand-edited:

  ```sh
  flutter test --update-goldens test/showcase_golden_test.dart
  flutter test --update-goldens test/logo_golden_test.dart
  ```

  Review the regenerated images before committing.

## Submitting changes

1. Branch off `main`.
2. Make your change with tests and docs.
3. Ensure `flutter analyze`, `dart format .`, and `flutter test` are all clean.
4. Open a pull request describing the change and the motivation.

## Releasing (maintainers)

1. Bump `version` in `pubspec.yaml` (semver).
2. Add a `CHANGELOG.md` entry.
3. `flutter pub publish --dry-run` → expect **0 warnings**.
4. `flutter pub publish`.

> Published versions are **permanent** — they cannot be unpublished or
> overwritten. Never reuse a version number.

## Support

Enjoying the package? A 👍 on
[pub.dev](https://pub.dev/packages/easy_radial_gradient) or a ⭐ on the repo is
genuinely appreciated and helps others discover it.
