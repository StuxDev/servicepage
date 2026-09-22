<p align="center">
  <img src="https://global.media.stux.dev/logo.png" height="80" alt="Stux.Dev Logo">
</p>

# Contributing to Service Page

This is a single-file HTML template, open for use and modification per the
[License](README.md#license) section. This document is for anyone working on
the template itself (not a downstream deployment).

## Local setup

There's no build step or dependencies — just clone the repo and run
`./dev-server.sh [port]` (or `dev-server.bat [port]` on Windows), which starts
a local static server pointed at the directory. Then open
`http://127.0.0.1:8000`.

## Project conventions

- Static HTML pages (`index.html`, `legal.html` + `legal/`, `changelog.html`, `404.html`) — no framework, no build step, no backend.
- Keep it lightweight and dependency-free; Gontserrat and Creato Display are self-hosted under `assets/fonts/`, matching Stux.Dev's actual tools (Stuxs.Tools, Downl.one), not pulled from a third-party CDN.
- `changelog.html` fetches and renders `CHANGELOG.md` at runtime — don't hand-duplicate changelog content into it.
- General contact uses `hello@stux.dev`; legal-page contact uses `legal@stux.dev`.
- This is a single page, not a soonpage/maintenancepage pair — a service either has been set up or it hasn't; there's no separate "under maintenance" state to design for.
- Match the existing code style: no comments explaining *what* the markup does, only *why* when something is genuinely non-obvious.

## Versioning and changelog

- The version lives in `VERSION.md` (a bare version string) — bump it on every release, following [Semantic Versioning](https://semver.org/)
- Every release gets a `CHANGELOG.md` entry using `### Added` / `### Changed` / `### Fixed` subsections
- `commit.sh` (bash) and `commit.bat` (Windows) read `VERSION.md` to commit and tag a release — no need to edit them per release

## Before committing

- Open `index.html` in a browser and check it renders correctly
- Check the page at common viewport widths (mobile/tablet/desktop) since it's meant to be responsive
