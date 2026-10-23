#!/usr/bin/env bash
# Checks the Discord link previews and the favicon set.
# Run with: bash tests/site.sh      (needs bash and Python 3)
#
#  - every page's Discord preview is valid JSON under 3,000 bytes, with no "$1" and no early </script>
#  - the 404 page has no preview
#  - favicon.ico, apple-touch-icon.png, the manifest and its icons exist with the right sizes
#  - every page's <head> has the same icon tag set
#  - scripts/build-discord-embeds.py --check says the previews are up to date
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON="${PYTHON:-$(command -v python3 || command -v python)}"
"$PYTHON" -I - "$ROOT" <<'PY'
import json, os, re, struct, subprocess, sys

root = sys.argv[1]
passed = failed = 0

def check(name, ok):
    global passed, failed
    if ok:
        passed += 1
        print("ok   - " + name)
    else:
        failed += 1
        print("FAIL - " + name)

def png_size(path):
    with open(path, "rb") as f:
        data = f.read(33)
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        return None
    w, h = struct.unpack(">II", data[16:24])
    return (w, h, data[25])  # colour type 2 = RGB (opaque), 6 = RGBA

pages = []
for dirpath, dirs, files in os.walk(root):
    dirs[:] = [d for d in dirs if d not in (".git", "node_modules")]
    for f in files:
        if f.endswith(".html"):
            path = os.path.join(dirpath, f)
            text = open(path, encoding="utf-8").read()
            if "<head" in text:
                pages.append((os.path.relpath(path, root).replace(os.sep, "/"), text))
pages.sort()
check("found at least 9 pages", len(pages) >= 9)

cname = open(os.path.join(root, "CNAME"), encoding="utf-8").read().strip()
media = re.search(r'href="https://global\.media\.([^/]+)/icon-dark\.png"', dict(pages)["index.html"]).group(1)
tags = [
    '<link rel="icon" href="/favicon.ico" sizes="48x48">',
    '<link rel="icon" type="image/png" sizes="512x512" href="https://global.media.%s/icon-dark.png" media="(prefers-color-scheme: light)">' % media,
    '<link rel="icon" type="image/png" sizes="512x512" href="https://global.media.%s/icon-light.png" media="(prefers-color-scheme: dark)">' % media,
    '<link rel="apple-touch-icon" href="/apple-touch-icon.png">',
    '<link rel="manifest" href="/site.webmanifest">',
]
EMBED = re.compile(r'<script id="discord:component-embed" type="application/json">(.*?)</script>', re.S)

for rel, text in pages:
    head = text.split("</head>", 1)[0]
    check(rel + ": the full icon tag set is in <head>", all(t in head for t in tags))
    found = EMBED.findall(head)
    if rel == "404.html":
        check(rel + ": no Discord preview on the error page", "discord:component-embed" not in text)
        continue
    check(rel + ": exactly one Discord preview in <head>", len(found) == 1 and len(EMBED.findall(text)) == 1)
    if len(found) != 1:
        continue
    body = found[0]
    check(rel + ": preview is under 3,000 bytes", len(body.encode("utf-8")) <= 3000)
    check(rel + ": preview has no \"$1\" and can't close the script early", "$1" not in body and "</" not in body)
    try:
        data = json.loads(body)
        root_c = data["component"]
        ok = root_c["type"] == 17 and isinstance(root_c.get("accent_color"), int)
    except (ValueError, KeyError, TypeError):
        ok = False
    check(rel + ": preview is valid JSON with a Container at the root", ok)

# favicon.ico: PNG-in-ICO with 16, 32 and 48px images.
ico = open(os.path.join(root, "favicon.ico"), "rb").read()
reserved, kind, count = struct.unpack("<HHH", ico[:6])
check("favicon.ico is an icon with 3 images", (reserved, kind, count) == (0, 1, 3))
sizes = []
pngs = True
for i in range(count):
    w, h, _c, _r, _p, _b, size, offset = struct.unpack("<BBBBHHII", ico[6 + i * 16: 22 + i * 16])
    sizes.append(w or 256)
    pngs = pngs and ico[offset:offset + 8] == b"\x89PNG\r\n\x1a\n"
check("favicon.ico holds 16, 32 and 48px images", sorted(sizes) == [16, 32, 48])
check("favicon.ico's images are PNGs", pngs)

img = os.path.join(root, "assets", "img")
check("apple-touch-icon.png is 180px and opaque", png_size(os.path.join(root, "apple-touch-icon.png")) == (180, 180, 2))
check("icon-maskable-512.png is 512px and opaque", png_size(os.path.join(img, "icon-maskable-512.png")) == (512, 512, 2))
check("icon-512.png is 512px", png_size(os.path.join(img, "icon-512.png"))[:2] == (512, 512))
check("icon-192.png is 192px", png_size(os.path.join(img, "icon-192.png"))[:2] == (192, 192))

try:
    m = json.load(open(os.path.join(root, "site.webmanifest"), encoding="utf-8"))
except ValueError:
    m = {}
check("site.webmanifest is JSON with the usual fields",
      all(m.get(k) for k in ["name", "short_name", "start_url", "display", "theme_color", "background_color", "icons"]))
check("site.webmanifest starts at / and opens in the browser", m.get("start_url") == "/" and m.get("display") == "browser")
have = [i["sizes"] + (" " + i["purpose"] if "purpose" in i else "") for i in m.get("icons", [])]
check("site.webmanifest has 192, 512 and maskable 512 icons", all(w in have for w in ["192x192", "512x512", "512x512 maskable"]))
check("site.webmanifest's icons exist", all(os.path.isfile(os.path.join(root, i["src"].lstrip("/"))) for i in m.get("icons", [])))

# The committed previews match what the build script would write.
r = subprocess.run([sys.executable, os.path.join(root, "scripts", "build-discord-embeds.py"), "--check"], capture_output=True, text=True)
check("scripts/build-discord-embeds.py --check: previews are up to date", r.returncode == 0)

print("%d passed, %d failed" % (passed, failed))
sys.exit(1 if failed else 0)
PY
