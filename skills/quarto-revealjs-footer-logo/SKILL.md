---
name: quarto-revealjs-footer-logo
description: Add footer text and logo to Quarto Reveal.js presentations. Use when user wants branding, copyright notices, or persistent footer across slides.
---

# Quarto Reveal.js Footer & Logo

Add persistent branding and footer text to presentations.

## When to Use

- Adding company/organization logo
- Including copyright or attribution
- Creating branded presentations
- Adding persistent navigation aids

## Basic Usage

**YAML Configuration:**

```yaml
---
title: "My Presentation"
format:
  revealjs:
    logo: images/logo.png
    footer: "© 2024 My Company"
---
```

## Logo Options

```yaml
format:
  revealjs:
    logo: logo.png # Path to logo image
```

Logo appears in bottom-right corner by default.

## Footer Options

**Simple Text:**

```yaml
format:
  revealjs:
    footer: "Conference Name 2024"
```

**With HTML:**

```yaml
format:
  revealjs:
    footer: "<a href='https://example.com'>My Website</a>"
```

## Per-Slide Control

**Remove Footer from Slide:**

```markdown
## Special Slide {footer=false}

This slide has no footer.
```

**Custom Footer for Slide:**

```markdown
## Slide Title

Content here.

::: footer
Custom footer for this slide only
:::
```

## Title Slide Configuration

```yaml
format:
  revealjs:
    title-slide-attributes:
      data-footer: "" # Remove footer from title slide
```

## Examples

**Corporate Branding:**

```yaml
---
title: "Q4 Report"
format:
  revealjs:
    logo: assets/company-logo.png
    footer: "Confidential - Internal Use Only"
---
```

**Conference Presentation:**

```yaml
---
title: "Research Findings"
author: "Dr. Smith"
format:
  revealjs:
    logo: conference-logo.svg
    footer: "ACM Conference 2024"
---
```

**Mixed Footer Usage:**

```markdown
---
format:
  revealjs:
    footer: "Default footer text"
---

## Normal Slide

Uses default footer.

## No Footer Slide {footer=false}

Footer hidden here.

## Custom Footer Slide

::: footer
Special attribution for this slide
:::
```

## Styling

Custom SCSS for footer/logo:

```scss
.reveal .slide-footer {
  font-size: 0.5em;
  color: #666;
}

.reveal .slide-logo {
  max-height: 50px;
}
```

## Reference

- [Quarto Reveal.js Footer & Logo](https://quarto.org/docs/presentations/revealjs/#footer-logo)
