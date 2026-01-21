# Repository Guidelines

## Project Structure & Module Organization
- `index.qmd` is the single render entrypoint; it includes the slide/content flow and shared R setup.
- `chapters/` holds chapter-level `.qmd` files named with numeric prefixes (e.g., `01_.qmd`).
- `data/` stores example datasets (`*.csv`) used in code chunks.
- `_extensions/` contains Quarto RevealJS plugins used by the deck.
- `custom.scss` defines the theme overrides; `jf-openhuninn-2.1.ttf` is the bundled font.
- Generated artifacts land in the repo root (`index.html`, `slides.html`, `index_files/`, `slides_files/`); `reference/` is for notes.

## Build, Test, and Development Commands
- `make` or `make render` renders `index.qmd` into `index.html` and `slides.html`.
- `make preview` runs live preview with reload; use this while editing slides.
- `make deploy` renders and copies outputs into `_site/` for GitHub Pages.
- `make clean` removes rendered output and cache files.

## Coding Style & Naming Conventions
- Use Quarto Markdown with R code chunks; chunk options are set with `#|` lines.
- Follow existing formatting: 2-space indentation in YAML/SCSS and tidy, readable R blocks.
- Keep chapter filenames in the `NN_.qmd` pattern and align headings with the deck structure.
- Prefer concise, bilingual headings only when the section already follows that style.

## Testing Guidelines
- There is no automated test suite. Validate changes by running `make` and opening `index.html` and `slides.html` to confirm layout, code output, and navigation.

## Commit & Pull Request Guidelines
- Commit messages are short and imperative; optional type prefixes like `style:` are used in history.
- PRs should describe scope, link related issues, and include a brief render check (or a screenshot for layout changes).

## Configuration & Asset Notes
- Project settings live in `_quarto.yml`; update it when adding formats, filters, or plugins.
- Keep assets (fonts, images) referenced via relative paths so Quarto renders consistently.
