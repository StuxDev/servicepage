# Changelog

All notable changes to Service Page are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH).

## v1.0.3

### Changed
- `changelog.html` now sorts each release's `###` sections into a fixed order — Added, Changed, Fixed, Removed, Security, Deprecated — at render time, rather than trusting the order `CHANGELOG.md` lists them in; unknown section types go last
- Changelog type badges now use the fixed family palette — Added `#2ecc71`, Changed `#3ba7ff`, Fixed `#ffa64d`, Removed `#ff4d4d`, Security `#b06bff`, Deprecated `#8a8a94` — as tinted badges (coloured text on a light tint of the same hue), with darker variants of each for the light theme

## v1.0.2

### Fixed
- The footer's changelog/version link (and other footer links) turned accent-purple once visited — `a:visited` carries a pseudo-class, giving it higher CSS specificity than the plain `footer a` selector meant to keep footer links muted, so it kept winning regardless of source order. Every affected footer link now also styles `footer a:visited` explicitly.

## v1.0.1

### Fixed
- GitHub Pages was using the legacy branch-deploy build system, which can silently stop auto-deploying with no error recorded anywhere (discovered on SeasonalOverlaysLibrary — its live site served stale content for over an hour with no visible failure). Switched to GitHub Actions-based Pages deployment (`.github/workflows/pages.yml`), making every deploy an ordinary, observable CI run instead.

## v1.0.0

### Added

- Initial release: a placeholder page shown when a Stux.Dev service hasn't
  been set up yet, with self-hosted Gontserrat and Creato Display fonts
  (matching Stuxs.Tools and Downl.one), a "Boring Legal Stuff" legal hub
  (`legal.html` + `legal/`), `changelog.html` that fetches and renders
  `CHANGELOG.md` at runtime, a version indicator fetched live from
  `VERSION.md`, cross-origin `postMessage` title sync, `dev-server.sh` /
  `dev-server.bat`, and a custom `404.html` error page
