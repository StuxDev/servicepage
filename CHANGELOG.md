# Changelog

All notable changes to Service Page are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Date Versioning](https://datevers.ing) since v26.10.23 (`YY.MM.DD`, the UTC release date, with `-1`, `-2`… for later releases the same day); earlier releases used [Semantic Versioning](https://semver.org/).

## v26.10.23-1

### Added

- Discord link previews: every page except the 404 page carries a `discord:component-embed` block in its `<head>`, in the Stux.Dev orange (`#FD6602`) with the Stux.Dev icon. The home page says what this placeholder is and links to Stux.Dev and all services; the changelog, the legal hub and the other pages get their own preview. The blocks are pre-built and committed by `python scripts/build-discord-embeds.py` (which `build-sitemap.py` now runs too), page text is escaped so it shows as plain text, a preview over Discord's 3,000-byte limit is left out, and the page title and description stay as the fallback
- A full favicon set generated from the Stux.Dev icon: `favicon.ico` (16, 32 and 48px), `apple-touch-icon.png` (on a white background, so iOS doesn't fill it with black) and `site.webmanifest` with 192px, 512px and maskable 512px icons, linked from every page, the 404 page included
- `tests/site.sh`, which checks every Discord preview (valid JSON, under 3,000 bytes, none on the 404 page), the favicon files and sizes, the manifest, and the icon tags in every `<head>`; CI now runs it and `tests/version.sh`

## v26.10.23

### Added

- `tests/version.sh`, which checks that `VERSION.md` is a valid Date Version, a real calendar date not in the future, and the same as the newest entry in this changelog

### Changed

- Switched from Semantic Versioning to [Date Versioning](https://datevers.ing): releases are numbered by their UTC release date as `YY.MM.DD`, with `-1`, `-2`… for later releases the same day. This release follows v1.1.5
- `commit.sh` and `commit.bat` refuse a `VERSION.md` that isn't a valid Date Version or is dated in the future (UTC), and warn when it's dated before today
- `README.md` and `CONTRIBUTING.md` describe Date Versioning and the release steps

## v1.1.5

### Changed

- The favicon follows the browser's light or dark theme: the deep icon (`icon-dark.png`) on light and the bright one (`icon-light.png`) on dark, straight from the brand's media host, so a brand colour change is just a new file there
- The logos and icons in the Markdown docs (README and the like) follow GitHub's light or dark theme, using each brand's `logo-light`/`logo-dark` and `icon-light`/`icon-dark` files

## v1.1.4

### Changed

- The favicon follows the browser's light or dark theme: the deep icon (`icon-dark.png`) on light and the bright one (`icon-light.png`) on dark, straight from the brand's media host, so a brand colour change is just a new file there
- The logos and icons in the Markdown docs (README and the like) follow GitHub's light or dark theme, using each brand's `logo-light`/`logo-dark` and `icon-light`/`icon-dark` files

## v1.1.3

### Changed

- README footer now matches the Stux.Dev `.github` footer ("Built & Maintained by Stux.Dev…" and "Stux.Dev is a part of the Stux.Group brand of businesses"), like every other Stux.Dev repository

## v1.1.2

### Changed

- The footer's copyright year is worked out automatically: the start year alone in the first year, then START–CURRENT

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
