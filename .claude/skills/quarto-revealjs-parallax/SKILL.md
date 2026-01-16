---
name: quarto-revealjs-parallax
description: Add parallax scrolling backgrounds to Quarto Reveal.js. Use when user wants a moving background effect during slide navigation.
---

# Quarto Reveal.js Parallax Background

Create scrolling background effect during navigation.

## When to Use

- Adding depth to presentations
- Creative/artistic presentations
- Immersive storytelling
- Visual interest during transitions

## Basic Configuration

```yaml
format:
  revealjs:
    parallax-background-image: background.png
    parallax-background-size: "2100px 900px"
```

## Options

| Option                           | Description                   |
| -------------------------------- | ----------------------------- |
| `parallax-background-image`      | Image path/URL                |
| `parallax-background-size`       | Image dimensions              |
| `parallax-background-horizontal` | Horizontal scroll amount (px) |
| `parallax-background-vertical`   | Vertical scroll amount (px)   |

## Configuration Examples

**Basic Parallax:**

```yaml
---
title: "My Presentation"
format:
  revealjs:
    parallax-background-image: images/stars.jpg
    parallax-background-size: "3000px 2000px"
---
```

**With Scroll Amount:**

```yaml
format:
  revealjs:
    parallax-background-image: landscape.png
    parallax-background-size: "4000px 1000px"
    parallax-background-horizontal: 200
    parallax-background-vertical: 50
```

**Subtle Movement:**

```yaml
format:
  revealjs:
    parallax-background-image: texture.png
    parallax-background-size: "2000px 1500px"
    parallax-background-horizontal: 100
    parallax-background-vertical: 0
```

## Image Requirements

- Image should be larger than presentation canvas
- Recommended: 2-3x slide dimensions
- Seamless/tileable images work best
- Consider file size for performance

## Good Image Types

- Star fields
- Gradients
- Abstract textures
- Landscape panoramas
- Blurred backgrounds

## Examples

**Space Theme:**

```yaml
---
title: "Exploring the Universe"
format:
  revealjs:
    parallax-background-image: https://example.com/stars.jpg
    parallax-background-size: "4000px 3000px"
    parallax-background-horizontal: 300
    parallax-background-vertical: 150
---
```

**Subtle Texture:**

```yaml
---
title: "Professional Report"
format:
  revealjs:
    parallax-background-image: paper-texture.png
    parallax-background-size: "2500px 2000px"
    parallax-background-horizontal: 50
    parallax-background-vertical: 25
---
```

**Horizontal Only:**

```yaml
---
title: "Journey"
format:
  revealjs:
    parallax-background-image: road.jpg
    parallax-background-size: "5000px 1080px"
    parallax-background-horizontal: 400
    parallax-background-vertical: 0
---
```

## Best Practices

- Use subtle movement (100-200px) for professional presentations
- Larger movement for creative/artistic presentations
- Ensure adequate contrast with slide content
- Test on target display device
- Consider motion sensitivity of audience
- Use compressed images for performance

## Combining with Slide Backgrounds

Parallax works as base layer. Individual slides can override:

```markdown
## Special Slide {background-color="rgba(0,0,0,0.8)"}

Dark overlay on parallax background.
```

## Reference

- [Quarto Reveal.js Parallax](https://quarto.org/docs/presentations/revealjs/advanced.html#parallax-background)
