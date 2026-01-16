---
name: quarto-revealjs-size
description: Configure presentation canvas size and scaling in Quarto Reveal.js. Use when user needs custom slide dimensions or scaling behavior.
---

# Quarto Reveal.js Presentation Size

Control slide dimensions and scaling.

## When to Use

- Custom slide aspect ratios
- Specific display dimensions
- Controlling content scaling
- Adjusting margins

## Configuration Options

| Option      | Default | Description              |
| ----------- | ------- | ------------------------ |
| `width`     | 1050    | Slide width in pixels    |
| `height`    | 700     | Slide height in pixels   |
| `margin`    | 0.1     | Empty space factor (0-1) |
| `min-scale` | 0.2     | Minimum content scale    |
| `max-scale` | 2.0     | Maximum content scale    |

## Basic Usage

```yaml
format:
  revealjs:
    width: 1920
    height: 1080
```

## Common Aspect Ratios

**16:9 (Widescreen):**

```yaml
format:
  revealjs:
    width: 1920
    height: 1080
```

**4:3 (Traditional):**

```yaml
format:
  revealjs:
    width: 1024
    height: 768
```

**16:10:**

```yaml
format:
  revealjs:
    width: 1680
    height: 1050
```

## Margin Control

Adjust empty space around content:

```yaml
format:
  revealjs:
    margin: 0.1 # 10% margin (default)
```

Smaller margin = more content space:

```yaml
format:
  revealjs:
    margin: 0.04 # 4% margin, more content area
```

## Scaling Limits

Control how much content can scale:

```yaml
format:
  revealjs:
    min-scale: 0.2 # Allow shrink to 20%
    max-scale: 2.0 # Allow grow to 200%
```

For fixed-size presentations:

```yaml
format:
  revealjs:
    min-scale: 1.0
    max-scale: 1.0
```

## Examples

**HD Presentation:**

```yaml
---
title: "HD Slides"
format:
  revealjs:
    width: 1920
    height: 1080
    margin: 0.05
---
```

**Compact for Embedding:**

```yaml
---
title: "Embedded Deck"
format:
  revealjs:
    width: 800
    height: 600
    min-scale: 0.5
    max-scale: 1.5
---
```

**Print-Friendly 4:3:**

```yaml
---
title: "Printable Slides"
format:
  revealjs:
    width: 1024
    height: 768
    margin: 0.1
---
```

## Best Practices

- Use 16:9 for modern displays
- Match target projector/screen resolution
- Larger dimensions = sharper text when scaled down
- Test scaling on actual display device

## Reference

- [Quarto Reveal.js Size](https://quarto.org/docs/presentations/revealjs/advanced.html#presentation-size)
