---
name: codex-goals
description: >
  Author optimized OpenAI Codex Goal Mode prompts and the AGENTS.md that backs them,
  for handing autonomous build, refactor, migration, or verification work to Codex.
  Use whenever the user is planning a Codex task, writing or improving a `/goal`,
  mentions Codex Goal Mode, or wants a handoff a Codex agent will execute end-to-end
  — even if they don't say the word "goal". Every goal it produces fits the 4,000-char
  objective cap and carries a mandatory pause-and-escalate contract so Codex stops and
  asks the user when an assumption is invalidated, a checkpoint is reached, or a
  blocker needs human help, instead of green-washing or guessing.
---

# Authoring Codex Goals

Codex **Goal Mode** (`/goal`) is a persistent, evidence-gated objective: Codex loops
*plan → act → verify* across many turns until concrete evidence (tests, artifacts,
command output) proves the outcome — it cannot complete on confidence alone. This
skill packages work so Codex finishes it correctly, completely, and stops at the
right moments.

**Before authoring, check freshness:** `references/goal-mode-mechanics.md` has a
`Last verified` date. If it's >30 days old, run `UPGRADE.md` (or at minimum re-check
the changelog + config-reference) before trusting version-sensitive details.
Verified facts + sources live in the reference; a fill-in scaffold in
`assets/goal-template.md`.

## How to use this skill (the authoring flow)

1. **Fit check.** Goal Mode fits mechanical, verifiable work with a provable "done"
   (migrations, refactors, builds, verification spikes, evidence-grade audits). It
   does NOT fit taste/ambiguous/exploratory work or one-turn tasks. Tell: if done
   can't be proven by a command or artifact, sharpen the objective first.
2. **Version check on the target machine.** `codex --version` changes the advice:
   <0.133.0 needs `[features] goals = true`; <0.140.0 hard-rejects >4,000-char
   goals; <0.142.0 has NO budget enforcement (advisory only). Confirm before
   finalizing budget/overflow assumptions.
3. **Pre-flight rubric — all five or you're hoping:** (a) measurable artifact,
   (b) one-liner verification command, (c) exact write scope, (d) literal stop
   condition, (e) pause condition. Can't fill one → not a goal yet.
4. **Split the three layers.** Durable repo rules → `AGENTS.md`. Mission detail
   that won't fit the cap (field specs, unit lists, seed data) → a **committed
   brief doc** (e.g. `docs/goal-brief.md`) the goal references. The `/goal` string
   carries ONLY the outcome contract.
5. **Write the goal with all six components** (cookbook-canonical): outcome,
   verification surface, constraints, boundaries, iteration policy, blocked-stop
   condition — the last slot is the pause-and-escalate contract (below).
6. **One objective, one stopping condition.** No loose lists of unrelated work.
   Multi-workstream asks = one goal per thread per git worktree.
7. **Budget sentence — always, explicitly.** There is NO `--budget` flag. State in
   the goal text either "Set the token budget to N tokens" or "Do not set a token
   budget" — otherwise the model may self-impose one and silently halt (#24629).
   Sizing: ~100k–500k small · 500k–2M medium · 2M–10M large. For hard enforcement
   on ≥0.142.0, optionally add `[features.rollout_budget]` config.
8. **COUNT CHARACTERS before emitting: ≤4,000 Unicode chars hard cap; target
   ≤3,900** for margin (`python3 -c "print(len(open('goal.txt').read()))"`).
   Overflow is version-split: <0.140.0 rejects outright; ≥0.140.0 silently spills
   the text to a `$CODEX_HOME` attachment pointer — don't rely on that (the file
   lives outside the repo). If you're over: move content to the brief doc, don't
   compress the contract. Never PASTE long goals in the Codex Desktop app (pasted
   text becomes an ignored attachment; goal reads as empty — #25346).
9. **GPT-5.5 phrasing:** author an outcome contract — end state, success criteria,
   allowed side effects, evidence rules, output shape. Strip step-by-step process
   prescriptions (5.4-era step lists are an anti-pattern; let it choose the path).
10. **Long-horizon goals get external working memory:** have the goal maintain
    committed files (`PLAN.md` / progress log / a checkable `checklist.md` that
    converts qualitative requirements into verifiable rules) — never rely on model
    memory across compaction.
11. **Meta-prompting note:** if you ask any model to draft a `/goal`, the
    meta-prompt must state the 4,000-char cap — generated goals demonstrably
    overshoot it.

## AGENTS.md (the standing layer)

Codex discovers `~/.codex/AGENTS(.override).md`, then walks git-root → cwd
concatenating `AGENTS.md` files (closer overrides), with a **32 KiB combined cap —
silently truncated** beyond that. Keep it 30–50 lines (≈100 max; nest per-subdir
past that); exact commands over prose; add guidance reactively (same mistake
twice → new line). **Adherence is a strong trained tendency, NOT runtime
enforcement** — name the verify commands imperatively ("run ALL before finishing")
and never assume they auto-run. Include a **Goal Mode Boundaries** section (scope
limits every goal in the repo inherits: forbidden dirs/actions, secrets rules,
done-means). Completeness contract lives here too: deliverables checklist;
blocked items marked `[blocked]` + what's missing; failures recorded with real
errors — never stubbed, silenced, or retried into a pass; for verification tasks
an honest failure IS a successful outcome.

## The pause-and-escalate contract (every goal, non-negotiable)

Four tiers — calibration is the point (stopping for routine failures wastes the
run; never stopping green-washes it):

- **PAUSE & ASK (can't proceed):** missing credential/env, unreachable service,
  auth/quota/ban error (never retry-hammer), genuinely ambiguous spec. Report
  what was tried, the exact blocker, the input needed. Don't guess.
- **CHECKPOINT (defined criterion):** named milestones the user must confirm
  before expensive/irreversible/fan-out work. List them concretely.
- **PAUSE & ESCALATE (assumption invalidated):** a premise the plan depends on
  proves false. Stop and report — never silently work around; that's a design
  change the user owns.
- **RECORD & CONTINUE (not architecture-affecting):** single unit fails →
  honest `no-go`/`[blocked]` + real error, keep going. Naming this tier prevents
  over-pausing.

## Recovery playbook (include a pointer in long goals)

Real blocker → fix it, then `/goal resume`. Post-compaction confusion → `/goal
clear` + re-issue the same objective. Drift → `/goal clear` + restate with
concrete deliverables and a SMALLER budget. (Goal persistence across compaction
improved in 0.141.0.)

## Anti-patterns

Vague/qualitative objectives ("improve performance") · loose multi-task lists ·
one-turn tasks forced into goals · exploration/taste work · irreversible
high-stakes changes without checkpoints · subjective targets · slow feedback
loops · relying on model memory instead of progress files · durable rules crammed
into the goal string · "done = works correctly" instead of a command/artifact
gate · assuming headless `codex exec --goal` (maintainer-confirmed unsupported;
inside `codex exec` you may prompt "Create a goal to …") · escalating reasoning
effort to fix incompleteness (effort enum: `minimal|low|medium|high|xhigh`;
medium default; it's a tuning knob, not a completeness fix).
