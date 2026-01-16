---
name: quarto-revealjs-tabsets
description: Create tabbed content panels in Quarto Reveal.js slides. Use when user wants to organize multiple related items in tabs, show alternatives, or save slide space.
---

# Quarto Reveal.js Tabsets

Create tabbed panels to organize content.

## When to Use

- Showing multiple versions/alternatives
- Comparing code in different languages
- Organizing related content compactly
- Before/after comparisons

## Basic Syntax

```markdown
## Slide Title

::: {.panel-tabset}

### Tab 1

Content for first tab.

### Tab 2

Content for second tab.

### Tab 3

Content for third tab.

:::
```

## Examples

**Code in Multiple Languages:**

````markdown
## Hello World

::: {.panel-tabset}

### Python

```python
print("Hello, World!")
```

### JavaScript

```javascript
console.log("Hello, World!");
```

### R

```r
print("Hello, World!")
```

:::
````

**Before/After:**

```markdown
## Refactoring Results

::: {.panel-tabset}

### Before

- 500 lines of code
- 3 dependencies
- 2s load time

### After

- 200 lines of code
- 1 dependency
- 0.5s load time

:::
```

**Data Views:**

````markdown
## Dataset

::: {.panel-tabset}

### Table

| Name | Value |
| ---- | ----- |
| A    | 100   |
| B    | 200   |

### Chart

```{python}
#| echo: false
import matplotlib.pyplot as plt
plt.bar(['A', 'B'], [100, 200])
```

### Raw

```json
{ "A": 100, "B": 200 }
```

:::
````

**Platform Instructions:**

````markdown
## Installation

::: {.panel-tabset}

### macOS

```bash
brew install myapp
```
````

### Windows

```powershell
choco install myapp
```

### Linux

```bash
apt install myapp
```

:::

````

## Important Notes

1. **PDF Export:** Only first tab appears in PDF
2. **Printing:** Consider this when printing slides
3. **Navigation:** Tabs clickable during presentation
4. **Nesting:** Avoid nesting tabsets

## Styling

Custom SCSS:

```scss
.panel-tabset .nav-tabs {
  border-bottom: 2px solid #ddd;
}

.panel-tabset .nav-link.active {
  background-color: #007bff;
  color: white;
}
````

## Best Practices

- Use descriptive tab names
- Keep tab count reasonable (3-5)
- Ensure content fits without scrolling
- Consider non-tabset alternatives for critical content (PDF/print)

## Reference

- [Quarto Tabsets](https://quarto.org/docs/output-formats/html-basics.html#tabsets)
- [Quarto Reveal.js](https://quarto.org/docs/presentations/revealjs/)
