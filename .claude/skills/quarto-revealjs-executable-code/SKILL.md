---
name: quarto-revealjs-executable-code
description: Embed executable code with live output in Quarto Reveal.js slides. Use when user wants to show code results, plots, or computations directly in slides.
---

# Quarto Reveal.js Executable Code

Run code and display output directly in slides.

## When to Use

- Showing code with its output
- Displaying generated plots/charts
- Live computations in presentations
- Data analysis demonstrations

## Supported Languages

- Python
- R
- Julia
- Observable JS

## Basic Usage

````markdown
```{python}
import pandas as pd
df = pd.DataFrame({'x': [1,2,3], 'y': [4,5,6]})
df
```
````

Output appears directly below code.

## Code Echo Control

**Hide Code (default in revealjs):**

````markdown
```{python}
#| echo: false
result = 2 + 2
print(result)
```
````

**Show Code:**

````markdown
```{python}
#| echo: true
result = 2 + 2
print(result)
```
````

## Output Location

Control where output appears:

````markdown
```{python}
#| output-location: fragment
import matplotlib.pyplot as plt
plt.plot([1,2,3], [1,4,9])
plt.show()
```
````

Options:

- `fragment` - Output appears on next click
- `slide` - Output on next slide
- `column` - Output beside code
- `column-fragment` - Column with click reveal

## Figure Sizing

Matplotlib/Plotly auto-size to fill slide. Override:

````markdown
```{python}
#| fig-width: 8
#| fig-height: 5
import matplotlib.pyplot as plt
plt.figure()
plt.plot([1,2,3])
plt.show()
```
````

## Examples

**Data Table:**

````markdown
## Dataset Preview

```{python}
#| echo: true
import pandas as pd
df = pd.read_csv("data.csv")
df.head()
```
````

**Plot with Code:**

````markdown
## Visualization

```{python}
#| echo: true
#| output-location: column
import matplotlib.pyplot as plt
x = [1, 2, 3, 4]
y = [1, 4, 9, 16]
plt.plot(x, y)
plt.title("Growth")
```
````

**Progressive Reveal:**

````markdown
## Analysis Steps

```{python}
#| echo: true
#| output-location: fragment
# First show the code...
result = complex_analysis()
# Then reveal the result
result
```
````

**R Example:**

````markdown
```{r}
#| echo: true
library(ggplot2)
ggplot(mtcars, aes(mpg, hp)) +
  geom_point()
```
````

## YAML Configuration

```yaml
---
format:
  revealjs:
    code-tools: true
execute:
  echo: true
  warning: false
---
```

## Best Practices

- Use `#| echo: false` for complex setup code
- Use `output-location: column` for code + plot side-by-side
- Pre-compute heavy operations to avoid slow rendering
- Test figures fit slide dimensions

## Reference

- [Quarto Reveal.js Executable Code](https://quarto.org/docs/presentations/revealjs/#executable-code)
