# HTML Slide Deck Boilerplate

This is the canonical HTML template for all slide decks produced by the frontend-slides skill. Copy it verbatim, then replace the sample slides with real content.

The template includes:
- DOCTYPE + meta viewport
- Inline style block with all `viewport-base.css` patterns (no external link needed)
- Nav dots indicator
- Prev/next arrow buttons
- Slide counter (current / total)
- Progress bar
- Full keyboard navigation (← → Space, Home, End)
- Touch/swipe support
- 3-slide sample structure: title, content, closing

---

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Slide Deck</title>
  <!--
    Google Fonts — uncomment the import matching your chosen STYLE_PRESETS.md preset.
    Example for "minimal" preset (DM Sans):
  -->
  <!-- <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet"> -->

  <style>
    /* ── PASTE viewport-base.css CONTENTS HERE ── */
    /* (Copy everything from viewport-base.css into this block) */

    /* ── STYLE PRESET OVERRIDE ──────────────────
       Replace these variables with your chosen preset from STYLE_PRESETS.md
    */
    :root {
      --bg:           #ffffff;
      --bg-alt:       #f7f7f7;
      --fg:           #111111;
      --fg-muted:     #666666;
      --accent:       #0057ff;
      --accent-light: #e8eeff;
      --border:       #e2e2e2;
      --surface:      #ffffff;
      --font-heading: 'DM Sans', 'Helvetica Neue', Arial, sans-serif;
      --font-body:    'DM Sans', 'Helvetica Neue', Arial, sans-serif;
      --font-mono:    'JetBrains Mono', 'Courier New', monospace;
      --weight-heading: 700;
      --radius:       4px;
      --shadow:       0 1px 3px rgba(0,0,0,0.08);
      --shadow-lg:    0 8px 30px rgba(0,0,0,0.10);
    }

    /* ── NAV DOTS ────────────────────────────── */
    .nav-dots {
      position: absolute;
      bottom: clamp(10px, 1.5cqi, 22px);
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      gap: clamp(5px, 0.7cqi, 10px);
      z-index: 20;
    }

    .nav-dot {
      width:  clamp(6px, 0.8cqi, 11px);
      height: clamp(6px, 0.8cqi, 11px);
      border-radius: 50%;
      background: var(--border);
      border: none;
      padding: 0;
      cursor: pointer;
      transition: background 200ms ease, transform 200ms ease;
    }

    .nav-dot.active {
      background: var(--accent);
      transform: scale(1.25);
    }

    /* ── ARROW BUTTONS ───────────────────────── */
    .nav-arrows {
      position: absolute;
      inset: 0;
      pointer-events: none;
      z-index: 20;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 clamp(8px, 1.2cqi, 18px);
    }

    .nav-arrow {
      pointer-events: auto;
      background: rgba(0,0,0,0.12);
      border: none;
      border-radius: 50%;
      width:  clamp(28px, 3.5cqi, 48px);
      height: clamp(28px, 3.5cqi, 48px);
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      color: var(--fg);
      opacity: 0;
      transition: opacity 200ms ease, background 200ms ease;
    }

    .nav-arrow svg {
      width:  clamp(12px, 1.5cqi, 20px);
      height: clamp(12px, 1.5cqi, 20px);
    }

    .deck:hover .nav-arrow { opacity: 1; }
    .nav-arrow:hover { background: rgba(0,0,0,0.25); }
    .nav-arrow:disabled { opacity: 0 !important; cursor: default; }

    /* ── SLIDE COUNTER ───────────────────────── */
    .slide-counter {
      position: absolute;
      bottom: clamp(8px, 1.2cqi, 18px);
      right:  clamp(12px, 2cqi, 28px);
      font-size: clamp(9px, 1cqi, 14px);
      font-family: var(--font-body);
      color: var(--fg-muted);
      opacity: 0.7;
      z-index: 20;
      pointer-events: none;
      letter-spacing: 0.05em;
    }

    /* ── PROGRESS BAR ────────────────────────── */
    .progress-bar {
      position: absolute;
      bottom: 0;
      left: 0;
      height: 3px;
      background: var(--accent);
      transition: width 300ms ease;
      z-index: 20;
    }

    /* ── CUSTOM SLIDE STYLES ─────────────────── */
    /* Add deck-specific styles below this line  */

  </style>
</head>
<body>

<div class="slides-wrapper">
  <div class="deck" id="deck">

    <!-- ═══════════════════════════════════════
         SLIDE 1 — TITLE SLIDE
         ═══════════════════════════════════════ -->
    <div class="slide active centered" data-slide="1">
      <div style="max-width: 80%; margin: 0 auto;">
        <span class="tag">Conference 2025</span>
        <div style="height: clamp(12px, 1.5cqi, 24px);"></div>
        <h1>Your Compelling<br>Presentation Title</h1>
        <div class="divider" style="margin: clamp(12px,2cqi,28px) auto;"></div>
        <p class="text-subtitle">Speaker Name &nbsp;·&nbsp; Organization &nbsp;·&nbsp; Date</p>
      </div>
    </div>

    <!-- ═══════════════════════════════════════
         SLIDE 2 — CONTENT SLIDE
         ═══════════════════════════════════════ -->
    <div class="slide" data-slide="2">
      <div style="width: 100%;">
        <span class="tag">Section One</span>
        <div style="height: clamp(8px, 1cqi, 16px);"></div>
        <h2>Key Points</h2>
        <div class="divider"></div>
        <div class="cols-2" style="align-items: start; margin-top: clamp(12px,2cqi,28px);">
          <ul class="clean">
            <li>First important insight that shapes our thinking</li>
            <li>Second finding with supporting evidence</li>
            <li>Third takeaway for the audience</li>
          </ul>
          <div class="card">
            <p class="label">Key Metric</p>
            <p class="text-display accent" style="font-size: clamp(32px,7cqi,96px); line-height:1;">87%</p>
            <p class="muted">of organizations report positive outcomes</p>
          </div>
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════
         SLIDE 3 — CLOSING SLIDE
         ═══════════════════════════════════════ -->
    <div class="slide centered" data-slide="3" style="--bg: var(--accent); --fg: #ffffff; --fg-muted: rgba(255,255,255,0.75);">
      <div style="max-width: 75%; margin: 0 auto;">
        <h1 style="color: #ffffff;">Thank You</h1>
        <div class="divider" style="background: rgba(255,255,255,0.5); margin: clamp(12px,2cqi,28px) auto;"></div>
        <p class="text-subtitle" style="color: rgba(255,255,255,0.8);">
          Questions? Reach out at hello@example.com
        </p>
        <div style="margin-top: clamp(20px,3cqi,48px);">
          <p class="label" style="color: rgba(255,255,255,0.6);">Slides available at example.com/slides</p>
        </div>
      </div>
    </div>

    <!-- ─────────────────────────────────────────
         NAVIGATION CHROME
         ───────────────────────────────────────── -->

    <!-- Arrow buttons -->
    <div class="nav-arrows">
      <button class="nav-arrow" id="prevBtn" aria-label="Previous slide" disabled>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"/>
        </svg>
      </button>
      <button class="nav-arrow" id="nextBtn" aria-label="Next slide">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="9 18 15 12 9 6"/>
        </svg>
      </button>
    </div>

    <!-- Nav dots (generated by JS) -->
    <div class="nav-dots" id="navDots" role="tablist" aria-label="Slide navigation"></div>

    <!-- Slide counter -->
    <div class="slide-counter" id="slideCounter" aria-live="polite">1 / 3</div>

    <!-- Progress bar -->
    <div class="progress-bar" id="progressBar" role="progressbar" aria-valuemin="1" aria-valuemax="3" aria-valuenow="1"></div>

  </div><!-- /.deck -->
</div><!-- /.slides-wrapper -->

<script>
(function () {
  'use strict';

  /* ── State ───────────────────────────────── */
  const deck      = document.getElementById('deck');
  const slides    = Array.from(deck.querySelectorAll('.slide'));
  const dotsWrap  = document.getElementById('navDots');
  const counter   = document.getElementById('slideCounter');
  const progress  = document.getElementById('progressBar');
  const prevBtn   = document.getElementById('prevBtn');
  const nextBtn   = document.getElementById('nextBtn');
  const total     = slides.length;
  let   current   = 0;

  /* ── Build nav dots ──────────────────────── */
  slides.forEach(function (_, i) {
    const dot = document.createElement('button');
    dot.className   = 'nav-dot' + (i === 0 ? ' active' : '');
    dot.setAttribute('role', 'tab');
    dot.setAttribute('aria-label', 'Go to slide ' + (i + 1));
    dot.setAttribute('aria-selected', i === 0 ? 'true' : 'false');
    dot.addEventListener('click', function () { goTo(i); });
    dotsWrap.appendChild(dot);
  });

  const dots = Array.from(dotsWrap.querySelectorAll('.nav-dot'));

  /* ── Navigate to slide index ─────────────── */
  function goTo(index) {
    if (index < 0 || index >= total || index === current) return;

    const prev = current;
    current = index;

    /* Swap active class */
    slides[prev].classList.remove('active');
    slides[current].classList.add('active');

    /* Update dots */
    dots[prev].classList.remove('active');
    dots[prev].setAttribute('aria-selected', 'false');
    dots[current].classList.add('active');
    dots[current].setAttribute('aria-selected', 'true');

    /* Update counter */
    counter.textContent = (current + 1) + ' / ' + total;
    progress.setAttribute('aria-valuenow', current + 1);

    /* Update progress bar */
    progress.style.width = ((current + 1) / total * 100) + '%';

    /* Update arrow buttons */
    prevBtn.disabled = current === 0;
    nextBtn.disabled = current === total - 1;
  }

  /* ── Button handlers ─────────────────────── */
  prevBtn.addEventListener('click', function () { goTo(current - 1); });
  nextBtn.addEventListener('click', function () { goTo(current + 1); });

  /* ── Keyboard navigation ─────────────────── */
  document.addEventListener('keydown', function (e) {
    switch (e.key) {
      case 'ArrowRight':
      case 'ArrowDown':
      case ' ':
        e.preventDefault();
        goTo(current + 1);
        break;
      case 'ArrowLeft':
      case 'ArrowUp':
        e.preventDefault();
        goTo(current - 1);
        break;
      case 'Home':
        e.preventDefault();
        goTo(0);
        break;
      case 'End':
        e.preventDefault();
        goTo(total - 1);
        break;
      case 'f':
      case 'F':
        /* Toggle fullscreen */
        if (!document.fullscreenElement) {
          document.documentElement.requestFullscreen().catch(function () {});
        } else {
          document.exitFullscreen();
        }
        break;
    }
  });

  /* ── Touch / swipe support ───────────────── */
  let touchStartX = 0;
  let touchStartY = 0;

  deck.addEventListener('touchstart', function (e) {
    touchStartX = e.touches[0].clientX;
    touchStartY = e.touches[0].clientY;
  }, { passive: true });

  deck.addEventListener('touchend', function (e) {
    const dx = e.changedTouches[0].clientX - touchStartX;
    const dy = e.changedTouches[0].clientY - touchStartY;
    /* Only trigger if horizontal swipe is dominant */
    if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 40) {
      if (dx < 0) goTo(current + 1); /* swipe left → next */
      else        goTo(current - 1); /* swipe right → prev */
    }
  }, { passive: true });

  /* ── Init ────────────────────────────────── */
  progress.style.width = (1 / total * 100) + '%';
  prevBtn.disabled = true;
  counter.textContent = '1 / ' + total;

})();
</script>

</body>
</html>
```

---

## Usage Notes

### Adding More Slides

Insert additional `<div class="slide" data-slide="N">` elements before the navigation chrome. The JS counts them automatically — no changes needed to the script.

### Centered vs. Left-aligned Slides

- Add class `centered` to `.slide` to center content both horizontally and vertically.
- Default is left-aligned, top-to-bottom flex column.

### Full-bleed Background Color on a Single Slide

```html
<div class="slide" style="--bg: #0f0f13; --fg: #ffffff;">
```

### Full-bleed Background Image on a Single Slide

```html
<div class="slide" style="background-image: url('...'); background-size: cover; background-position: center;">
  <!-- Add a dark overlay if needed -->
  <div style="position:absolute;inset:0;background:rgba(0,0,0,0.55);"></div>
  <div style="position:relative;z-index:1;"><!-- content --></div>
</div>
```

### Slide Transition Variants

Add a class to `.deck` to change all transitions:

```html
<div class="deck transition-fade" id="deck">
```

Options: `transition-fade`, `transition-slide`, `transition-zoom`, `transition-cut`.

### Presenting in Fullscreen

Press `F` to toggle fullscreen. Works in all modern browsers.
