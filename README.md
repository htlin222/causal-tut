# 觀察性研究的因果推論：給臨床醫師的實戰指南

Causal Inference from Observational Studies: A Practical Guide for Clinicians

**Live Demo:** [htlin222.github.io/causal-tut](https://htlin222.github.io/causal-tut/)

## 課程內容

| 章節 | 主題       | 重點                                  |
| ---- | ---------- | ------------------------------------- |
| 1-2  | 問題與設計 | 為什麼需要因果推論？Target Trial 設計 |
| 3-4  | 方法概念   | PS → IPW → 雙重穩健 → TMLE            |
| 5-6  | 準備工作   | 選方法、備資料                        |
| 7    | R 實作     | 程式碼示範                            |
| 8-9  | 驗證報告   | E-value、論文寫作                     |

## Features

- **reveal-auto-agenda** - Generates agenda slides automatically
- **code-fullscreen** - Fullscreen button for code blocks
- **codeFocus** - Progressive code line highlighting with explanations
- **simplemenu** - Navigation menu bar for sections

## Quick Start

```bash
# Build both formats (slides.html + index.html)
make

# Live preview with auto-reload
make preview

# Clean output files
make clean
```

Note: `index.qmd` includes `chapters/*.qmd` via Quarto include syntax.

## Output

| File          | Description           | URL                                         |
| ------------- | --------------------- | ------------------------------------------- |
| `index.html`  | HTML page with TOC    | `htlin222.github.io/causal-tut/`            |
| `slides.html` | Revealjs presentation | `htlin222.github.io/causal-tut/slides.html` |

## Requirements

- [Quarto](https://quarto.org/) ≥ 1.3
- R packages: `ggplot2`, `showtext`, `cobalt`, `MatchIt`, etc.

## License

MIT
