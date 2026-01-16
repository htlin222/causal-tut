---
name: quarto-revealjs-transitions
description: Configure slide transitions in Quarto Reveal.js presentations. Use when user wants animation effects between slides.
---

# Quarto Reveal.js Slide Transitions

Control how slides animate when navigating.

## When to Use

- Adding slide transition effects
- Setting transition speed
- Different transitions per slide
- Background transition effects

## Transition Types

| Type      | Effect              |
| --------- | ------------------- |
| `none`    | No transition       |
| `fade`    | Fade in/out         |
| `slide`   | Slide horizontally  |
| `convex`  | 3D convex rotation  |
| `concave` | 3D concave rotation |
| `zoom`    | Scale up/down       |

## Global Configuration

```yaml
format:
  revealjs:
    transition: slide
    transition-speed: default
    background-transition: fade
```

**Speed options:** `default`, `fast`, `slow`

## Per-Slide Transitions

```markdown
## Slide Title {transition="fade"}

Content here.
```

With speed:

```markdown
## Slide Title {transition="zoom" transition-speed="fast"}
```

## Separate In/Out Transitions

Different effects for entering vs leaving:

```markdown
## Slide Title {transition="fade-in slide-out"}
```

```markdown
## Slide Title {transition="convex-in concave-out"}
```

## Background Transitions

Transition background separately:

```yaml
format:
  revealjs:
    transition: slide
    background-transition: fade
```

## Examples

**Smooth Presentation:**

```yaml
format:
  revealjs:
    transition: fade
    transition-speed: slow
```

**Dynamic Entry:**

```markdown
## Big Reveal {transition="zoom-in fade-out"}

The main announcement.
```

**Mixed Styles:**

```markdown
---
format:
  revealjs:
    transition: slide
---

## Normal Slide

Uses default slide transition.

## Dramatic Slide {transition="zoom"}

Uses zoom for impact.

## Subtle Exit {transition="fade" transition-speed="slow"}

Gentle fade out.
```

**No Transition:**

```markdown
## Instant Change {transition="none"}

Appears immediately.
```

## Best Practices

- Use consistent transitions for professionalism
- Reserve dramatic transitions for emphasis
- `fade` is the most versatile
- Avoid overusing `convex`/`concave` (can cause motion sickness)
- Test transitions before presenting

## Reference

- [Quarto Reveal.js Transitions](https://quarto.org/docs/presentations/revealjs/advanced.html#slide-transitions)
