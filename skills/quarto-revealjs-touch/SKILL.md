---
name: quarto-revealjs-touch
description: Configure touch navigation in Quarto Reveal.js. Use when user needs to control swipe gestures on mobile/tablet devices.
---

# Quarto Reveal.js Touch Navigation

Control touch/swipe behavior on mobile devices.

## When to Use

- Presenting on touch devices
- Embedding in touch-enabled contexts
- Disabling accidental swipes
- Configuring mobile experience

## Default Behavior

Touch navigation is **enabled by default** on touch-capable devices.

Swipe gestures:

- Swipe left = next slide
- Swipe right = previous slide
- Swipe up/down = vertical navigation

## Disabling Touch

```yaml
format:
  revealjs:
    touch: false
```

When disabling touch, enable controls for navigation:

```yaml
format:
  revealjs:
    touch: false
    controls: true
```

## Full Configuration

```yaml
format:
  revealjs:
    touch: true # Enable touch navigation
    controls: true # Show navigation controls
    controls-layout: bottom-right
    controls-tutorial: true
```

## Examples

**Touch-Optimized:**

```yaml
---
title: "Mobile Presentation"
format:
  revealjs:
    touch: true
    controls: true
    controls-layout: edges
---
```

**Touch Disabled:**

```yaml
---
title: "Kiosk Display"
format:
  revealjs:
    touch: false
    controls: true
    controls-tutorial: true
---
```

**Embedded Widget:**

```yaml
---
title: "Embedded Slides"
format:
  revealjs:
    touch: false
    controls: true
    embedded: true
---
```

## Use Cases

**Disable touch when:**

- Slide has interactive elements (iframes, forms)
- Accidental swipes are problematic
- Kiosk/display mode
- Embedded in scrollable page

**Keep touch enabled when:**

- Primary device is mobile/tablet
- Audience uses touch devices
- Quick navigation is important

## Best Practices

- Always provide alternative navigation when disabling touch
- Test on actual touch devices
- Consider audience device types
- Use `controls: true` as fallback

## Reference

- [Quarto Reveal.js Touch](https://quarto.org/docs/presentations/revealjs/advanced.html#touch-navigation)
