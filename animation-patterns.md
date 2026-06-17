# Animation Patterns

Reusable CSS and JS animation patterns for slide decks. Apply these to elements inside `.slide` elements. **All CSS animations should only trigger on `.slide.active` to prevent off-screen slides from animating.**

---

## 1. fade-in

**Description:** Element fades from transparent to opaque. The simplest, most versatile entrance. Use on any element.

**CSS:**
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.fade-in {
  opacity: 0;
  animation: none;
}

.slide.active .fade-in {
  animation: fadeIn 0.5s ease forwards;
}
```

**Usage:**
```html
<h2 class="fade-in">Hello World</h2>
<p class="fade-in" style="animation-delay: 0.2s;">Supporting text</p>
```

**Note:** Combine with `animation-delay` to sequence multiple elements. Keep delays short (0.1–0.3s apart) to feel snappy rather than slow.

---

## 2. slide-up

**Description:** Element slides upward from a slight offset while fading in. Great for body copy, bullet lists, and cards entering after a headline.

**CSS:**
```css
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.slide-up {
  opacity: 0;
  animation: none;
}

.slide.active .slide-up {
  animation: slideUp 0.45s cubic-bezier(0.22, 1, 0.36, 1) forwards;
}
```

**Usage:**
```html
<h1 class="slide-up">Headline</h1>
<div class="card slide-up" style="animation-delay: 0.15s;">Card content</div>
```

**Note:** The `cubic-bezier(0.22, 1, 0.36, 1)` easing (ease-out-expo) feels quick and physical. Avoid using this on more than 3–4 elements per slide.

---

## 3. stagger-children

**Description:** Automatically staggers the entrance animation of direct children. Applied to the parent container. Each child gets an incrementally longer delay via CSS custom property `--i`.

**CSS:**
```css
@keyframes staggerFadeUp {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.stagger-children > * {
  opacity: 0;
  animation: none;
}

.slide.active .stagger-children > * {
  animation: staggerFadeUp 0.4s cubic-bezier(0.22, 1, 0.36, 1) forwards;
  animation-delay: calc(var(--i, 0) * 0.1s + 0.05s);
}

/* Assign --i to each child */
.stagger-children > *:nth-child(1)  { --i: 0; }
.stagger-children > *:nth-child(2)  { --i: 1; }
.stagger-children > *:nth-child(3)  { --i: 2; }
.stagger-children > *:nth-child(4)  { --i: 3; }
.stagger-children > *:nth-child(5)  { --i: 4; }
.stagger-children > *:nth-child(6)  { --i: 5; }
```

**Usage:**
```html
<ul class="clean stagger-children">
  <li>First item</li>
  <li>Second item</li>
  <li>Third item</li>
</ul>

<!-- Or with cards -->
<div class="cols-3 stagger-children">
  <div class="card">...</div>
  <div class="card">...</div>
  <div class="card">...</div>
</div>
```

**Note:** Works best on 3–6 children. More than 6 children at 0.1s apart starts to feel sluggish.

---

## 4. typewriter

**Description:** Text appears character-by-character, as if being typed. Best for short strings: headlines, code snippets, CLI commands, quotes.

**CSS + JS:**
```css
.typewriter {
  display: inline-block;
  overflow: hidden;
  white-space: nowrap;
  width: 0;
  animation: none;
}

.typewriter::after {
  content: '|';
  display: inline-block;
  animation: blink 0.7s step-end infinite;
}

@keyframes typeReveal {
  from { width: 0; }
  to   { width: 100%; }
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0; }
}

.slide.active .typewriter {
  animation: typeReveal 1.2s steps(30, end) forwards;
}

/* Hide cursor after typing completes */
.slide.active .typewriter::after {
  animation: blink 0.7s step-end 3;
  animation-fill-mode: forwards;
}
```

**Usage:**
```html
<h2 class="typewriter">Build fast. Ship faster.</h2>

<!-- For code snippets -->
<code class="typewriter" style="--chars: 24">$ npm run deploy</code>
```

**Note:** The `steps()` count should roughly match the character count of the text. For variable-length strings, use the JS variant below:

```html
<span id="typed-text" data-text="Hello, World!"></span>
<script>
(function() {
  const el = document.getElementById('typed-text');
  const text = el.dataset.text;
  let i = 0;
  function type() {
    if (i <= text.length) {
      el.textContent = text.slice(0, i) + (i < text.length ? '|' : '');
      i++;
      setTimeout(type, 60);
    }
  }
  // Trigger when slide becomes active
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(m) {
      if (m.target.classList.contains('active')) { i = 0; type(); }
    });
  });
  observer.observe(el.closest('.slide'), { attributes: true, attributeFilter: ['class'] });
})();
</script>
```

---

## 5. blur-in

**Description:** Element transitions from blurred and scaled-down to sharp and full size. Creates a dramatic "focus pull" effect. Best for hero images, large stats, or accent words.

**CSS:**
```css
@keyframes blurIn {
  from {
    opacity: 0;
    filter: blur(12px);
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    filter: blur(0);
    transform: scale(1);
  }
}

.blur-in {
  opacity: 0;
  animation: none;
}

.slide.active .blur-in {
  animation: blurIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
```

**Usage:**
```html
<p class="text-display accent blur-in">$4.2B</p>
<img src="..." class="blur-in" style="animation-delay: 0.2s;" alt="...">
```

**Note:** `filter: blur()` can be GPU-intensive. Use on at most 1–2 elements per slide. Avoid on slides with many animated children.

---

## 6. count-up (JS)

**Description:** Animates a numeric value from 0 (or a start value) to its target number. Ideal for KPI slides, stat callouts, and metrics. Uses `requestAnimationFrame` for smoothness.

**JS:**
```javascript
/**
 * countUp — animates a number from `start` to `end` over `duration` ms.
 * @param {HTMLElement} el      - The element whose textContent gets the number
 * @param {number}      start   - Start value (default 0)
 * @param {number}      end     - Target value (read from data-count attribute)
 * @param {number}      duration - Animation duration in ms (default 1500)
 * @param {string}      prefix  - Optional prefix, e.g. "$"
 * @param {string}      suffix  - Optional suffix, e.g. "%"
 */
function countUp(el, start, end, duration, prefix, suffix) {
  start    = start    || 0;
  duration = duration || 1500;
  prefix   = prefix   || '';
  suffix   = suffix   || '';

  var startTime = null;

  function easeOut(t) { return 1 - Math.pow(1 - t, 3); } /* ease-out-cubic */

  function step(timestamp) {
    if (!startTime) startTime = timestamp;
    var elapsed  = timestamp - startTime;
    var progress = Math.min(elapsed / duration, 1);
    var value    = Math.round(start + (end - start) * easeOut(progress));
    el.textContent = prefix + value.toLocaleString() + suffix;
    if (progress < 1) requestAnimationFrame(step);
  }

  requestAnimationFrame(step);
}

/* Auto-initialize all [data-count] elements when their slide becomes active */
document.querySelectorAll('[data-count]').forEach(function(el) {
  var slide = el.closest('.slide');
  if (!slide) return;

  var triggered = false;

  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(m) {
      if (m.target.classList.contains('active') && !triggered) {
        triggered = true;
        countUp(
          el,
          parseInt(el.dataset.countFrom  || '0',  10),
          parseInt(el.dataset.count,               10),
          parseInt(el.dataset.countDuration || '1500', 10),
          el.dataset.countPrefix || '',
          el.dataset.countSuffix || ''
        );
      }
      if (!m.target.classList.contains('active')) {
        triggered = false; /* reset so it re-animates if user returns */
      }
    });
  });

  observer.observe(slide, { attributes: true, attributeFilter: ['class'] });
});
```

**HTML Usage:**
```html
<!-- Basic number -->
<span class="text-display accent"
      data-count="2847"
      data-count-duration="1200">0</span>

<!-- With prefix and suffix -->
<span class="text-display accent"
      data-count="98"
      data-count-suffix="%"
      data-count-duration="1000">0%</span>

<!-- Currency -->
<span class="text-display accent"
      data-count="4200000"
      data-count-prefix="$"
      data-count-duration="2000">$0</span>

<!-- Starting from a non-zero value -->
<span class="text-display accent"
      data-count="500"
      data-count-from="300"
      data-count-duration="800">300</span>
```

**Note:** Place the `countUp` script and initialization block in the main `<script>` tag at the bottom of the HTML, before the closing `</body>`. The observer resets `triggered` when the slide loses `.active`, so returning to the slide re-runs the animation.

---

## Combining Patterns

Patterns compose naturally. Example: stats card with blur-in number and staggered labels.

```html
<div class="cols-3 stagger-children">
  <div class="card centered">
    <p class="label">Monthly Users</p>
    <p class="text-display accent blur-in"
       data-count="125000"
       data-count-suffix="+"
       data-count-duration="1400">0</p>
  </div>
  <div class="card centered">
    <p class="label">Uptime</p>
    <p class="text-display accent blur-in" style="animation-delay:0.1s"
       data-count="99"
       data-count-suffix=".9%"
       data-count-duration="900">0</p>
  </div>
  <div class="card centered">
    <p class="label">NPS Score</p>
    <p class="text-display accent blur-in" style="animation-delay:0.2s"
       data-count="72"
       data-count-duration="1100">0</p>
  </div>
</div>
```

## Performance Guidelines

- Animate only `opacity`, `transform`, and `filter` — these are GPU-composited and do not cause layout reflow.
- Do **not** animate `width`, `height`, `top`, `left`, `margin`, or `padding` — these trigger layout and are janky.
- Keep total animated elements per slide to 6 or fewer.
- If a slide has `count-up`, avoid also having `typewriter` on the same slide (both are JS-driven and can compete).
