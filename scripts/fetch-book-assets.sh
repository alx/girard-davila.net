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

have_src=0
[ -s "$SRC/tactical-map-book.pdf" ] && have_src=1
[ -d "$SRC/pages" ] && [ -n "$(find "$SRC/pages" -name 'p-*.png' -print -quit)" ] && have_src=1

if [ "$have_src" = 1 ]; then
  cp -f "$SRC"/pages/*.png "$DEST/pages/"
  cp -f "$SRC"/*.pdf "$DEST/"
  echo "fetch-book-assets: copied from local $SRC"
else
  command -v curl >/dev/null || die "no local artifacts in $SRC and no curl available"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  # /book/ (the directory URL) lists the whole tree: map/ + pages/. Every sheet
  # PNG lives in pages/, so this one listing is the complete manifest.
  curl -fsSL --max-time 60 "$ORIGIN/" -o "$tmp/listing.html" \
    || die "cannot reach $ORIGIN (not on the tailnet? set SRC=... instead)"
  pages="$(grep -o 'p-[0-9][0-9]*\.png' "$tmp/listing.html" | sort -u || true)"
  [ -n "$pages" ] || die "no page images listed at $ORIGIN/"

  for p in $pages; do
    curl -fsS --max-time 120 "$ORIGIN/pages/$p" -o "$DEST/pages/$p" \
      || die "fetch failed: $ORIGIN/pages/$p"
  done
  curl -fsS --max-time 180 "$ORIGIN/tactical-map-book.pdf" -o "$DEST/tactical-map-book.pdf" \
    || die "PDF fetch failed from $ORIGIN"
  echo "fetch-book-assets: fetched $(echo "$pages" | wc -l) pages + PDF from $ORIGIN"
fi

# Fail loudly rather than ship a half-built book: the HTML references 55 sheets.
n=$(find "$DEST/pages" -name 'p-*.png' | wc -l)
[ "$n" -ge 55 ] || die "only $n page images in $DEST/pages (want 55)"
[ -s "$DEST/tactical-map-book.pdf" ] || die "PDF missing in $DEST"
echo "fetch-book-assets: ok — $n pages + PDF in $DEST"
