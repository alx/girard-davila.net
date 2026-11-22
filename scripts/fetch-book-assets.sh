#!/usr/bin/env bash
# Copy the map book's binary artifacts (55 page PNGs + the A4 PDF) into the
# Hugo build output. They are too heavy to keep in git: a 7.6 MB commit killed
# the Pages deploy (run 45061788156) because this repo stores files compressed
# and the build step paid the decompression cost.
#
# Source of truth, in order:
#   1. static/book/**/*.png|*.pdf in the working tree — present locally, where
#      valorant-mapbook/mirror.py writes them (gitignored). No network needed.
#   2. the tailnet origin that already serves the book (CI, or a cold checkout
#      on a machine that is on the tailnet).
#
# Usage:
#   bash scripts/fetch-book-assets.sh            # dest: public/book
#   SRC=/path/to/valorant-mapbook/web \
#     bash scripts/fetch-book-assets.sh          # explicit local checkout
set -euo pipefail

DEST="${1:-public/book}"
ORIGIN="${BOOK_ASSETS_ORIGIN:-https://lamai270.tail6a160.ts.net/book}"
SRC="${SRC:-static/book}"

die() { echo "fetch-book-assets: $*" >&2; exit 1; }

mkdir -p "$DEST/pages"

# A source counts as present only with BOTH the PDF and every sheet PNG — a
# partial static/book (e.g. a checkout where only the tracked HTML exists) must
# fall through to the origin, not silently copy 13 of 56 files.
# Set BOOK_ASSETS_STRICT=1 in CI: there the working tree never holds the
# artifacts, and a deploy that silently lost its own checks must not pass.
if [ "${BOOK_ASSETS_STRICT:-0}" = 1 ]; then
  have_src=0
elif [ -s "$SRC/tactical-map-book.pdf" ] && [ "$(find "$SRC/pages" -name 'p-*.png' 2>/dev/null | wc -l)" -ge 55 ]; then
  have_src=1
else
  have_src=0
fi

if [ "$have_src" = 1 ]; then
  cp -f "$SRC"/pages/*.png "$DEST/pages/"
  cp -f "$SRC"/*.pdf "$DEST/"
  echo "fetch-book-assets: copied from local $SRC"
else
  command -v curl >/dev/null || die "no local artifacts in $SRC and no curl available"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  # The sheets are a plain p-01..p-55 sequence (build_web.py numbers them), so
  # fetch by index instead of trying to enumerate a Caddy directory listing —
  # the listing only shows pages referenced by index.html (13 overviews) and a
  # missing sheet would otherwise pass as a complete build.
  pages=""
  for i in $(seq -w 1 55); do pages="$pages p-$i.png"; done

  for p in $pages; do
    curl -fsS --retry 3 --retry-delay 2 --max-time 120 "$ORIGIN/pages/$p" -o "$DEST/pages/$p" \
      || die "fetch failed: $ORIGIN/pages/$p"
  done
  curl -fsS --retry 3 --retry-delay 2 --max-time 300 "$ORIGIN/tactical-map-book.pdf" -o "$DEST/tactical-map-book.pdf" \
    || die "PDF fetch failed from $ORIGIN"
  echo "fetch-book-assets: fetched 55 pages + PDF from $ORIGIN"
fi

# Fail loudly rather than ship a half-built book: the HTML references 55 sheets.
n=$(find "$DEST/pages" -name 'p-*.png' | wc -l)
[ "$n" -ge 55 ] || die "only $n page images in $DEST/pages (want 55)"
[ -s "$DEST/tactical-map-book.pdf" ] || die "PDF missing in $DEST"
echo "fetch-book-assets: ok — $n pages + PDF in $DEST"
