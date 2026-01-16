---
name: quarto-revealjs-layout
description: Use layout helper classes in Quarto Reveal.js. Use when user needs stacking, fit-text, centering, or stretching elements.
---

# Quarto Reveal.js Layout Helpers

Built-in classes for common layout patterns.

## When to Use

- Stacking elements for incremental reveal
- Auto-scaling text to fit
- Vertically centering content
- Stretching images to fill space

## Layout Classes

### Stack Layout (`.r-stack`)

Centers multiple elements vertically, typically with fragments:

```markdown
## Stacked Reveal

::: {.r-stack}
![](image1.png){.fragment}

![](image2.png){.fragment}

![](image3.png){.fragment}
:::
```

Elements appear in same position, revealing one by one.

### Fit Text (`.r-fit-text`)

Scales text to maximum size without overflow:

```markdown
## Big Statement

::: {.r-fit-text}
ONE WORD
:::
```

Perfect for:

- Impact statements
- Section headers
- Single-word slides

### Center (`.center`)

Vertically centers slide content:

```markdown
## Centered Slide {.center}

This content is vertically centered.
```

Note: Different from title slide centering.

### Stretch (`.r-stretch`)

Resizes element to fill remaining vertical space:

```markdown
## Full-Height Image

![](diagram.png){.r-stretch}

Caption below the image.
```

Auto-applied to single slide-level images. Disable with:

```yaml
format:
  revealjs:
    auto-stretch: false
```

## Examples

**Animated Stack:**

```markdown
## Evolution

::: {.r-stack}
![](v1.png){.fragment .fade-out fragment-index=1}

![](v2.png){.fragment .current-visible fragment-index=1}

![](v3.png){.fragment fragment-index=2}
:::
```

**Big Impact:**

```markdown
## {.center}

::: {.r-fit-text}
THANK YOU
:::
```

**Image with Caption:**

```markdown
## Architecture Diagram

![System Overview](architecture.png){.r-stretch}

Figure 1: High-level system architecture
```

**Centered Quote:**

```markdown
## {.center}

> "Design is not just what it looks like.
> Design is how it works."
>
> — Steve Jobs
```

**Combined Layout:**

```markdown
## Key Insight {.center}

::: {.r-fit-text}
10x
:::

Performance improvement achieved.
```

## Comparison

| Class         | Purpose          | Use Case         |
| ------------- | ---------------- | ---------------- |
| `.r-stack`    | Overlay elements | Animated reveals |
| `.r-fit-text` | Auto-size text   | Headlines        |
| `.center`     | Vertical center  | Quotes, emphasis |
| `.r-stretch`  | Fill space       | Images, diagrams |

## Best Practices

- Use `.r-fit-text` sparingly for impact
- Combine `.r-stack` with fragments
- `.r-stretch` works best with single images
- Test on different screen sizes

## Reference

- [Quarto Reveal.js Layout](https://quarto.org/docs/presentations/revealjs/advanced.html#layout-helpers)
