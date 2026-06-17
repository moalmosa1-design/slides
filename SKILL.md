# frontend-slides Skill

## Purpose

This skill guides Claude in building beautiful, self-contained HTML/CSS presentation slide decks. When a user asks you to create slides, a presentation, or a slide deck, follow this skill to produce polished, professional output.

## Workflow Overview

1. **Understand the request** — Identify topic, audience, tone, and number of slides. If unspecified, default to 8–12 slides.
2. **Choose a style preset** — Read `STYLE_PRESETS.md` and select or blend a named preset based on the content's tone.
3. **Select a layout strategy** — Use the canonical boilerplate in `html-template.md` as your foundation.
4. **Apply animations** — Read `animation-patterns.md` and sprinkle appropriate entrance animations. Less is more; aim for 1–2 patterns per deck.
5. **Leverage bold templates** — If the deck needs high-impact slides (hero intro, stats, timeline, split layout), consult `bold-template-pack/index.md` and incorporate those templates as individual slides.
6. **Output** — Produce a **single self-contained HTML file**. All CSS, JS, and assets must be inline. No external dependencies except optional Google Fonts (loaded via `<link>` with a CORS-safe fallback stack).

## File Reference Map

| File | When to read |
|------|-------------|
| `STYLE_PRESETS.md` | Always — pick a preset before writing any CSS |
| `viewport-base.css` | Always — copy its patterns verbatim into the `<style>` block |
| `html-template.md` | Always — use the canonical boilerplate as your HTML skeleton |
| `animation-patterns.md` | When slides need entrance effects or animated counters |
| `bold-template-pack/index.md` | When the deck needs high-impact visual slides |
| `bold-template-pack/hero.html` | For opening title slides with full-bleed impact |
| `bold-template-pack/split.html` | For comparison or feature callout slides |
| `bold-template-pack/stats.html` | For KPI, metrics, or data-highlight slides |
| `bold-template-pack/timeline.html` | For process, roadmap, or history slides |

## Output Conventions

- **One file per deck.** Name it `<topic>-slides.html` unless the user specifies otherwise.
- **Self-contained.** No `<link>` to local files. Fonts may use Google Fonts CDN.
- **16:9 aspect ratio** enforced via the viewport-base patterns. Never use fixed pixel heights that break on different screen sizes.
- **Keyboard navigation** — arrow keys (← →), Space to advance, must always work. Use the JS from `html-template.md`.
- **Nav dots** — always include the dot indicator for slide position.
- **Slide count** — display current/total in corner (e.g., `3 / 10`).
- **Print/PDF friendly** — each `.slide` should be a CSS `@page` break candidate.

## Responsive Viewport Sizing

All sizing must use the patterns from `viewport-base.css`:

- The `.slides-wrapper` uses `aspect-ratio: 16 / 9` and `width: 100vw` constrained by `max-height: 100vh`.
- Font sizes use `clamp()` — never hardcode `px` for text.
- The `--slide-unit` custom property (1% of slide width) enables proportional sizing within slides.
- On mobile the deck stacks vertically and each slide shrinks to fit the viewport width.

## Style Preset Application

After reading `STYLE_PRESETS.md`, apply the chosen preset by setting CSS custom properties in `:root`. You can override individual properties per slide using inline `style=""` attributes or per-slide classes.

Example applying the "dark" preset:
```html
<style>
  :root {
    --bg: #0f0f13;
    --fg: #f0f0f0;
    --accent: #7c3aed;
    --font-heading: 'Inter', sans-serif;
    --font-body: 'Inter', sans-serif;
  }
</style>
```

## Animation Application

Read `animation-patterns.md` before adding any animations. Apply animations by:
1. Adding the animation class to the element (e.g., `class="fade-in"`)
2. Using `animation-delay` with CSS variables to stagger children
3. Triggering animations only on the active slide using the `.active` class selector

Pattern: ``.slide.active .fade-in { animation: fadeIn 0.5s ease forwards; }``

## Quality Checklist

Before finalizing output, verify:
- [ ] Style preset applied via CSS custom properties
- [ ] `viewport-base.css` patterns included (aspect ratio, clamp fonts, slide unit)
- [ ] Keyboard nav (←→ Space) working
- [ ] Nav dots present and functional
- [ ] Slide counter displayed
- [ ] All content visible without scrolling on a 1280×720 viewport
- [ ] No external local file references
- [ ] Animations only trigger on the active slide
- [ ] At least one bold-template-pack slide used if the deck has >5 slides
