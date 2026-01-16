# Quarto Revealjs Presentation Template

A Quarto presentation template with reveal.js plugins. Outputs both slides and HTML page with TOC.

**Live Demo:** [htlin.github.io/quarto-presentation](https://htlin.github.io/quarto-presentation/)

## Features

- **reveal-auto-agenda** - Generates agenda slides automatically
- **code-fullscreen** - Fullscreen button for code blocks
- **codeFocus** - Progressive code line highlighting with explanations
- **simplemenu** - Navigation menu bar for sections

## Project Structure

```
.
├── index.qmd            # Main content
├── _quarto.yml          # Configuration (title, author, formats)
├── custom.scss          # Custom theme styles
├── makefile             # Build automation
└── .github/workflows/   # GitHub Actions (auto-deploy)
```

## Quick Start

```bash
# Build both formats (slides.html + index.html)
make

# Live preview with auto-reload
make preview

# Build for deployment
make deploy

# Clean output files
make clean
```

## Output

| File          | Description           | URL                                   |
| ------------- | --------------------- | ------------------------------------- |
| `index.html`  | HTML page with TOC    | `username.github.io/repo/`            |
| `slides.html` | Revealjs presentation | `username.github.io/repo/slides.html` |

## Customization

### Change title or author

Edit `_quarto.yml`:

```yaml
title: "Your Presentation Title"
subtitle: "Your Subtitle"
author: "Your Name"
```

### Section format

Each section should start with a level-1 heading with `data-stack-name` for simplemenu:

```markdown
# Section Title {data-stack-name="MenuName"}

## Slide title

Content here...
```

### CodeFocus usage

````markdown
## Slide with CodeFocus

```python
import requests
response = requests.get(url)
data = response.json()
```

::: {.fragment .current-only data-code-focus="1"}
Import the requests library.
:::

::: {.fragment .current-only data-code-focus="2-3"}
Make request and parse JSON.
:::
````

## Deploy

Automated via GitHub Actions. On push to `main`:

1. Builds both formats
2. Copies to `_site/`
3. Deploys to GitHub Pages

### Setup GitHub Pages

1. Go to repo **Settings** → **Pages**
2. Set Source to **GitHub Actions**
3. Push to `main` branch

## Requirements

- [Quarto](https://quarto.org/) ≥ 1.3

## License

MIT
