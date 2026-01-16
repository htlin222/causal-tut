---
name: quarto-revealjs-theming
description: Create and customize Quarto Reveal.js themes with SCSS variables. Use when user wants to build custom themes, modify colors, fonts, or create branded presentations.
---

# Quarto Reveal.js Theming

Complete guide to creating and customizing presentation themes.

## When to Use

- Creating custom branded themes
- Modifying colors, fonts, spacing
- Building reusable theme files
- Understanding SCSS variables

## Built-in Themes

11 themes available: `beige`, `blood`, `dark`, `default`, `dracula`, `league`, `moon`, `night`, `serif`, `simple`, `sky`, `solarized`

## Theme Layering

Later themes override earlier ones:

```yaml
format:
  revealjs:
    theme: [default, custom.scss]
```

## Custom Theme Structure

Create `custom.scss` with two sections:

```scss
/*-- scss:defaults --*/
// Variables go here (prefixed with $)
$body-bg: #191919;
$link-color: #42affa;

/*-- scss:rules --*/
// CSS rules go here
.reveal .slide {
  font-weight: 300;
}
```

## SCSS Variables Reference

### Colors

| Variable            | Default                   | Description          |
| ------------------- | ------------------------- | -------------------- |
| `$body-bg`          | #fff                      | Background color     |
| `$body-color`       | #222                      | Text color           |
| `$text-muted`       | lighten($body-color, 50%) | Muted text           |
| `$link-color`       | #2a76dd                   | Link color           |
| `$link-color-hover` | lighten($link-color, 15%) | Link hover           |
| `$selection-bg`     | lighten($link-color, 25%) | Selection background |
| `$selection-color`  | $body-bg                  | Selection text       |

### Light/Dark Background Adaptations

| Variable               | Default | Description                |
| ---------------------- | ------- | -------------------------- |
| `$light-bg-text-color` | #222    | Text on light backgrounds  |
| `$light-bg-link-color` | #2a76dd | Links on light backgrounds |
| `$light-bg-code-color` | #4758ab | Code on light backgrounds  |
| `$dark-bg-text-color`  | #fff    | Text on dark backgrounds   |
| `$dark-bg-link-color`  | #42affa | Links on dark backgrounds  |
| `$dark-bg-code-color`  | #ffa07a | Code on dark backgrounds   |

### Fonts

| Variable                       | Default                                  |
| ------------------------------ | ---------------------------------------- |
| `$font-family-sans-serif`      | "Source Sans Pro", Helvetica, sans-serif |
| `$font-family-monospace`       | monospace                                |
| `$presentation-font-size-root` | 40px                                     |
| `$presentation-font-smaller`   | 0.7                                      |
| `$presentation-line-height`    | 1.3                                      |

### Headings

| Variable                               | Default                 |
| -------------------------------------- | ----------------------- |
| `$presentation-heading-font`           | $font-family-sans-serif |
| `$presentation-heading-color`          | $body-color             |
| `$presentation-heading-line-height`    | 1.2                     |
| `$presentation-heading-letter-spacing` | normal                  |
| `$presentation-heading-text-transform` | none                    |
| `$presentation-heading-text-shadow`    | none                    |
| `$presentation-heading-font-weight`    | 600                     |
| `$presentation-h1-font-size`           | 2.5em                   |
| `$presentation-h2-font-size`           | 1.6em                   |
| `$presentation-h3-font-size`           | 1.3em                   |
| `$presentation-h4-font-size`           | 1em                     |
| `$presentation-h1-text-shadow`         | none                    |

### Code Blocks

| Variable                   | Default                   |
| -------------------------- | ------------------------- |
| `$code-block-bg`           | $body-bg                  |
| `$code-block-border-color` | lighten($body-color, 60%) |
| `$code-block-font-size`    | 0.55em                    |
| `$code-color`              | var(--quarto-hl-fu-color) |
| `$code-bg`                 | transparent               |

### Layout

| Variable                               | Default                   |
| -------------------------------------- | ------------------------- |
| `$border-color`                        | lighten($body-color, 30%) |
| `$border-width`                        | 1px                       |
| `$border-radius`                       | 3px                       |
| `$presentation-block-margin`           | 12px                      |
| `$presentation-slide-text-align`       | left                      |
| `$presentation-title-slide-text-align` | center                    |
| `$tabset-border-color`                 | $code-block-border-color  |

### Callouts

| Variable                   | Default |
| -------------------------- | ------- |
| `$callout-border-width`    | 0.3rem  |
| `$callout-margin-top`      | 1rem    |
| `$callout-margin-bottom`   | 1rem    |
| `$callout-color-note`      | #0d6efd |
| `$callout-color-tip`       | #198754 |
| `$callout-color-caution`   | #fd7e14 |
| `$callout-color-warning`   | #ffc107 |
| `$callout-color-important` | #dc3545 |

## Examples

**Corporate Theme:**

```scss
/*-- scss:defaults --*/
$body-bg: #ffffff;
$body-color: #333333;
$link-color: #0066cc;
$presentation-heading-color: #003366;
$presentation-heading-font: "Arial", sans-serif;
$font-family-sans-serif: "Arial", sans-serif;

/*-- scss:rules --*/
.reveal .slide-number {
  color: #0066cc;
}
```

**Dark Mode Theme:**

```scss
/*-- scss:defaults --*/
$body-bg: #1a1a2e;
$body-color: #eaeaea;
$link-color: #00d9ff;
$link-color-hover: #00ffff;
$code-block-bg: #16213e;
$presentation-heading-color: #00d9ff;

/*-- scss:rules --*/
.reveal code {
  background: rgba(0, 217, 255, 0.1);
  padding: 0.2em 0.4em;
  border-radius: 4px;
}
```

**Academic Theme:**

```scss
/*-- scss:defaults --*/
$font-family-sans-serif: "Palatino", "Georgia", serif;
$presentation-heading-font: "Palatino", serif;
$presentation-font-size-root: 36px;
$body-bg: #fefefe;
$body-color: #2c2c2c;
$link-color: #8b0000;
```

## Creating Distributable Themes

Use `!default` to allow overrides:

```scss
/*-- scss:defaults --*/
$body-bg: #f0f1eb !default;
$body-color: #2d2d2d !default;
$link-color: #4a90d9 !default;
```

## Usage

```yaml
---
title: "Branded Presentation"
format:
  revealjs:
    theme: [default, brand-theme.scss]
---
```

## Reference

- [Quarto Reveal.js Themes](https://quarto.org/docs/presentations/revealjs/themes.html)
- [Built-in Theme Source](https://github.com/quarto-dev/quarto-cli/tree/main/src/resources/formats/revealjs/themes)
