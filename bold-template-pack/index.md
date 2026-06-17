# Bold Template Pack

High-impact, standalone slide templates for use as individual slides within a deck or as standalone presentation pieces. Each template is a self-contained HTML file with inline CSS.

## Templates

| File | Name | Best Used For |
|------|------|---------------|
| `hero.html` | Hero Slide | Opening title slide with full-bleed gradient, massive headline, and CTA button — sets the tone for the entire deck |
| `split.html` | Split Layout | Side-by-side comparison, feature callout, or "problem vs. solution" slides with high contrast between halves |
| `stats.html` | Stats / KPIs | Showcasing 3 key metrics, numbers, or data points with animated count-up on a bold dark background |
| `timeline.html` | Horizontal Timeline | Process steps, product roadmap, company history, or any 4-step sequential narrative with a connecting progress line |

## Usage

1. Open the desired template HTML file.
2. Copy the inner `<div class="slide ...">` block (and any accompanying `<style>` or `<script>` it needs).
3. Paste it into your main deck HTML (built from `html-template.md`) as a new slide.
4. Update copy, colors, and data to match your deck's content and chosen preset.

## Customization Tips

- **Colors:** Each template uses CSS custom properties. Override `--bg`, `--accent`, and `--fg` via `style=""` on the root `.slide` div.
- **Fonts:** Templates default to system sans-serif stacks. Replace with your deck's `--font-heading` and `--font-body`.
- **Content:** All placeholder text is clearly marked with `[brackets]` or descriptive dummy copy. Swap it out.
- **Animations:** Templates include entrance animations scoped to `.slide.active`. They will work automatically when integrated into a deck using `html-template.md`'s navigation JS.
