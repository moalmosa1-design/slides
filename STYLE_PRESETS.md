# Style Presets

Named CSS presets for slide decks. Each preset defines a complete visual identity via CSS custom properties. Copy the variable block into `:root` to apply.

---

## minimal

Clean, whitespace-heavy, editorial feel. Best for: strategy decks, writing/content, academic presentations.

```css
:root {
  /* Colors */
  --bg:             #ffffff;
  --bg-alt:         #f7f7f7;
  --fg:             #111111;
  --fg-muted:       #666666;
  --accent:         #0057ff;
  --accent-light:   #e8eeff;
  --border:         #e2e2e2;
  --surface:        #ffffff;

  /* Typography */
  --font-heading:   'DM Sans', 'Helvetica Neue', Arial, sans-serif;
  --font-body:      'DM Sans', 'Helvetica Neue', Arial, sans-serif;
  --font-mono:      'JetBrains Mono', 'Fira Code', monospace;

  /* Scale */
  --weight-heading: 700;
  --weight-body:    400;
  --tracking-tight: -0.03em;
  --tracking-normal: 0em;

  /* Effects */
  --radius:         4px;
  --shadow:         0 1px 3px rgba(0,0,0,0.08);
  --shadow-lg:      0 8px 30px rgba(0,0,0,0.10);

  /* Google Fonts import */
  /* @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap'); */
}
```

**Special effects:** None. Relies on generous whitespace and precise typographic hierarchy. Accent color used sparingly on links, underlines, and key callouts only.

---

## bold

High-energy, expressive, startup/product-demo feel. Best for: product launches, pitches, creative agencies.

```css
:root {
  /* Colors */
  --bg:             #ffffff;
  --bg-alt:         #f0f0f0;
  --fg:             #0a0a0a;
  --fg-muted:       #555555;
  --accent:         #ff3c00;
  --accent-light:   #fff0ec;
  --accent-2:       #ffce00;
  --border:         #dddddd;
  --surface:        #ffffff;

  /* Typography */
  --font-heading:   'Syne', 'Archivo Black', Impact, Arial Black, sans-serif;
  --font-body:      'Inter', 'Helvetica Neue', Arial, sans-serif;
  --font-mono:      'JetBrains Mono', monospace;

  /* Scale */
  --weight-heading: 900;
  --weight-body:    400;
  --tracking-tight: -0.04em;
  --tracking-normal: -0.01em;

  /* Effects */
  --radius:         2px;
  --shadow:         4px 4px 0px #0a0a0a;
  --shadow-lg:      8px 8px 0px #0a0a0a;

  /* Google Fonts import */
  /* @import url('https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Inter:wght@400;500&display=swap'); */
}
```

**Special effects:** Hard drop shadows (no blur), thick borders, oversized type. Accent color used aggressively on backgrounds, large text, and buttons.

---

## dark

Sophisticated dark mode, premium/tech feel. Best for: developer tools, SaaS, data/AI presentations, evening events.

```css
:root {
  /* Colors */
  --bg:             #0f0f13;
  --bg-alt:         #1a1a24;
  --fg:             #f0f0f0;
  --fg-muted:       #8888aa;
  --accent:         #7c3aed;
  --accent-light:   #2d1b69;
  --accent-2:       #06d6a0;
  --border:         #2a2a3a;
  --surface:        #1e1e2e;

  /* Typography */
  --font-heading:   'Inter', 'Helvetica Neue', Arial, sans-serif;
  --font-body:      'Inter', 'Helvetica Neue', Arial, sans-serif;
  --font-mono:      'JetBrains Mono', 'Fira Code', monospace;

  /* Scale */
  --weight-heading: 700;
  --weight-body:    400;
  --tracking-tight: -0.03em;
  --tracking-normal: 0em;

  /* Effects */
  --radius:         8px;
  --shadow:         0 0 0 1px rgba(124,58,237,0.3), 0 4px 20px rgba(0,0,0,0.5);
  --shadow-lg:      0 0 0 1px rgba(124,58,237,0.4), 0 20px 60px rgba(0,0,0,0.7);
  --glow:           0 0 40px rgba(124,58,237,0.35);

  /* Google Fonts import */
  /* @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap'); */
}
```

**Special effects:** Subtle purple glow on accent elements, thin glowing borders (`box-shadow` rings), semi-transparent surface cards using `background: rgba(30,30,46,0.8)`.

---

## gradient

Vibrant gradient backgrounds, Instagram-era modern feel. Best for: marketing, consumer apps, workshops, social/community presentations.

```css
:root {
  /* Colors */
  --bg:             #ffffff;
  --bg-gradient:    linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --bg-gradient-2:  linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --bg-gradient-3:  linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  --fg:             #ffffff;
  --fg-on-light:    #1a1a2e;
  --fg-muted:       rgba(255,255,255,0.75);
  --accent:         #ffdd57;
  --accent-light:   rgba(255,221,87,0.2);
  --border:         rgba(255,255,255,0.25);
  --surface:        rgba(255,255,255,0.15);

  /* Typography */
  --font-heading:   'Poppins', 'Nunito', 'Helvetica Neue', Arial, sans-serif;
  --font-body:      'Poppins', 'Nunito', 'Helvetica Neue', Arial, sans-serif;
  --font-mono:      'JetBrains Mono', monospace;

  /* Scale */
  --weight-heading: 700;
  --weight-body:    400;
  --tracking-tight: -0.02em;
  --tracking-normal: 0.01em;

  /* Effects */
  --radius:         16px;
  --shadow:         0 4px 15px rgba(0,0,0,0.2);
  --shadow-lg:      0 20px 60px rgba(0,0,0,0.3);
  --glass:          backdrop-filter: blur(10px); background: rgba(255,255,255,0.15);

  /* Google Fonts import */
  /* @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap'); */
}
```

**Special effects:** Apply `background: var(--bg-gradient)` to `.slide` directly. Use `--surface` with `backdrop-filter: blur(12px)` for glassmorphism cards. Rotate through `--bg-gradient-2` and `--bg-gradient-3` for variety across slides.

---

## corporate

Professional, trustworthy, enterprise/consulting feel. Best for: board presentations, financial reports, government, B2B sales.

```css
:root {
  /* Colors */
  --bg:             #ffffff;
  --bg-alt:         #f4f6f9;
  --bg-header:      #1b2b5e;
  --fg:             #1a1a2e;
  --fg-muted:       #5a6b8a;
  --fg-on-dark:     #ffffff;
  --accent:         #1b4fce;
  --accent-light:   #e6edff;
  --accent-2:       #e8a020;
  --border:         #d0d8e8;
  --surface:        #ffffff;

  /* Typography */
  --font-heading:   'Source Sans Pro', 'Open Sans', Arial, sans-serif;
  --font-body:      'Source Sans Pro', 'Open Sans', Arial, sans-serif;
  --font-mono:      'Courier New', monospace;

  /* Scale */
  --weight-heading: 600;
  --weight-body:    400;
  --tracking-tight: -0.01em;
  --tracking-normal: 0.01em;

  /* Effects */
  --radius:         3px;
  --shadow:         0 1px 4px rgba(0,0,0,0.12);
  --shadow-lg:      0 4px 16px rgba(0,0,0,0.15);

  /* Google Fonts import */
  /* @import url('https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700&display=swap'); */
}
```

**Special effects:** Dark header band using `--bg-header` as a top stripe (typically 20% of slide height). Golden accent `--accent-2` for highlights, callout boxes, and dividers. Rule lines between sections.

---

## Mixing Presets

You can mix presets by overriding individual variables. Example: dark background with gradient accent:

```css
:root {
  /* Base: dark */
  --bg: #0f0f13;
  --fg: #f0f0f0;
  /* Override accent with gradient preset's energy */
  --accent: #667eea;
  --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

## Per-Slide Overrides

Override any variable on a single slide:

```html
<div class="slide" style="--bg: #1b2b5e; --fg: #ffffff;">
  <!-- This slide has a dark blue background -->
</div>
```
