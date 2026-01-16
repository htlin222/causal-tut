---
name: quarto-revealjs-absolute
description: Position elements absolutely on Quarto Reveal.js slides. Use when user wants precise pixel-level control over element placement.
---

# Quarto Reveal.js Absolute Position

Place elements at exact positions on slides.

## When to Use

- Precise element placement
- Overlapping content
- Creative layouts
- Annotations on images
- Custom infographics

## Basic Syntax

Add `.absolute` class with position attributes:

```markdown
![](image.png){.absolute top=200 left=50 width="350" height="300"}
```

## Position Attributes

| Attribute | Description          |
| --------- | -------------------- |
| `top`     | Distance from top    |
| `bottom`  | Distance from bottom |
| `left`    | Distance from left   |
| `right`   | Distance from right  |
| `width`   | Element width        |
| `height`  | Element height       |

Values are in pixels if unitless. Can also use CSS units (`%`, `em`, etc.).

## Examples

**Image Positioning:**

```markdown
## Diagram

![](logo.png){.absolute top=50 right=50 width="100"}

Main slide content here.
```

**Multiple Positioned Elements:**

```markdown
## Infographic

![](icon1.png){.absolute top=100 left=100 width="80"}
![](icon2.png){.absolute top=100 left=300 width="80"}
![](icon3.png){.absolute top=100 left=500 width="80"}

[Label 1]{.absolute top=200 left=100}
[Label 2]{.absolute top=200 left=300}
[Label 3]{.absolute top=200 left=500}
```

**Text Overlay on Image:**

```markdown
## {background-image="photo.jpg"}

[Breaking News]{.absolute top=50 left=50 style="font-size: 2em; color: red;"}

[Story details here...]{.absolute bottom=100 left=50 right=50}
```

**Animated Positions with Fragments:**

```markdown
## Step by Step

::: {.absolute top=200 left=100 .fragment}
Step 1
:::

::: {.absolute top=200 left=300 .fragment}
Step 2
:::

::: {.absolute top=200 left=500 .fragment}
Step 3
:::
```

**Centered Element:**

```markdown
## Centered Box

::: {.absolute top=50% left=50% style="transform: translate(-50%, -50%);"}
Perfectly centered content
:::
```

## With Percentages

```markdown
![](diagram.png){.absolute top="10%" left="25%" width="50%"}
```

## Combining with Other Classes

```markdown
::: {.absolute top=100 left=100 .fragment .fade-in}
Appears with animation at specific position
:::
```

## Best Practices

- Use for creative layouts, not body text
- Test on different screen sizes
- Consider using percentages for responsive positioning
- Combine with `.fragment` for animations
- Document positions for maintenance

## Caveats

- Absolute positioning ignores normal document flow
- Elements may overlap unexpectedly
- Not responsive by default
- Consider `margin` setting impact

## Reference

- [Quarto Reveal.js Absolute Position](https://quarto.org/docs/presentations/revealjs/advanced.html#absolute-position)
