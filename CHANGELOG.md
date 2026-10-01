# Changelog

All notable changes to Service Page are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH).

## v1.1.1

### Changed

- The copyright line reads Stux.Group instead of Stux Group Ltd

### Fixed

- The footer's Created-with icons are optically sized, so the heart no longer looks bigger than the code and coffee icons

## v1.1.0

### Added
- A dev-mode banner, the shared Stux site banner (`assets/site-banner.css` + `assets/site-banner.js`), shown only when the page is opened from localhost (`dev-server.sh`/`.bat`); `?banner=soon,maintenance,site` previews the other banner types locally, and the live site never shows one. It sits above the page without covering it
- The footer brand row on the main page: the Stux.Dev logo, "A Stux.Dev Service" (linking to services.stux.dev), 28px tall and grey until hovered or focused, plus a "Created with love / code / coffee by Stux.Dev" line. This site is on GitHub Pages, so there is no Powered by Stuxedo badge
- `/sitemap` (an HTML page in the site's layout listing every page) and `sitemap.xml`, committed as static files and regenerated with `python scripts/build-sitemap.py` (`lastmod` comes from each page's last git commit); `robots.txt` points at it and the footer links to it

### Changed
- The copyright symbol on the legal pages is a small inline SVG glyph, with a visually hidden "Copyright" so screen readers still read it

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
