---
name: quarto-revealjs-auto-animate
description: Create automatic animations between Quarto Reveal.js slides. Use when user wants smooth element transitions or code diff animations.
---

# Quarto Reveal.js Auto Animate

Automatically animate matching elements between slides.

## When to Use

- Smooth element transitions
- Code evolution animations
- Position/style changes
- Progressive content building

## Basic Syntax

Add `auto-animate=true` to consecutive slides:

```markdown
## {auto-animate=true}

::: {style="margin-top: 100px;"}
Animating Box
:::

## {auto-animate=true}

::: {style="margin-top: 200px; font-size: 2em; color: red;"}
Animating Box
:::
```

The box smoothly moves and changes size/color.

## Element Matching

Elements match automatically by:

1. Text content
2. `src` attribute (images)
3. DOM order

For explicit matching, use `data-id`:

```markdown
## {auto-animate=true}

::: {data-id="box1"}
First position
:::

## {auto-animate=true}

::: {data-id="box1" style="margin-left: 200px;"}
Moved position
:::
```

## Code Animations

Animate code changes:

````markdown
## {auto-animate=true}

```python
def greet():
    print("Hello")
```

## {auto-animate=true}

```python
def greet(name):
    print(f"Hello, {name}!")
```
````

Code morphs to show the differences.

## Animation Settings

Control animation behavior:

| Attribute                | Default | Description                |
| ------------------------ | ------- | -------------------------- |
| `auto-animate-easing`    | `ease`  | CSS easing function        |
| `auto-animate-duration`  | `1.0`   | Duration in seconds        |
| `auto-animate-delay`     | `0`     | Delay (per-element only)   |
| `auto-animate-unmatched` | `true`  | Fade in unmatched elements |

```markdown
## {auto-animate=true auto-animate-duration="0.5" auto-animate-easing="ease-in-out"}
```

## Examples

**Growing List:**

```markdown
## {auto-animate=true}

- Item 1

## {auto-animate=true}

- Item 1
- Item 2

## {auto-animate=true}

- Item 1
- Item 2
- Item 3
```

**Moving Elements:**

```markdown
## {auto-animate=true}

::: {data-id="a" style="background: blue; width: 100px; height: 100px; position: absolute; left: 0;"}
:::

## {auto-animate=true}

::: {data-id="a" style="background: red; width: 200px; height: 200px; position: absolute; left: 300px;"}
:::
```

**Code Evolution:**

````markdown
## Step 1 {auto-animate=true}

```js
let x = 1;
```

## Step 2 {auto-animate=true}

```js
let x = 1;
let y = 2;
```

## Step 3 {auto-animate=true}

```js
let x = 1;
let y = 2;
let sum = x + y;
```
````

**Diagram Build:**

````markdown
## {auto-animate=true}

```{mermaid}
graph LR
    A[Start]
```
````

## {auto-animate=true}

```{mermaid}
graph LR
    A[Start] --> B[Process]
```

## {auto-animate=true}

```{mermaid}
graph LR
    A[Start] --> B[Process] --> C[End]
```

```

## Best Practices

- Keep matching content identical for smooth transitions
- Use `data-id` for complex layouts
- Test animation duration for natural feel
- Avoid too many simultaneous animations
- Works best with simple, distinct elements

## Caveats

- Only works on adjacent slides
- Complex nested structures may not animate well
- Performance depends on element count

## Reference

- [Quarto Reveal.js Auto-Animate](https://quarto.org/docs/presentations/revealjs/advanced.html#auto-animate)
```
