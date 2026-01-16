---
name: quarto-revealjs-overflow
description: Handle content overflow in Quarto Reveal.js slides. Use when slide content is too long, needs smaller text, or requires scrolling.
---

# Quarto Reveal.js Content Overflow

Control how excessive content is handled on slides.

## When to Use

- Slide has too much content
- Need smaller text to fit more content
- Want scrollable slides for long content
- Adjusting text size globally or per-slide

## Options

### 1. Smaller Text (`.smaller`)

Makes text smaller so more fits on slide.

**Per-slide:**

```markdown
## Slide Title {.smaller}

Lots of content here...
```

**Globally:**

```yaml
format:
  revealjs:
    smaller: true
```

### 2. Scrollable Content (`.scrollable`)

Adds scrollbar for content that exceeds slide height.

**Per-slide:**

```markdown
## Slide Title {.scrollable}

Very long content that will scroll...
```

**Globally:**

```yaml
format:
  revealjs:
    scrollable: true
```

### 3. Combined

```markdown
## Dense Slide {.smaller .scrollable}

Maximum content density with scroll fallback.
```

**Global YAML:**

```yaml
format:
  revealjs:
    smaller: true
    scrollable: true
```

## Examples

**Data-heavy slide:**

```markdown
## Full Dataset {.smaller .scrollable}

| Col1              | Col2 | Col3 | Col4 |
| ----------------- | ---- | ---- | ---- |
| ... many rows ... |
```

**Code-heavy slide:**

````markdown
## Implementation Details {.scrollable}

```python
# Long code block
def function():
    # Many lines...
```
````

```

## Best Practice

- Use `.smaller` for moderately long content
- Use `.scrollable` for truly long content (tables, code)
- Combine both for maximum flexibility
- Consider splitting into multiple slides instead

## Reference

- [Quarto Reveal.js Content Overflow](https://quarto.org/docs/presentations/revealjs/#content-overflow)
```
