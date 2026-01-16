---
name: quarto-revealjs-themes
description: Apply themes to Quarto Reveal.js presentations. Use when user wants to change presentation appearance, colors, or styling.
---

# Quarto Reveal.js Themes

Apply visual themes to your presentation.

## When to Use

- Changing presentation appearance
- Selecting color schemes
- Styling slides consistently
- Creating branded presentations

## Built-in Themes

12 themes available:

| Theme       | Description              |
| ----------- | ------------------------ |
| `default`   | Clean, neutral           |
| `beige`     | Warm, tan background     |
| `blood`     | Dark red, dramatic       |
| `dark`      | Dark background          |
| `dracula`   | Purple-tinted dark       |
| `league`    | Gray gradient            |
| `moon`      | Dark blue                |
| `night`     | Black background         |
| `serif`     | Traditional, serif fonts |
| `simple`    | White, minimal           |
| `sky`       | Light blue               |
| `solarized` | Solarized color scheme   |

## Usage

**Single Theme:**

```yaml
---
title: "My Presentation"
format:
  revealjs:
    theme: dark
---
```

**Custom Theme File:**

```yaml
format:
  revealjs:
    theme: custom.scss
```

**Theme + Customizations:**

```yaml
format:
  revealjs:
    theme: [dark, custom.scss]
```

## Custom SCSS

Create `custom.scss`:

```scss
/*-- scss:defaults --*/
$body-bg: #191919;
$body-color: #fff;
$link-color: #42affa;

/*-- scss:rules --*/
.reveal .slide-background {
  background-color: $body-bg;
}
```

## Examples

**Dark Professional:**

```yaml
format:
  revealjs:
    theme: dark
```

**Light Academic:**

```yaml
format:
  revealjs:
    theme: serif
```

**Layered Customization:**

```yaml
format:
  revealjs:
    theme:
      - moon
      - styles/brand.scss
```

## Theme Variables

Common SCSS variables:

- `$body-bg` - Background color
- `$body-color` - Text color
- `$link-color` - Link color
- `$font-family-sans-serif` - Main font
- `$presentation-heading-font` - Heading font
- `$presentation-heading-color` - Heading color

## Reference

- [Quarto Reveal.js Themes](https://quarto.org/docs/presentations/revealjs/themes.html)
