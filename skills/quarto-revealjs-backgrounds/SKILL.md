---
name: quarto-revealjs-backgrounds
description: Set slide backgrounds in Quarto Reveal.js presentations. Use when user wants custom backgrounds with colors, images, videos, gradients, or iframes.
---

# Quarto Reveal.js Slide Backgrounds

Create visually striking slides with custom backgrounds.

## When to Use

- Adding visual impact to slides
- Creating section dividers
- Using images/videos as backgrounds
- Embedding live web content

## Background Types

### 1. Color Background

```markdown
## Section Title {background-color="aquamarine"}

Content on colored background.
```

Common colors: `#hex`, `rgb()`, named colors

### 2. Gradient Background

```markdown
## Gradient Slide {background-gradient="linear-gradient(to bottom, #283b95, #17b2c3)"}

Text on gradient.
```

### 3. Image Background

```markdown
## Image Slide {background-image="url('image.jpg')"}

Content over image.
```

**With Options:**

```markdown
## Photo {background-image="photo.jpg" background-size="cover" background-position="center"}
```

Options:

- `background-size`: `cover`, `contain`, `100px`
- `background-position`: `center`, `top`, `bottom left`
- `background-repeat`: `no-repeat`, `repeat`
- `background-opacity`: `0` to `1`

### 4. Video Background

```markdown
## Video Slide {background-video="video.mp4" background-video-loop="true" background-video-muted="true"}
```

Options:

- `background-video-loop`: `true`/`false`
- `background-video-muted`: `true`/`false`

### 5. IFrame Background

```markdown
## Live Demo {background-iframe="https://example.com" background-interactive="true"}
```

`background-interactive="true"` allows clicking/scrolling the iframe.

## Background-Only Slides

Omit title for full-screen background:

```markdown
## {background-color="#000000"}

## {background-image="hero.jpg"}
```

## Title Slide Background

Use YAML with `data-` prefix:

```yaml
---
title: "My Presentation"
format:
  revealjs:
    title-slide-attributes:
      data-background-image: "hero.jpg"
      data-background-size: cover
      data-background-opacity: "0.5"
---
```

## Examples

**Section Divider:**

```markdown
## {background-color="#1a1a2e"}

# Part 2: Results
```

**Photo with Overlay Text:**

```markdown
## Our Team {background-image="team.jpg" background-opacity="0.3"}

Meet the people behind the project.
```

**Looping Video:**

```markdown
## {background-video="loop.mp4" background-video-loop="true" background-video-muted="true"}

# Welcome
```

**Interactive Demo:**

```markdown
## Live Dashboard {background-iframe="https://dashboard.example.com" background-interactive="true"}
```

**Gradient Section:**

```markdown
## {background-gradient="radial-gradient(circle, #667eea 0%, #764ba2 100%)"}

# Questions?
```

## Best Practices

- Use `background-opacity` for readability over images
- Ensure text contrast with background
- Test video file sizes for performance
- Use `background-interactive` sparingly

## Reference

- [Quarto Reveal.js Backgrounds](https://quarto.org/docs/presentations/revealjs/#slide-backgrounds)
