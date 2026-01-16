---
name: quarto-revealjs-vertical-slides
description: Create vertical slide stacks in Quarto Reveal.js. Use when user wants hierarchical slide navigation or optional deep-dive content.
---

# Quarto Reveal.js Vertical Slides

Create two-dimensional slide navigation.

## When to Use

- Hierarchical content structure
- Optional deep-dive content
- Supplementary materials
- Topic branches

## Navigation Modes

```yaml
format:
  revealjs:
    navigation-mode: vertical # or linear, grid
```

| Mode       | Behavior                                               |
| ---------- | ------------------------------------------------------ |
| `linear`   | Left/right traverse all slides                         |
| `vertical` | Arrows navigate within levels; space steps through all |
| `grid`     | Maintains vertical position when moving horizontally   |

## Creating Vertical Slides

Use heading levels:

- Level 1 (`#`) = horizontal (main) slides
- Level 2 (`##`) = vertical (sub) slides

```markdown
# Topic 1

## Main Point

Content here.

## Details

More depth.

## Examples

Even more.

# Topic 2

## Different Topic

New branch.
```

## Navigation Controls

```yaml
format:
  revealjs:
    controls: true
    controls-layout: bottom-right
    controls-tutorial: true
```

**Layout options:** `bottom-right`, `edges`

**Controls tutorial:** Shows navigation hint on first slide.

## Examples

**Course Structure:**

```markdown
# Module 1: Introduction

## Learning Objectives

- Understand basics
- Apply concepts

## Key Concepts

Definitions and theory.

## Quiz

Test your knowledge.

# Module 2: Advanced Topics

## Deep Dive

Advanced content.
```

**Main + Backup:**

```markdown
# Key Findings

## Summary

Main results.

## Methodology {visibility="uncounted"}

Optional details.

## Raw Data {visibility="uncounted"}

For the curious.

# Conclusions

## Takeaways

Final thoughts.
```

**Branching Topics:**

```markdown
# Overview

## Agenda

Today's topics.

# Option A: Traditional Approach

## How It Works

Traditional method.

## Pros and Cons

Analysis.

# Option B: Modern Approach

## How It Works

New method.

## Pros and Cons

Analysis.
```

## Navigation Hints

Add visual indicator for vertical content:

```yaml
format:
  revealjs:
    controls: true
    controls-tutorial: true
```

## Warning

> Users often skip vertical content because they don't know it's there.

Mitigations:

- Use `controls-tutorial: true`
- Mention vertical slides verbally
- Use for truly optional content
- Consider keeping main content horizontal

## Best Practices

- Keep main narrative horizontal
- Use vertical for supplementary content
- Limit vertical depth (2-3 slides max)
- Always enable navigation controls
- Test navigation flow before presenting

## Disabling Controls

```yaml
format:
  revealjs:
    controls: false
```

Note: Keyboard navigation still works.

## Reference

- [Quarto Reveal.js Vertical Slides](https://quarto.org/docs/presentations/revealjs/advanced.html#vertical-slides)
