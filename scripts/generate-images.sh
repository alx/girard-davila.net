#!/usr/bin/env bash
# Generate hero and project images for girard-davila.net
# Usage: ./scripts/generate-images.sh
set -e
SD_URL="http://fami-1.tail6a160.ts.net:1234"
OUT="static/images"
mkdir -p "$OUT"

if ! curl -sf "$SD_URL/sdapi/v1/sd-models" > /dev/null 2>&1; then
  echo "❌ SD server not reachable"; exit 1
fi
echo "✅ SD server online"

gen() {
  local name="$1" prompt="$2"
  echo "🎨 Generating $name..."
  curl -sf "$SD_URL/sdapi/v1/txt2img" \
    -H "Content-Type: application/json" \
    -d "{\"prompt\":\"$prompt\",\"steps\":20,\"width\":512,\"height\":512}" \
    | python3 -c "
import sys,json,base64
d=json.load(sys.stdin)
img=d.get('images',[None])[0]
if img:
    open('$OUT/$name.png','wb').write(base64.b64decode(img))
    print('  ✓ $OUT/$name.png')
else: print('  ✗ no image')
"
  sleep 1
}

gen "hero-bg"      "abstract neural network nodes glowing dark background blue purple gradient cinematic"
gen "nanoclaw"     "robot assistant hologram blue glow minimalist dark tech"
gen "basecamp-ai"  "secure server vault padlock glowing data center sovereign"
gen "recognition"  "museum gallery augmented reality computer vision floating annotations"
gen "joligen"      "generative art AI painting diffusion abstract colorful"
gen "samui"        "tropical beach sunrise golden hour koh samui thailand"

echo "✅ Done — images in $OUT/"
