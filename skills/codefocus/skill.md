# Code Highlighting Skills for Quarto Revealjs

This skill teaches when and how to use different code highlighting techniques in Quarto revealjs presentations for optimal student comprehension.

---

## Decision Matrix: When to Use Which Technique

| Scenario                                         | Best Technique              | Why                                             |
| ------------------------------------------------ | --------------------------- | ----------------------------------------------- |
| Walk through code step-by-step with explanations | **CodeFocus**               | Progressive reveal with contextual explanations |
| Explain specific syntax elements inline          | **Code Annotations**        | Non-intrusive markers students can explore      |
| Show code evolution/refactoring                  | **Autoanimate**             | Visual diff highlights what changed             |
| Highlight key lines without explanation          | **Built-in highlight**      | Minimal setup, no extensions needed             |
| Complex algorithm with multiple concepts         | **CodeFocus + Annotations** | Combine progressive flow with reference details |

---

## Technique 1: CodeFocus (Progressive Highlighting with Explanations)

### When to Use

- **Teaching new concepts**: Walk students through unfamiliar code line-by-line
- **Complex logic**: Explain conditionals, loops, or algorithms step-by-step
- **Live coding recap**: Summarize what was demonstrated
- **Building understanding**: When order of explanation matters

### When NOT to Use

- Quick reference slides (too slow)
- Code students already understand (patronizing)
- Very short code snippets (<5 lines)

### Setup

```bash
quarto add reuning/codefocus
```

Add to `_quarto.yml`:

```yaml
revealjs-plugins:
  - codefocus
```

### Syntax

````markdown
## Understanding API Calls

```python
import requests
import json

api_url = "https://api.example.com/data"
headers = {"Authorization": "Bearer token"}

response = requests.get(api_url, headers=headers)
data = response.json()
```

::: {.fragment .current-only data-code-focus="1-2"}
First, we import the required libraries for HTTP requests and JSON handling.
:::

::: {.fragment .current-only data-code-focus="4-5"}
Define the API endpoint URL and authentication headers.
:::

::: {.fragment .current-only data-code-focus="7-8"}
Make the GET request and parse the JSON response.
:::
````

### Key Attributes

- **`.fragment`** - Makes content appear progressively
- **`.current-only`** - Fragment disappears when advancing (keeps slide clean)
- **`data-code-focus="N"`** - Single line (1-indexed)
- **`data-code-focus="1-3"`** - Range of lines
- **`data-code-focus="1,3,5"`** - Multiple specific lines

### Best Practices

- Code block must come BEFORE the fragment divs
- Keep explanations concise (1-2 sentences)
- Group related lines together (for example, import statements)
- Use `.current-only` to prevent visual clutter

---

## Technique 2: Code Annotations (Inline Reference Markers)

### When to Use

- **Reference slides**: Students may revisit to understand syntax
- **Self-paced learning**: Let students explore at their own speed
- **Syntax explanation**: Explain what each part of a line does
- **Complex single statements**: Break down long expressions

### When NOT to Use

- Live presentations where you control the pace
- When explanation order matters critically
- Straightforward, self-explanatory code

### Syntax

````markdown
## Python Function Anatomy

```python
def calculate_bmi(weight: float, height: float) -> float:  # <1>
    """Calculate Body Mass Index."""  # <2>
    if height <= 0:  # <3>
        raise ValueError("Height must be positive")
    return weight / (height ** 2)  # <4>
```

1. Function signature with type hints for parameters and return value
2. Docstring describes the function's purpose
3. Input validation prevents division by zero
4. BMI formula: weight divided by height squared
````

### Display Options

Set in YAML front matter or `_quarto.yml`:

```yaml
code-annotations: hover   # Show on hover (recommended for presentations)
code-annotations: select  # Show on click (good for self-study)
code-annotations: below   # Always visible below code (default)
```

### Language-Specific Comment Syntax

| Language          | Annotation Format |
| ----------------- | ----------------- |
| Python/R/Bash     | `# <1>`           |
| JavaScript/C/Java | `// <1>`          |
| HTML              | `<!-- <1> -->`    |
| CSS               | `/* <1> */`       |
| SQL               | `-- <1>`          |

---

## Technique 3: Autoanimate (code evolution)

### When to Use

- **Refactoring demos**: Show before/after code transformations
- **Building up code**: Add features incrementally
- **Debugging walkthroughs**: Show problem → solution
- **Version comparisons**: Demonstrate API changes

### When NOT to Use

- Explaining static code
- When changes are too subtle to notice
- More than 3-4 evolution steps (becomes tedious)

### Syntax

````markdown
## Refactoring: Before {auto-animate="true"}

```python
def process(data):
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
    return result
```

## Refactoring: After {auto-animate="true"}

```python
def process(data):
    return [item * 2 for item in data if item > 0]
```
````

### Animation Options

```yaml
# Per-slide or in _quarto.yml
auto-animate-easing: ease # CSS easing function
auto-animate-duration: 1.0 # Seconds
auto-animate-unmatched: true # Fade in new elements
```

### Best Practices

- Keep slide titles similar so audience knows it is the same code
- Highlight the key change verbally
- Use for meaningful transformations, not trivial edits

---

## Technique 4: Built-in Line Highlighting

### When to Use

- **Quick emphasis**: Draw attention without explanation
- **No extension needed**: Works out of the box
- **Static highlighting**: Lines stay highlighted
- **Combining with other content**: When slide has more than code alone

### When NOT to Use

- When you need to explain WHY those lines matter
- Progressive reveals (all highlights show at once)
- Complex multi-step explanations

### Syntax

````markdown
## Key Lines

```{python}
#| code-line-numbers: "3-4,7"
import pandas as pd
import numpy as np

df = pd.read_csv("data.csv")  # highlighted
df = df.dropna()              # highlighted

result = df.groupby("category").mean()  # highlighted
print(result)
```
````

### Highlight Options

```yaml
#| code-line-numbers: "2"       # Single line
#| code-line-numbers: "2-4"     # Range
#| code-line-numbers: "1,3,5"   # Multiple lines
#| code-line-numbers: "|2|4"    # Progressive: none → line 2 → line 4
#| code-line-numbers: true      # Show line numbers without highlighting
```

---

## Combined Techniques: Teaching Complex Concepts

For comprehensive teaching, combine techniques strategically:

### Example: Teaching a Machine Learning Pipeline

````markdown
## ML Pipeline Overview {auto-animate="true"}

```python
# Load and prepare data
df = pd.read_csv("data.csv")
X, y = df.drop("target", axis=1), df["target"]

# Train model
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)

# Evaluate
accuracy = model.score(X_test, y_test)
```

## ML Pipeline: Data Preparation {auto-animate="true"}

```python
# Load and prepare data  # <1>
df = pd.read_csv("data.csv")  # <2>
X, y = df.drop("target", axis=1), df["target"]  # <3>

# Train model
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)

# Evaluate
accuracy = model.score(X_test, y_test)
```

1. This section handles data preparation
2. Load CSV file into a pandas DataFrame
3. Separate features (X) from target variable (y)

::: {.fragment .current-only data-code-focus="2"}
`read_csv()` automatically infers column types and handles common formats.
:::

::: {.fragment .current-only data-code-focus="3"}
We use `drop()` to remove the target column, keeping only feature columns.
:::
````

---

## Quick Reference: Choosing the Right Technique

```
START
  │
  ├─ Do you need to explain the code? ─── NO ──→ Built-in highlight
  │                                              or no highlight
  YES
  │
  ├─ Does order of explanation matter? ── NO ──→ Code Annotations
  │                                              (let students explore)
  YES
  │
  ├─ Are you showing code changes? ────── YES ─→ Autoanimate
  │                                              (before/after)
  NO
  │
  └─────────────────────────────────────────────→ CodeFocus
                                                  (progressive walkthrough)
```

---

## Summary Table

| Technique      | Extension Required        | Progressive | Self-paced | Shows Changes |
| -------------- | ------------------------- | ----------- | ---------- | ------------- |
| CodeFocus      | Yes (`reuning/codefocus`) | ✅          | ❌         | ❌            |
| Annotations    | No (built-in)             | ❌          | ✅         | ❌            |
| Autoanimate    | No (built-in)             | ✅ (slides) | ❌         | ✅            |
| Line highlight | No (built-in)             | Limited     | ❌         | ❌            |
