---
name: quarto-revealjs-code-blocks
description: Format and highlight code blocks in Quarto Reveal.js slides. Use when user wants syntax highlighting, line highlighting, or code presentation features.
---

# Quarto Reveal.js Code Blocks

Enhanced code presentation with highlighting and animations.

## When to Use

- Presenting code in slides
- Highlighting specific lines
- Step-by-step code walkthrough
- Controlling code block appearance

## Basic Syntax Highlighting

````markdown
```python
def hello():
    print("Hello, World!")
```
````

## Line Highlighting

Emphasize specific lines:

````markdown
```{.python code-line-numbers="2"}
def calculate():
    result = x + y  # This line highlighted
    return result
```
````

**Multiple Lines:**

- `code-line-numbers="1,3"` - Lines 1 and 3
- `code-line-numbers="2-4"` - Lines 2 through 4
- `code-line-numbers="1,3-5"` - Line 1 and lines 3-5

## Progressive Highlighting

Step through code with animations:

````markdown
```{.python code-line-numbers="|1|2-3|4"}
import pandas as pd
df = pd.read_csv("data.csv")
df = df.dropna()
print(df.head())
```
````

Reveals: all → line 1 → lines 2-3 → line 4

## Code Block Height

**Per-block:**

````markdown
```{.python max-height="300px"}
# Tall code block with scroll
```
````

**Global:**

```yaml
format:
  revealjs:
    code-block-height: 650px
```

## Code Folding

Allow collapsible code:

```yaml
format:
  revealjs:
    code-fold: true
    code-summary: "Show code"
```

## Code Copy Button

```yaml
format:
  revealjs:
    code-copy: true
```

## Examples

**Teaching Code Step-by-Step:**

````markdown
## Building a Function

```{.python code-line-numbers="|1|2|3|4"}
def greet(name):
    greeting = f"Hello, {name}!"
    print(greeting)
    return greeting
```
````

**Highlighting Bug Fix:**

````markdown
## The Fix

```{.javascript code-line-numbers="3"}
function divide(a, b) {
  // Before: return a / b;
  if (b === 0) throw new Error("Division by zero");
  return a / b;
}
```
````

**Multiple Languages:**

````markdown
:::: {.columns}
::: {.column width="50%"}

```python
# Python
print("Hello")
```

:::
::: {.column width="50%"}

```javascript
// JavaScript
console.log("Hello");
```

:::
::::
````

## Highlighting Themes

```yaml
format:
  revealjs:
    highlight-style: github # or: monokai, dracula, etc.
```

## Reference

- [Quarto Reveal.js Code Blocks](https://quarto.org/docs/presentations/revealjs/#code-blocks)
