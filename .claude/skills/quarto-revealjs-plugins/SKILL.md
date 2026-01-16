---
name: quarto-revealjs-plugins
description: Add Reveal.js plugins to Quarto presentations. Use when user wants to extend functionality with chalkboard, menu, multiplex, or custom plugins.
---

# Quarto Reveal.js Plugins

Extend presentations with additional features.

## When to Use

- Adding chalkboard/drawing features
- Navigation menus
- Synchronized presentations (multiplex)
- Custom functionality

## Built-in Plugins

| Plugin           | Purpose               |
| ---------------- | --------------------- |
| RevealChalkboard | Draw on slides        |
| RevealMenu       | Slide navigation menu |
| Multiplex        | Synchronized viewing  |
| PdfExport        | PDF export support    |

## Using Built-in Plugins

**Chalkboard:**

```yaml
format:
  revealjs:
    chalkboard: true
```

Keyboard shortcuts:

- `b` = toggle chalkboard
- `c` = toggle canvas mode
- `d` = download drawings
- `x` = clear chalkboard

**Menu:**

```yaml
format:
  revealjs:
    menu: true
```

Press `m` to open menu.

**Chalkboard with Options:**

```yaml
format:
  revealjs:
    chalkboard:
      theme: whiteboard
      boardmarker-width: 5
      buttons: true
```

## Custom Plugins

### Structure

Create plugin directory:

```
myplugin/
├── plugin.yml
└── myplugin.js
```

### plugin.yml

```yaml
name: MyPlugin
script:
  - myplugin.js
```

### Register Plugin

```yaml
format:
  revealjs:
    revealjs-plugins:
      - myplugin
```

## Examples

**Presentation Tools:**

```yaml
---
title: "Interactive Workshop"
format:
  revealjs:
    chalkboard: true
    menu: true
---
```

**Full Chalkboard Config:**

```yaml
format:
  revealjs:
    chalkboard:
      theme: chalkboard # or whiteboard
      boardmarker-width: 3
      chalk-width: 4
      chalk-effect: 0.1
      buttons: true
      src: null # load saved drawings
```

**Menu Configuration:**

```yaml
format:
  revealjs:
    menu:
      side: left
      width: normal
      numbers: true
      titleSelector: h1, h2
      useTextContentForMissingTitles: true
      hideMissingTitles: false
      markers: true
      custom: false
      themes: false
      transitions: false
      openButton: true
      openSlideNumber: false
      keyboard: true
```

**Multiple Custom Plugins:**

```yaml
format:
  revealjs:
    revealjs-plugins:
      - plugins/audio
      - plugins/countdown
      - plugins/pointer
```

## Creating a Custom Plugin

**1. Plugin JavaScript:**

```javascript
// countdown/countdown.js
const Countdown = {
  id: "countdown",
  init: (reveal) => {
    // Plugin initialization
    console.log("Countdown plugin loaded");
  },
};
```

**2. Plugin Configuration:**

```yaml
# countdown/plugin.yml
name: Countdown
script:
  - countdown.js
```

**3. Use in Presentation:**

```yaml
format:
  revealjs:
    revealjs-plugins:
      - countdown
```

## Popular Third-Party Plugins

- **RevealPointer** - Laser pointer effect
- **RevealAudioSlideshow** - Audio narration
- **RevealAnimate** - Enhanced animations
- **RevealSeminar** - Live collaboration

## Best Practices

- Test plugins before presenting
- Check plugin compatibility
- Keep plugins minimal for performance
- Document keyboard shortcuts for audience

## Reference

- [Quarto Reveal.js Plugins](https://quarto.org/docs/presentations/revealjs/advanced.html#reveal-plugins)
- [Reveal.js Plugin API](https://revealjs.com/creating-plugins/)
