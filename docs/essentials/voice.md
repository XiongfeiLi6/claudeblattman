# Teaching AI Your Voice

<span class="badge-teal">No Claude Code required</span>

AI has a house style. You've seen it — the same cadence, the same filler words, the same way of saying nothing in three polished paragraphs. When you ask it to write for you, it writes like every other AI output. When you ask it to edit your work, it quietly overwrites your voice with its own.

The fix isn't better prompting. It's giving the AI a reference document — a "voice file" — that captures how you actually write. Load it once, and every conversation starts with your patterns, not the AI's defaults.

---

## Before and After

Same request, same model. The only difference is whether a voice file was loaded.

=== "Without voice file"

    > The mentoring program represents a comprehensive approach to addressing the challenges faced by at-risk youth. Through a multifaceted intervention combining cognitive behavioral therapy with economic support, we aim to foster meaningful behavioral change. Our robust methodology leverages randomized assignment to ensure rigorous impact evaluation.

=== "With voice file"

    > We're testing whether a cheap, scalable mentoring program can reduce violence among high-risk young men. The program combines CBT-based self-regulation training with a small cash grant — 10 sessions over 8 weeks, at roughly $120 per participant. We randomly assign 2,000 men to treatment or control and track arrests, self-reported violence, and employment at 12 months.

The first version could have been written by anyone — or anything. The second sounds like a researcher who knows the project and has opinions about it.

---

## Build Your Voice File

One path. Five steps.

**1. Start with your best writing.** Pull 5–10 pieces you're proud of — funded proposals, blog posts people actually shared, emails where you nailed the tone. Diversity of context matters more than volume. A proposal and a blog post teach the AI more than five proposals.

**2. Let the AI analyze them, not you.** You're too close to your own voice to describe it accurately. Paste your samples plus this prompt into a fresh chat:

```text
Analyze these writing samples and extract my voice profile. For each
pattern you identify, cite the specific phrase or sentence that
demonstrates it. Cover:

1. How I open paragraphs — what's the first sentence doing?
2. Sentence length patterns — average, range, rhythm
3. Moves I repeat — do I enumerate? Use parentheticals? Quantify?
4. Vocabulary I reach for vs. vocabulary I avoid
5. How I handle uncertainty and evidence
6. What I never do (identify any consistent absences)

Be specific. "Uses short sentences" is useless. "Lead sentences average
8 words; elaboration sentences average 18" is useful. Quote my text
as evidence for every claim.
```

This is the page's core deliverable. The prompt forces the AI to ground every observation in your actual text, not generic style advice.

**3. Ask it to build the voice spec.** From the analysis, have the AI draft a 300–500 word voice file covering: tone attributes, non-negotiable rules, active vocabulary, and evidence defaults. Think of it as a style guide that fits in a single page.

**4. Add annotated examples — this is what matters most.** A voice file that says "write short sentences" is weaker than one that shows a paragraph doing it. See [Why Examples Beat Rules](#why-examples-beat-rules) below.

**5. Load it and test.** Paste the voice file into a ChatGPT or Claude.ai Project (see [Chatbots Done Right](chatbots.md) for setup). Then ask the AI to write something you've already written — a paragraph from a recent proposal, a blog post intro, an important email. Compare the output to the original. If it uses words you'd never use, the voice file needs a rule.

!!! tip "The Ban List"
    These are the words AI uses that no human actually writes. If you add nothing else to your voice file, add this:

    *delve, leverage, multifaceted, furthermore, moreover, robust, compelling, navigate, foster, transformative, pivotal, I hope this email finds you well*

    Every one is a diagnostic signal that the AI is ignoring your voice and reverting to its default. Ban them explicitly.

??? tip "Multiple writing contexts"
    If your email voice sounds nothing like your proposal voice, you might want separate files — or a single file with register sections. Keep universal rules (ban list, sentence-length targets) in one place, and context-specific rules in their own sections. The [Voice Pack Template](../downloads/voice-pack-template.md) has the full framework.

!!! tip "Where to store it"
    Paste into a ChatGPT or Claude.ai Project (see [Chatbots Done Right](chatbots.md)). In Claude Code, import via your `CLAUDE.md` using `@voice/your-voice-file.md`. Either way, the voice file loads automatically into every conversation.

---

## Why Examples Beat Rules

Rules tell the AI what to do. Examples show it what the result looks like. The AI pattern-matches against examples far more reliably than it follows abstract instructions.

Use this structure for each example in your voice file:

```xml
<context>
Audience: Foundation program officer
Purpose: Justify a budget increase for fieldwork
Constraints: 1 paragraph, under 100 words
</context>

<example_text>
We underestimated travel costs by 40%. Fuel prices in northern Uganda
tripled since the proposal. We need an additional $12,000 to complete
the remaining 6 site visits. Without them, we lose 30% of our sample.
</example_text>

<notes>
- Opens with the problem, not background
- Quantifies everything (40%, $12,000, 6 visits, 30%)
- Four sentences, no hedging
- Ends with stakes, not a request
</notes>
```

Include 3–5 of these, varied by context. They're the difference between a vague style guide and one the AI can actually use.

---

## Improve It Over Time

Every bad draft teaches you something about your voice file. When the AI gets your voice wrong, don't just fix the output — fix the file.

| What the AI got wrong | What that reveals | Rule to add |
|---|---|---|
| Used "furthermore" and "moreover" | Ban list is incomplete | Add those transitions to the ban list |
| Long compound sentences | Sentence-length rule too vague | "Cap at 20 words. Vary rhythm: short, short, medium." |
| Hedged where you'd be direct | Missing stance rule | "Claims-first. 'I argue' not 'it could be argued'" |

After 3–4 writing sessions of active updating, the file becomes reliable. You stop noticing it — which is the point.

---

## Next Steps

<div class="grid cards" markdown>

-   **Voice Pack Template**

    ---

    Fill-in-the-blank template covering tone, rules, vocabulary, examples, and testing. The full framework in one file.

    [:octicons-download-16: Download](../downloads/voice-pack-template.md)

-   **AI Project Folders**

    ---

    The same "store it as a file" pattern applied to planning, decisions, and recurring tasks.

    [:octicons-arrow-right-24: AI Project Folders](project-folders.md)

-   **Prompt Engineering**

    ---

    Structured prompts with your voice file loaded get better results than either alone.

    [:octicons-arrow-right-24: Prompt Engineering](prompting.md)

</div>
