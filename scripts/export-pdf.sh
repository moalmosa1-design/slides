#!/usr/bin/env bash
# export-pdf.sh — Export an HTML slide deck to a PDF file.
#
# Usage:
#   ./export-pdf.sh --file <slides.html> --output <output.pdf>
#
# Options:
#   --file      Path to the input HTML slide file (required)
#   --output    Path for the output PDF file (required)
#   --width     Viewport width in pixels (default: 1280)
#   --height    Viewport height in pixels (default: 720)
#   --delay     Milliseconds to wait after page load before capturing (default: 800)
#   --help      Show this help text
#
# Export method:
#   1. Puppeteer via npx (preferred) — uses headless Chrome for pixel-perfect output
#   2. wkhtmltopdf (fallback)        — faster but may not render CSS animations
#
#   If neither is available the script exits with an error and install instructions.
#
# Examples:
#   ./export-pdf.sh --file ./my-deck.html --output ./my-deck.pdf
#   ./export-pdf.sh --file ./my-deck.html --output ./my-deck.pdf --delay 1200
#
# Notes:
#   - The exported PDF will have one page per slide.
#   - Puppeteer mode uses print media query (@media print) which hides nav chrome.
#   - wkhtmltopdf mode sets page size to 16:9 (1280×720 pt landscape).
#   - Node.js 18+ is required for the Puppeteer path.

set -euo pipefail

# ── Defaults ─────────────────────────────────────────────────────────────────
FILE=""
OUTPUT=""
VIEWPORT_W=1280
VIEWPORT_H=720
DELAY=800

# ── Argument parsing ──────────────────────────────────────────────────────────
usage() {
  grep '^#' "$0" | sed 's/^# \?//' | head -35
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file)    FILE="$2";     shift 2 ;;
    --output)  OUTPUT="$2";   shift 2 ;;
    --width)   VIEWPORT_W="$2"; shift 2 ;;
    --height)  VIEWPORT_H="$2"; shift 2 ;;
    --delay)   DELAY="$2";    shift 2 ;;
    --help|-h) usage ;;
    *) echo "Unknown option: $1" >&2; echo "Run with --help for usage." >&2; exit 1 ;;
  esac
done

# ── Validation ────────────────────────────────────────────────────────────────
if [[ -z "$FILE" ]]; then
  echo "Error: --file is required." >&2; exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "Error: File not found: $FILE" >&2; exit 1
fi

if [[ -z "$OUTPUT" ]]; then
  echo "Error: --output is required." >&2; exit 1
fi

# Ensure output has .pdf extension
if [[ "${OUTPUT##*.}" != "pdf" ]]; then
  OUTPUT="${OUTPUT}.pdf"
fi

# Resolve to absolute paths
FILE="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"
OUTPUT_DIR="$(cd "$(dirname "$OUTPUT")" 2>/dev/null || mkdir -p "$(dirname "$OUTPUT")" && cd "$(dirname "$OUTPUT")" && pwd)"
OUTPUT="${OUTPUT_DIR}/$(basename "$OUTPUT")"

echo "Input:    $FILE"
echo "Output:   $OUTPUT"
echo "Viewport: ${VIEWPORT_W}x${VIEWPORT_H}"
echo "Delay:    ${DELAY}ms"
echo ""

# ── Dependency check ──────────────────────────────────────────────────────────
HAS_NODE=false
HAS_NPX=false
HAS_WKHTMLTOPDF=false

command -v node     &>/dev/null && HAS_NODE=true
command -v npx      &>/dev/null && HAS_NPX=true
command -v wkhtmltopdf &>/dev/null && HAS_WKHTMLTOPDF=true

# ── Method 1: Puppeteer via npx ───────────────────────────────────────────────
export_puppeteer() {
  echo "Exporting via Puppeteer (headless Chrome)..."

  # Write a temporary Node.js script
  TMP_SCRIPT="$(mktemp /tmp/export-slides-XXXXXX.mjs)"

  cat > "$TMP_SCRIPT" <<NODESCRIPT
import puppeteer from 'puppeteer';
import { pathToFileURL } from 'url';
import { resolve } from 'path';

const filePath  = process.argv[2];
const outputPath = process.argv[3];
const width  = parseInt(process.argv[4], 10) || 1280;
const height = parseInt(process.argv[5], 10) || 720;
const delay  = parseInt(process.argv[6], 10) || 800;

(async () => {
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
  });

  const page = await browser.newPage();

  // Set viewport to slide dimensions
  await page.setViewport({ width, height, deviceScaleFactor: 2 });

  const url = pathToFileURL(resolve(filePath)).href;
  await page.goto(url, { waitUntil: 'networkidle0', timeout: 30000 });

  // Wait for any entrance animations to settle
  await new Promise(r => setTimeout(r, delay));

  // Count slides
  const slideCount = await page.evaluate(() => {
    return document.querySelectorAll('.slide').length;
  });

  if (slideCount === 0) {
    console.error('No .slide elements found in the HTML. Is this a valid slide deck?');
    await browser.close();
    process.exit(1);
  }

  console.log(\`Found \${slideCount} slides.\`);

  // Collect PDFs per slide, then merge
  // We activate each slide via JS, capture it as a PDF page, then stitch together.
  const pageBuffers = [];

  for (let i = 0; i < slideCount; i++) {
    // Activate slide i
    await page.evaluate((index) => {
      const slides = document.querySelectorAll('.slide');
      slides.forEach((s, si) => {
        s.classList.toggle('active', si === index);
      });
    }, i);

    // Short wait for transitions
    await new Promise(r => setTimeout(r, 200));

    const pdf = await page.pdf({
      width:  \`\${width}px\`,
      height: \`\${height}px\`,
      printBackground: true,
      pageRanges: '1',
    });

    pageBuffers.push(pdf);
    console.log(\`  Captured slide \${i + 1} / \${slideCount}\`);
  }

  // Simple concatenation: write first PDF (proper multi-page merge would need pdf-lib,
  // but for most decks each PDF is single-page, so we use a workaround below)
  // If puppeteer supports it, use a single print pass with @media print page breaks.
  // Fall back to activating all slides and printing at once.
  await page.evaluate(() => {
    // For print: show all slides as block elements
    document.querySelectorAll('.slide').forEach(s => {
      s.style.position = 'relative';
      s.style.opacity  = '1';
      s.style.transform = 'none';
      s.style.pointerEvents = 'auto';
      s.style.display = 'flex';
    });
    // Hide nav chrome
    const chrome = document.querySelectorAll('.nav-dots, .nav-arrows, .slide-counter, .progress-bar');
    chrome.forEach(el => { el.style.display = 'none'; });
    // Wrapper: auto height
    const wrapper = document.querySelector('.slides-wrapper');
    if (wrapper) { wrapper.style.height = 'auto'; wrapper.style.overflow = 'visible'; }
    const deck = document.querySelector('.deck');
    if (deck) { deck.style.height = 'auto'; deck.style.overflow = 'visible'; }
  });

  await new Promise(r => setTimeout(r, 300));

  const finalPdf = await page.pdf({
    width:  \`\${width}px\`,
    height: \`\${height}px\`,
    printBackground: true,
  });

  const fs = await import('fs');
  fs.writeFileSync(outputPath, finalPdf);

  await browser.close();
  console.log(\`PDF saved to: \${outputPath}\`);
})();
NODESCRIPT

  # Run with npx puppeteer — installs it on first run if needed
  npx --yes puppeteer@">=21" node "$TMP_SCRIPT" "$FILE" "$OUTPUT" "$VIEWPORT_W" "$VIEWPORT_H" "$DELAY"
  local exit_code=$?

  rm -f "$TMP_SCRIPT"
  return $exit_code
}

# ── Method 2: wkhtmltopdf ─────────────────────────────────────────────────────
export_wkhtmltopdf() {
  echo "Exporting via wkhtmltopdf (fallback)..."
  echo "Note: CSS animations and advanced layout may not render perfectly."

  # 16:9 landscape at 96 DPI: 1280/96 * 25.4 = 338.67mm × 190.5mm
  wkhtmltopdf \
    --page-width 338.67mm \
    --page-height 190.5mm \
    --orientation Landscape \
    --viewport-size "${VIEWPORT_W}x${VIEWPORT_H}" \
    --javascript-delay "$DELAY" \
    --enable-local-file-access \
    --print-media-type \
    --no-background \
    --margin-top 0 --margin-bottom 0 --margin-left 0 --margin-right 0 \
    --quiet \
    "file://${FILE}" \
    "$OUTPUT"
}

# ── Main dispatch ─────────────────────────────────────────────────────────────
if [[ "$HAS_NPX" == true ]] && [[ "$HAS_NODE" == true ]]; then
  # Check Node version >= 18
  NODE_MAJOR=$(node --version | sed 's/v\([0-9]*\).*/\1/')
  if [[ "$NODE_MAJOR" -ge 18 ]]; then
    if export_puppeteer; then
      echo ""
      echo "Done. PDF exported successfully via Puppeteer."
      exit 0
    else
      echo "Puppeteer export failed. Trying wkhtmltopdf fallback..." >&2
    fi
  else
    echo "Node.js ${NODE_MAJOR} is too old (need 18+). Trying wkhtmltopdf..." >&2
  fi
fi

if [[ "$HAS_WKHTMLTOPDF" == true ]]; then
  if export_wkhtmltopdf; then
    echo ""
    echo "Done. PDF exported successfully via wkhtmltopdf."
    exit 0
  else
    echo "wkhtmltopdf export failed." >&2
    exit 1
  fi
fi

# Neither tool available
cat >&2 <<EOF

Error: No supported PDF export tool found.

To install Puppeteer (recommended):
  npm install -g puppeteer
  # or use npx (no install needed): npx puppeteer ...

To install wkhtmltopdf (fallback):
  # macOS:
  brew install wkhtmltopdf

  # Ubuntu/Debian:
  sudo apt-get install wkhtmltopdf

  # Download binary: https://wkhtmltopdf.org/downloads.html

EOF
exit 1
