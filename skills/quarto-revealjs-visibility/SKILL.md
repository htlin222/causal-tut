---
name: quarto-revealjs-visibility
description: Control slide visibility in Quarto Reveal.js. Use when user wants to hide slides or exclude them from navigation count.
---

# Quarto Reveal.js Slide Visibility

Control which slides appear and how they're counted.

## When to Use

- Hiding slides completely
- Excluding slides from progress bar
- Creating optional/backup slides
- Preparing alternative content

## Visibility Options

### Hidden Slides

Completely removes slide from presentation:

```markdown
## Hidden Slide {visibility="hidden"}

This slide won't appear at all.
```

Use for:

- Draft content
- Removed but preserved slides
- Conditional content

### Uncounted Slides

Slide appears but isn't counted in progress:

```markdown
## Bonus Content {visibility="uncounted"}

This won't affect the slide count.
```

Use for:

- Appendix slides
- Q&A backup slides
- Optional deep-dives
- Bonus content

## Examples

**Backup Slides Section:**

```markdown
## Conclusion

Thank you for your attention!

## Q&A {visibility="uncounted"}

Questions?

## Backup: Detailed Data {visibility="uncounted"}

| Metric | Value |
| ------ | ----- |
| ...    | ...   |

## Backup: Methodology {visibility="uncounted"}

Extended methodology details...
```

**Draft Content:**

```markdown
## Current Slide

This is shown.

## Work in Progress {visibility="hidden"}

Still working on this content.

## Next Slide

This is also shown.
```

**Optional Deep-Dive:**

```markdown
## Summary

Key findings overview.

## Technical Details {visibility="uncounted"}

For those interested in the implementation...
```

## Comparison

| Attribute                | Visible | In Navigation | In Progress Bar |
| ------------------------ | ------- | ------------- | --------------- |
| (none)                   | Yes     | Yes           | Yes             |
| `visibility="uncounted"` | Yes     | Yes           | No              |
| `visibility="hidden"`    | No      | No            | No              |

## Best Practices

- Use `hidden` for content not ready to show
- Use `uncounted` for supplementary materials
- Group uncounted slides at the end
- Consider using vertical slides for optional content instead

## Reference

- [Quarto Reveal.js Visibility](https://quarto.org/docs/presentations/revealjs/advanced.html#slide-visibility)
