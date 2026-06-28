# Codex Goal Mode — verified mechanics & sources

> Last verified June 27, 2026. This is a fast-moving feature — treat version-specific
> details as a starting point and confirm against the installed Codex build
> (`codex --help`, the config reference). Confidence flags below: **[H]** high
> (official: cookbook / changelog / use-case / config-reference), **[M]** medium
> (named practitioners), **[L]** low (community/listicle — verify before relying).

## What it is
- "Goals" / "Goal Mode" is a GA Codex feature [H]. A goal is *stateful, persistent work*: Codex treats a larger objective as ongoing rather than a single disposable turn and drives toward it across many turns/hours. Framing: *"A normal prompt says: do this next thing. A Goal says: keep working until this outcome is true."* [H]
- **Evidence-gated completion** is the defining mechanic: a goal "cannot be marked complete based on model confidence alone — it must be verified against files changed, commands run, tests passed, benchmark output, generated artifacts, or research evidence." [H]
- Architecture: *thread-scoped, lifecycle-controlled, budget-aware, evidence-gated.* It is persisted thread state tied to the live session — not global memory or a referenceable cloud object. [H]

## Surfaces & commands
- `/goal <objective>` to set; bare `/goal` to view; `/goal pause | resume | clear` to control. [H]
- Available in Codex CLI/TUI, IDE extension, app, and Mobile (mobile `/goal` added 2026-06-09). [H]
- GA on 2026-05-21. Introduced ~late April 2026 (CLI 0.128.0) behind a flag. Pre-GA enable: `goals = true` under `[features]` in `~/.codex/config.toml`, or `codex features enable goals`. [H for GA date/flag; exact build range M]

## Execution & autonomy
- After each turn Codex inspects concrete evidence to decide whether the outcome is met. It auto-continues only at safe boundaries: turn finished, nothing pending, no user input queued, goal active, budget remaining. Plan-only turns do not auto-continue. [H]
- Interruptions pause the goal. Injecting input (you or a hook) halts the loop until resumed — don't expect it to grind through a paused state. You can submit a message mid-run to steer it. [H]
- It stops when: evidence confirms the outcome; budget/quota exhausted (it summarizes progress + next steps); user pauses/clears; an honest blocker with no defensible path; or user input needs attention. [H]

## Budget (version-sensitive — confirm locally)
- Goal runs are token-budget gated. An unbounded goal on a high-effort flagship model can consume an entire multi-hour allocation in one session — always set a budget. [H/M]
- Exact syntax is unsettled [M/L]: third-party sources show a per-goal `--budget <N>` flag; the official config-reference exposes `features.rollout_budget` (e.g. `features.rollout_budget.limit_tokens`) rather than a `[goals] token_budget` key. Do not hard-code — confirm via `codex --help` / installed config-reference. A wrong key silently does nothing.

## Reasoning effort (when Codex or its subagents pick effort)
- The GPT-5.5-class flagship takes none/low/medium/high/xhigh and defaults to medium. The prior GPT-5.4-class model defaults to none (set it explicitly). `xhigh` ("Extra High") is for the hardest async/eval tasks. [H]
- Official guidance: "higher reasoning effort isn't automatically better" — it's a last-mile tuning knob, not the way to fix incompleteness. Add completeness contracts + verification loops before escalating effort. [H]

## AGENTS.md (the done-gate)
- Auto-loads; Codex reads it before working. It is trained to run the tests named in AGENTS.md before finishing — so put exact build/test/lint/verify commands there and state they must all pass. [H]
- Layering: `~/.codex/AGENTS.md` (global) < repo-root (project) < nested subdir (closest wins, appended last). [H]

## Anti-patterns (sourced)
- Vague outcomes (weak `/goal Improve performance` vs strong `Reduce p95 latency below 120ms on the checkout benchmark while keeping the correctness suite green`) — the #1 cause of fake "done." [H]
- Overloading the goal with durable rules instead of AGENTS.md; or not naming verify commands in AGENTS.md (soft gate). [H]
- Assuming headless `codex exec --goal` — not officially documented; Goal Mode is the interactive flow. Verify on the build before designing CI autonomy around it. [H]
- Goal Mode for taste-dependent/ambiguous design — explicit anti-pattern; decisions must be predetermined. [H]
- Porting old eager-prompt scaffolding wholesale to the newer flagship — start from the smallest prompt that preserves the contract; the newer model wants the outcome defined and room to choose the path. [H]

## Primary sources
- OpenAI Cookbook — "Using Goals in Codex": developers.openai.com/cookbook/examples/codex/using_goals_in_codex [H]
- Codex Changelog (GA 2026-05-21; mobile /goal 2026-06-09): developers.openai.com/codex/changelog [H]
- "Follow a goal" — Codex use cases: developers.openai.com/codex/use-cases/follow-goals [H]
- Codex Configuration Reference (features.rollout_budget): developers.openai.com/codex/config-reference [H]
- "Using GPT-5.5" (effort defaults, last-mile-knob): OpenAI docs [H]
- Simon Willison — "Codex CLI 0.128.0 adds /goal" (2026-04-30) [H]
- Aditya Bawankule — "/goal meta-prompting for days of autonomous work" [M]
