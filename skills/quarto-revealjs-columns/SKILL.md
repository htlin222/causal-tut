---
name: quarto-revealjs-columns
description: Create multi-column layouts in Quarto Reveal.js slides. Use when user wants side-by-side content, comparing items, or arranging content in columns.
---

# Quarto Reveal.js Multiple Columns

Create side-by-side column layouts in Reveal.js presentations.

## When to Use

- User wants side-by-side content on a slide
- Comparing two or more items visually
- Creating image + text layouts
- Any multi-column arrangement in Quarto presentations

## Syntax

```markdown
:::: {.columns}

::: {.column width="40%"}
Left column content
:::

::: {.column width="60%"}
Right column content
:::

::::
```

## Key Points

- Use `::::` for outer `.columns` container
- Use `:::` for inner `.column` divs
- Specify `width` as percentage (must total 100% or less)
- Can have 2+ columns
- Works with any content: text, images, code, lists

## Examples

**Two Equal Columns:**

```markdown
:::: {.columns}

::: {.column width="50%"}

### Feature A

- Point 1
- Point 2
  :::

::: {.column width="50%"}

### Feature B

- Point 1
- Point 2
  :::

::::
```

**Image + Text:**

```markdown
:::: {.columns}

::: {.column width="40%"}
![](image.png)
:::

::: {.column width="60%"}
Description of the image goes here with detailed explanation.
:::

::::
```

**Three Columns:**

```markdown
:::: {.columns}

::: {.column width="33%"}
Column 1
:::

::: {.column width="34%"}
Column 2
:::

::: {.column width="33%"}
Column 3
:::

::::
```

## Reference

- [Quarto Reveal.js Columns](https://quarto.org/docs/presentations/revealjs/#multiple-columns)
