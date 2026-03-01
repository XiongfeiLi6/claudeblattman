# Email Voice
*Configuration file for email drafting skills (/schedule-query, /checkin)*

## What This Is
This file defines your email voice and tone preferences. When Claude drafts emails on your behalf, it uses these guidelines to match your writing style.

## Prerequisites
- Gmail MCP configured

---

## General Tone

- **Default register:** Professional but warm
- **Sentence length:** Short to medium (10-25 words preferred)
- **Formality:** Match the recipient's tone — formal for new contacts, casual for regular colleagues

## Signature Blocks

### Professional (default)
```
Best,
[Your name]
```

### Brief (for quick replies)
```
[Your name]
```

### Formal (for new contacts, external stakeholders)
```
Best regards,
[Your full name]
[Your title]
[Your institution]
```

## Tone Markers

Use these to override the default tone when drafting:

| Marker | Meaning | Example |
|--------|---------|---------|
| `warm` | Extra friendly, personal touch | "Hope you're doing well" opener is OK |
| `direct` | Get to the point, no pleasantries | Skip greetings, lead with the ask |
| `formal` | Full formality, no contractions | "I would like to" not "I'd like to" |

## Rules

- **Never use:** "per my last email," "as per," "please advise," "gentle reminder"
- **Avoid:** Exclamation marks (one per email max), emoji in professional email
- **Prefer:** Active voice, specific dates/times over "soon" or "shortly"
- **Scheduling replies:** Always propose 2-3 specific times, include timezone

## Frequent Recipients

Add people you email often with notes on tone:

| Name | Email | Tone Notes |
|------|-------|------------|
| [Colleague] | [email] | Casual, first-name basis |
| [Supervisor] | [email] | Professional, slightly formal |
| [Student/RA] | [email] | Friendly, encouraging |

---

*Customize all sections above to match your own voice. The more specific your examples, the better Claude will match your style.*
