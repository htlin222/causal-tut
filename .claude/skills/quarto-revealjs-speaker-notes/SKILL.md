---
name: quarto-revealjs-speaker-notes
description: Add speaker notes to Quarto Reveal.js slides. Use when user wants presenter notes, talking points, or reference material visible only to the speaker.
---

# Quarto Reveal.js Speaker Notes

Add reference notes visible only in speaker view.

## When to Use

- Adding presenter talking points
- Including reference material not shown to audience
- Creating presentation scripts
- Adding timing reminders or cues

## Syntax

```markdown
## Slide Title

Visible slide content here.

::: {.notes}
Speaker notes go here.
These are only visible in speaker view.
:::
```

## Accessing Speaker View

Press **S** key during presentation to open speaker view.

Speaker view shows:

- Current slide
- Next slide preview
- Speaker notes
- Timer

## Examples

**Basic Notes:**

```markdown
## Quarterly Results

Revenue increased 25% year-over-year.

::: {.notes}

- Mention the Q3 dip was due to seasonal factors
- Be prepared for questions about Q4 projections
- Target time: 3 minutes
  :::
```

**Detailed Script:**

```markdown
## Introduction

Welcome to our presentation.

::: {.notes}
Good morning everyone. Today I'll be walking you through our latest findings.

Key points to cover:

1. Background context
2. Methodology
3. Results
4. Implications

Remember to make eye contact and speak slowly.
:::
```

**With Markdown Formatting:**

```markdown
## Complex Topic

Technical content here.

::: {.notes}
**Key message:** Focus on the business impact.

Talking points:

- First explain the problem
- Then show the solution
- End with benefits

_If asked about timeline:_ Mention Q2 target.
:::
```

## Best Practice

- Keep notes concise but complete
- Use bullet points for easy scanning
- Include timing cues if needed
- Add contingency notes for Q&A

## Reference

- [Quarto Reveal.js Speaker Notes](https://quarto.org/docs/presentations/revealjs/#speaker-notes)
