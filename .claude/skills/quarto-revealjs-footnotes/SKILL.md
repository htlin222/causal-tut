---
name: quarto-revealjs-footnotes
description: Add asides and footnotes in Quarto Reveal.js slides. Use when user wants to add peripheral content, citations, or supplementary notes to slides.
---

# Quarto Reveal.js Asides & Footnotes

Add peripheral content and citations to slides.

## When to Use

- Adding supplementary information
- Including citations or references
- Providing peripheral commentary
- Adding numbered footnotes

## Asides

Smaller text at bottom of slide for peripheral content.

```markdown
## Main Content

Primary information here.

::: aside
Additional commentary of more peripheral interest.
:::
```

## Footnotes

Numbered references with automatic formatting.

**Inline Footnote:**

```markdown
## Research Findings

The study found significant results^[p < 0.05, n=100].
```

**Reference-style Footnote:**

```markdown
## Key Points

This is supported by research[^1].

[^1]: Smith et al., 2023, Journal of Examples.
```

## Footnote Location

Control where footnotes appear:

```yaml
format:
  revealjs:
    reference-location: document # or: block, section, margin
```

Options:

- `document` - End of presentation
- `block` - End of current block
- `section` - End of current section
- `margin` - In the margin (if supported)

## Examples

**Citation Aside:**

```markdown
## Climate Data

Global temperatures have risen 1.1°C since pre-industrial times.

::: aside
Source: IPCC AR6, 2021
:::
```

**Multiple Footnotes:**

```markdown
## Literature Review

Theory A^[First proposed by Smith, 2010] contradicts
Theory B^[Developed by Jones, 2015].
```

**Combined Usage:**

```markdown
## Analysis Results

The correlation was significant^[r=0.85, p<0.001].

::: aside
Data collected from 2020-2023. Full methodology in appendix.
:::
```

## Styling

Asides and footnotes appear in smaller font automatically. Custom styling via SCSS:

```scss
.aside {
  font-size: 0.7em;
  color: #666;
}
```

## Reference

- [Quarto Reveal.js Asides](https://quarto.org/docs/presentations/revealjs/#asides-footnotes)
