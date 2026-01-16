---
name: quarto-revealjs-title-slide
description: Customize Quarto Reveal.js title slides with backgrounds, templates, and centering. Use when user wants to style the opening slide of a presentation.
---

# Quarto Reveal.js Title Slide

Customize the appearance and layout of title slides.

## When to Use

- Adding background image to title slide
- Customizing title slide template
- Controlling title slide centering
- Styling author/affiliation display

## Custom Background

Use `title-slide-attributes` with `data-` prefixed options:

```yaml
---
title: "My Presentation"
author: "Jane Smith"
format:
  revealjs:
    title-slide-attributes:
      data-background-image: "hero.jpg"
      data-background-size: cover
      data-background-opacity: "0.5"
---
```

Available background options:

- `data-background-image` - Image path
- `data-background-size` - `cover`, `contain`, pixel values
- `data-background-position` - `center`, `top`, etc.
- `data-background-opacity` - `0` to `1`
- `data-background-color` - Color value
- `data-background-gradient` - CSS gradient

## Centering Control

Disable title slide centering:

```yaml
format:
  revealjs:
    center-title-slide: false
```

Note: Setting `center: true` globally overrides this option.

## Custom Template

Create a custom title slide partial:

```yaml
format:
  revealjs:
    template-partials:
      - title-slide.html
```

Then create `title-slide.html` with custom HTML structure.

## Examples

**Hero Image Title:**

```yaml
---
title: "2024 Annual Report"
subtitle: "Building the Future"
author: "CEO Name"
format:
  revealjs:
    title-slide-attributes:
      data-background-image: "images/hero.jpg"
      data-background-size: cover
      data-background-opacity: "0.3"
---
```

**Gradient Background:**

```yaml
---
title: "Modern Presentation"
format:
  revealjs:
    title-slide-attributes:
      data-background-gradient: "linear-gradient(to right, #4facfe, #00f2fe)"
---
```

**Left-Aligned Title:**

```yaml
---
title: "Research Findings"
format:
  revealjs:
    center-title-slide: false
---
```

## Reference

- [Quarto Reveal.js Title Slide](https://quarto.org/docs/presentations/revealjs/advanced.html#title-slide)
