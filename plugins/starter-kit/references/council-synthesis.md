# Council Synthesis Template

The synthesis step reads raw critic outputs and produces a single ranked recommendation. It is **always a separate Task dispatch** — a strong model in a fresh context — never done inline in the main session, and never a majority vote on narrative outputs.

Used by the starter-kit `/council` and `/review-plan` skills.

---

## Synthesis prompt template

```
You are a synthesizer. You are NOT voting. You are reading N raw critic outputs
as data and producing a single synthesized recommendation.

RAW CRITIC OUTPUTS:
[Paste all N persona outputs verbatim, labeled by persona name]

ORIGINAL INPUT REVIEWED:
[Paste the original content the critics reviewed]

YOUR TASK:

1. Aggregate: for each distinct concern raised, list which personas raised it and
   what scoring signal (if any) they attached.

2. Composite score per item (if critics produced scores):
     composite = mean(scores) - 0.1 × blocker_count
   Additive penalty (no clamping). An item with blockers retains most of its
   mean — this is ranking, not dismissal.

3. Cross-critique: "What did all N personas miss?" Answer in 1-2 sentences per
   top item. This catches convergent blind spots from shared priors.

4. Rank: the top K items advance with full detail. Items K+1 onward appear as
   "deferred" with full reasoning (not dismissed — the user can promote them).

5. Output a single recommendation in this shape:

   ─── COUNCIL (N voices) ──────────────────────────
   🔴 [Persona]: [one-sentence sharpest concern]
   🟡 [Persona]: [one-sentence concern]
   🟢 [Persona]: [one-sentence concern]
   ─── SYNTHESIS ──────────────────────────────────
   [2-3 sentence recommendation that names the strongest convergent point,
    the most important divergence, and the final judgment]
   ─────────────────────────────────────────────────

CONSTRAINTS:
- Do NOT produce a majority vote. If personas disagree, say so and take a side
  with reasoning.
- Do NOT soften findings to reach false consensus. If three critics converge on
  a blocker, that blocker is load-bearing.
- Do NOT add your own concerns not raised by the critics. You're synthesizing
  their signal, not adding another voice.
```

---

## Why a separate dispatch

1. **Conformity bias.** Inline synthesis reads the critics as a running conversation and anchors on tone. Fresh-context synthesis reads them as data.
2. **Capability placement.** If you ever run critics on a cheaper model, give the synthesis to the strongest model available. Mixed capability is a problem when models argue as *peers*; it's a benefit when the stronger model is the one reading everything.
3. **No majority-vote drift.** Multi-round narrative voting shows accuracy decline round over round (Du et al. 2023). A single reader with all outputs in view avoids this.

## Composite scoring — why an additive penalty

- Multiplicative penalties kill adventurous items (high mean × any blocker → zero).
- Additive (−0.1 per blocker) preserves ranking while surfacing the concern.
- The rule: a council RANKS, it does not DISMISS.

## Top-K + deferred-detail pattern

- The top K items (usually 3–7) advance with full action detail.
- Lower-ranked items are displayed with the same level of detail, labeled "deferred."
- The user can promote any deferred item by asking for it.
- Nothing is hidden. The synthesizer can RANK but not HIDE.

---

## Invocation shape

```
Separate Task dispatch:
  model: a strong model in a fresh context (the starter kit inherits your
         session's model — no special configuration needed)
  context: fresh (no parent-session pollution)
  input: raw critic outputs + original content + this template + panel-type branch
  output: a single synthesized markdown response in the shape above
```

---

## Panel-type branches

The synthesizer adapts its header sequence to the panel type. Both branches end with the raw-critic collapsible at the bottom.

### Plan branch (plan / architecture / workflow review)

```
─── COUNCIL ─ PLAN REVIEW (N voices) ─────────────
Verdict: ship / revise / kill
Top 3 blockers:
  1. <blocker — which critic(s) raised it>
  2. ...
  3. ...
Top 3 patches (ranked by leverage):
  1. <patch — addresses blocker N>
  2. ...
  3. ...
Per-critic one-line verdict:
  - [Persona]: <ship/revise/kill + sharpest reason>
  - ...
───────────────────────────────────────────────────
<details><summary>Raw critic outputs</summary>
[all N verbatim]
</details>
```

### Decision branch (go/no-go, "should I...")

```
─── COUNCIL ─ DECISION SUPPORT (N voices) ────────
Recommended action: <verb + object + by-when>
Top 3 risks (probability × impact):
  1. <risk + mitigation if known>
  2. ...
  3. ...
Top 3 reasons in favor:
  1. ...
  2. ...
  3. ...
Per-critic one-line verdict:
  - [Persona]: <go/slow/no + sharpest reason>
───────────────────────────────────────────────────
<details><summary>Raw critic outputs</summary>
[all N verbatim]
</details>
```

*(Paper and grant branches ship with the future paper-review personas — not in this release.)*

---

## Which branch fires

`/council` passes the panel type to the synthesizer. If no type is given and the panel doesn't clearly map, default to the Plan branch.
