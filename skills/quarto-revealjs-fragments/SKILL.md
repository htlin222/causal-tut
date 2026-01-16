---
name: quarto-revealjs-fragments
description: Create incremental reveal animations in Quarto Reveal.js. Use when user wants content to appear step-by-step within a slide.
---

# Quarto Reveal.js Fragments

Reveal content incrementally within a slide.

## When to Use

- Step-by-step content reveal
- Building up diagrams/lists
- Emphasizing points sequentially
- Creating dramatic reveals

## Basic Syntax

Add `.fragment` class:

```markdown
## Incremental Points

::: {.fragment}
First point appears
:::

::: {.fragment}
Second point appears
:::

::: {.fragment}
Third point appears
:::
```

## Fragment Styles

| Class                      | Effect                      |
| -------------------------- | --------------------------- |
| `.fragment`                | Fade in (default)           |
| `.fade-out`                | Fade out                    |
| `.fade-up`                 | Slide up while fading in    |
| `.fade-down`               | Slide down while fading in  |
| `.fade-left`               | Slide left while fading in  |
| `.fade-right`              | Slide right while fading in |
| `.fade-in-then-out`        | Fade in, then out on next   |
| `.current-visible`         | Visible only when current   |
| `.grow`                    | Scale up                    |
| `.shrink`                  | Scale down                  |
| `.strike`                  | Strike-through              |
| `.highlight-red`           | Red highlight               |
| `.highlight-green`         | Green highlight             |
| `.highlight-blue`          | Blue highlight              |
| `.highlight-current-red`   | Red only when current       |
| `.highlight-current-green` | Green only when current     |
| `.highlight-current-blue`  | Blue only when current      |

## Usage Examples

**Fade In:**

```markdown
::: {.fragment .fade-in}
Appears with fade
:::
```

**Fade Up:**

```markdown
::: {.fragment .fade-up}
Slides up as it appears
:::
```

**Highlight:**

```markdown
::: {.fragment .highlight-red}
This text turns red
:::
```

**Strike-through:**

```markdown
::: {.fragment .strike}
~~Crossed out~~
:::
```

## Fragment Order

Control sequence with `fragment-index`:

```markdown
::: {.fragment fragment-index=2}
Appears second
:::

::: {.fragment fragment-index=1}
Appears first
:::

::: {.fragment fragment-index=2}
Also appears second (same index)
:::
```

## Nested Fragments

Apply multiple effects:

```markdown
::: {.fragment .fade-in}
::: {.fragment .highlight-red}
::: {.fragment .fade-out}
Appears, highlights, then disappears
:::
:::
:::
```

## Lists with Fragments

**Incremental list (built-in):**

```yaml
format:
  revealjs:
    incremental: true
```

**Per-slide incremental:**

```markdown
## Incremental List

::: {.incremental}

- First item
- Second item
- Third item
  :::
```

**Non-incremental override:**

```markdown
## Normal List

::: {.nonincremental}

- All at once
- All at once
  :::
```

## Complex Examples

**Before/After:**

```markdown
## Improvement

::: {.fragment .fade-out fragment-index=1}
Old approach (fades out)
:::

::: {.fragment .fade-in fragment-index=1}
New approach (fades in)
:::
```

**Sequential Highlights:**

```markdown
## Key Points

- [Point A]{.fragment .highlight-current-blue fragment-index=1}
- [Point B]{.fragment .highlight-current-blue fragment-index=2}
- [Point C]{.fragment .highlight-current-blue fragment-index=3}
```

**Build a Diagram:**

```markdown
## Architecture

::: {.r-stack}
![Base](base.png)

![Layer 1](layer1.png){.fragment}

![Layer 2](layer2.png){.fragment}

![Layer 3](layer3.png){.fragment}
:::
```

## Best Practices

- Use fragments purposefully, not excessively
- Match fragment style to content meaning
- Test timing for natural pacing
- Consider audience attention span
- Use `highlight-current-*` for focused attention

## Reference

- [Quarto Reveal.js Fragments](https://quarto.org/docs/presentations/revealjs/advanced.html#fragments)
