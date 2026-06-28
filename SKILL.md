---
name: codex-goals
description: Author optimized OpenAI Codex Goal Mode prompts and the AGENTS.md that backs them, for handing autonomous build, refactor, migration, or verification work to Codex. Use this whenever the user is planning a Codex task, writing or improving a `/goal`, mentions Codex Goal Mode, or wants a handoff a Codex agent will execute end-to-end — even if they don't say the word "goal". Every goal it produces carries a mandatory pause-and-escalate contract so Codex stops and asks the user when an assumption is invalidated, a checkpoint is reached, or a blocker needs human help, instead of green-washing or guessing.
---

# Authoring Codex Goals

Codex **Goal Mode** (`/goal`) is a persistent, evidence-gated objective: Codex loops *plan → act → test → review* across many turns until a verified completion condition is met or a token budget runs out. It will not mark a goal complete on confidence alone — only against real evidence (tests passed, files changed, command output, artifacts). That makes it powerful for autonomous work *and* easy to misuse. This skill exists to package work so Codex finishes it correctly, completely, and stops at the right moments.

For verified feature mechanics, surfaces, GA/version facts, and confidence-flagged sources, read `references/goal-mode-mechanics.md`. For a ready-to-fill scaffold, use `assets/goal-template.md`.

## When Goal Mode fits — and when it doesn't

It fits **mechanical, verifiable** work with a clear definition of done: migrations, refactors, multi-file builds, verification spikes, test/lint cleanups. The decisions are already made; Codex chooses the next *action*, not the product direction.

It does **not** fit taste-dependent or ambiguous work, anything that needs the user's judgment mid-stream, or exploration with no checkable end state. The tell: if "done" can't be proven by a command or artifact, it isn't a goal yet — sharpen the objective first, or use a plain prompt. Forcing Goal Mode onto ambiguous work is the most common way it goes wrong, because there's no honest signal for it to stop on.

## How to author a goal

1. **Confirm mechanics on the installed build first.** `/goal` and especially the budget syntax vary by Codex version. Include a step that checks `codex --help` / the config reference before finalizing — a wrong budget key silently does nothing and the goal can run unbounded.
2. **Split durable rules from the mission.** Repo-wide rules — build/test/lint/verify commands, version pinning, the do-not list, "done means…" — belong in **`AGENTS.md`** at repo root. Codex reads it before working and runs the tests named there before finishing, so it becomes the de-facto done-gate. The **`/goal`** string carries only the moving objective. This keeps the goal short and stops scope drift; cramming durable rules into the goal is the top cause of bloat.
3. **Give the goal all six components** (see Anatomy). Each one closes a specific failure mode; missing any one is why goals under- or over-run.
4. **Make "done" machine-checkable, not prose.** Because completion is evidence-gated, Codex genuinely can't close a goal it can't prove — so hand it something provable. Define done as a concrete artifact plus a command whose exit code or output decides it, never "works correctly."
5. **Add a completeness contract (defeats green-washing).** Require an internal checklist of deliverables; any blocked item is marked `[blocked]` with exactly what's missing; a failed check is recorded with its real error — never stubbed, silenced, or retried into a pass. For a verification task, an honest failure *is* a successful outcome, and the goal should say so.
6. **Add the pause-and-escalate contract** (below). This is non-negotiable — it's the difference between an agent that grinds past a broken premise and one you can trust to run unattended.
7. **Set reasoning effort conservatively and a budget.** `medium` by default; escalate to `high` only for genuinely hard logic; avoid `xhigh` on long runs (it burns the allocation without fixing a missing done-definition). Effort is a last-mile tuning knob, not a substitute for the completeness contract.
8. **Milestone-chunk long builds.** Sequential sub-goals, each with its own "done when," are more reliable than one giant objective and give natural checkpoints.
9. **Require a self-review pass before done:** review the diff, re-run every AGENTS.md check, reconcile every TODO/plan item (zero pending or in-progress), then stop — don't loop re-reading files.
10. **Pin the reporting format** (concise, path-referenced, no file dumps) so the model converges on what you want instead of narrating.

## The pause-and-escalate contract (every goal includes this)

An autonomous agent that never stops will happily certify a broken assumption. So every goal must define, in its own terms, *when to surface to the user instead of pushing through*. Encode four tiers — the point is calibration: stopping for routine failures wastes the run, never stopping green-washes it.

- **Pause & ask the user — can't proceed.** Missing credential/env/config, an unreachable service, an auth/ban/quota error, or a genuinely ambiguous spec. Codex reports what it tried, the exact blocker, and what input it needs — it does not guess.
- **Checkpoint — pause at a defined criterion.** A milestone whose result the user must confirm before expensive, irreversible, or fan-out work proceeds (e.g. "after the first end-to-end success, surface the parsed result and stop"). List the concrete checkpoints.
- **Pause & escalate — an assumption is invalidated.** A premise the *plan depends on* turns out false (the thing being verified fails systemically; a required capability is absent). Codex stops and reports — it must **not** silently fall back to a workaround, because the right move is a design change the user owns.
- **Record & continue — not architecture-affecting.** A single unit fails or is unavailable: log it honestly (`no-go` / `[blocked]` + the real error) and continue. Naming this tier explicitly is what keeps the agent from over-pausing on ordinary failures.

This mirrors good ask-vs-act judgment: *act* on routine failures, *ask or defer* when an assumption breaks or a human is needed to unblock.

## Anatomy of a strong goal

1. **Outcome** — what must be true when done.
2. **Verification surface** — the test/benchmark/artifact/command output that proves it (for a spike, this *is* the deliverable).
3. **Constraints** — what must not regress or change.
4. **Boundaries** — which files, tools, dirs, and hosts Codex may touch.
5. **Iteration policy** — how it picks the next action after each attempt, plus the milestones.
6. **Blocked-stop condition** — the pause-and-escalate contract above.

One-line skeleton: *"`/goal <end state>` verified by `<specific evidence>` while preserving `<constraints>`. Use `<allowed boundaries>`. Between iterations, `<how to choose next>`. If blocked, `<what to report>`."*

## Anti-patterns

- Vague outcomes ("improve performance", "build it") — no completion condition, so the agent fakes "done" or loops aimlessly.
- "Done = works correctly" instead of a command/artifact gate.
- Durable rules in the goal string instead of AGENTS.md — and the inverse, not naming the verify commands in AGENTS.md, which leaves the done-gate soft.
- Reaching for `high`/`xhigh` reasoning to fix incompleteness; it's a tuning knob, not a completeness fix.
- Assuming a headless `codex exec --goal` exists — it isn't documented; verify on the build before designing CI autonomy around it.
- Omitting the pause-and-escalate contract — the agent then green-washes a broken assumption or grinds past a blocker that needed the user.
