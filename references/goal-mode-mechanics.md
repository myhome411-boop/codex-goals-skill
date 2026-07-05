# Codex Goal Mode — verified mechanics & sources

> **Last verified: July 4, 2026** (comprehensive multi-source research pass; prior
> pass June 27, 2026). Fast-moving feature — confirm version-sensitive details on
> the installed build (`codex --version`, `codex --help`, config-reference).
> Confidence: **[H]** official (docs/changelog/source code), **[M]** named
> practitioners, **[L]** community, **[U]** unverified.

## The 4,000-character objective cap [H — source-code level]
- `MAX_THREAD_GOAL_OBJECTIVE_CHARS = 4_000` in `codex-rs/protocol/src/protocol.rs`;
  counted via `chars().count()` (**Unicode chars, not bytes**); empty objectives
  rejected. Verified identical at rust-v0.130.0, rust-v0.139.0, and main (2026-07-04).
  Prose confirmation: app-server docs, `thread/goal/set` — objective "must be
  non-empty and at most 4,000 characters". Boundary-tested in PR #27508 (3,999 ok,
  4,000 ok, 4,001 overflow).
- **Overflow is version-split:** CLI **<0.140.0** hard-rejects ("goal objective must
  be at most 4000 characters" — issue #21477); **≥0.140.0** (2026-06-15) silently
  materializes oversized text to `$CODEX_HOME/attachments/<uuid>/goal-objective.md`
  and stores a short pointer as the objective (`/goal` view shows the pointer). The
  pointer itself must fit 4,000 chars. Don't rely on this: the file lives outside
  the repo. [H]
- The cap appears in NO official prose doc besides app-server (cookbook +
  config-reference silent). Community convention: stay ≤3,900–3,999 for margin
  (goalcraft uses 3,999). [H/M]
- **Desktop paste hole:** Codex Desktop (Win 26.527) `/goal` reads only visible
  composer text; large pastes become an ignored `Pasted text.txt` attachment and
  the goal is EMPTY. Issue #25346 open as of 2026-07-04. Never paste long goals in
  Desktop. [H]

## Budget — settled [H]
- **No per-goal `--budget` CLI flag exists or ever did** (debunked by jdhodges on
  0.129.0; absent from `codex --help`, config-reference, cookbook). Never emit one.
- **Per-goal budget** = `tokenBudget`/`token_budget` field on the goal object
  (app-server `thread/goal/set`; read-only `tokensUsed`, `timeUsedSeconds`). From
  the TUI the MODEL sets it when creating the goal → **request it in the goal
  text**: "Set the token budget to N tokens" or "Do not set a token budget".
  Footgun: the model can SELF-IMPOSE an unrequested budget and silently halt
  (issue #24629, 180k unrequested) — always state budget expectations. [H]
- **Config-level:** `[features.rollout_budget]` — `enabled` (bool), `limit_tokens`
  (required when enabled), `prefill_token_weight` (1.0), `sampling_token_weight`
  (1.0), `reminder_interval_tokens` (default 10% of limit). Still "under
  development and off by default" (config-reference, 2026-07-04). No `[goals]`
  config section exists. [H]
- **Enforcement is version-gated:** hard enforcement (cross-thread usage tracking,
  remaining-budget reminders, turn abort on exhaustion) shipped **0.142.0**
  (2026-06-22). Before that: advisory only. Exhaustion → `budget_limited` state,
  graceful wrap-up — never counts as completion. [H]
- Sizing heuristics [M]: ~100k–500k small single-module · 500k–2M multi-file
  refactor · 2M–10M large migration. Datapoint: ~189k tokens for a 5-minute
  verified run (jdhodges).

## Availability & surfaces [H]
- GA 2026-05-21; introduced ~0.128.0 behind `[features] goals = true`;
  **default-on since 0.133.0** (older builds need the flag or
  `codex features enable goals`).
- `/goal <objective>` set · bare `/goal` view (this IS the status check) ·
  `/goal pause|resume|clear`. No other subcommands. Surfaces: CLI/TUI, IDE
  extension, Codex app (app 26.519 shipped without `/goal` — #23978), iOS
  (added 2026-06-09; composer goal editing since 0.142.0).
- **Headless:** `codex exec --goal` is maintainer-confirmed unsupported
  (discussion #21764). Inside `codex exec` you can prompt "Create a goal to …";
  one goal per thread; goals are per-thread objects (`thread/goal/set`).

## Execution semantics [H]
- Evidence-gated completion: never complete on model confidence; evidence =
  tests/benchmarks/logs/reports/screenshots/artifacts/user confirmation. Time
  elapsed and budget exhaustion never count. Statuses:
  `active|paused|budget_limited|complete`. Model-side `update_goal` can only mark
  complete; pause/resume/clear/budget are user/system-controlled. Injected audit
  rule: "map every explicit requirement to concrete evidence… treat uncertainty
  as not achieved."
- Auto-continue only at safe boundaries (turn done, nothing pending, no queued
  input, goal active, budget remaining). Plan-only turns don't auto-continue. A
  continuation turn with ZERO tool calls sets `continuation_suppressed` — two
  talk-only turns stall the loop. Interruptions pause the goal; 0.142.0 pauses
  goals before TUI interrupts.
- Lifecycle: 0.140.0 allows a new goal after the prior completes; 0.141.0 fixed
  goal-first threads missing from `thread/list`/`thread/search` (pre-0.141
  compaction could lose goal visibility).

## AGENTS.md [H]
- Discovery: `~/.codex/AGENTS.override.md` OR `~/.codex/AGENTS.md` (first
  non-empty wins) → git root walked DOWN to cwd (override → AGENTS.md →
  fallbacks per level), concatenated root-downward so closer files win by
  appearing later. **32 KiB combined cap (`project_doc_max_bytes`) — SILENT
  truncation.**
- **NOT a runtime done-gate:** Codex does not automatically run tests named
  there. Adherence is a strong trained tendency — write commands imperatively.
- Sizing [M, incl. Princeton study Mar 2026]: 30–50 lines to start, ~100 max,
  nest per-subdir beyond; good files cut runtime ~29%/tokens ~17%; bloated
  auto-generated 200+-line files RAISED cost up to 23%. Add guidance reactively;
  exact commands over prose. Ecosystem: agents.md (Linux Foundation / Agentic AI
  Foundation), 20+ tools.
- Placement doctrine [H]: AGENTS.md = standing repo rules · Skills = repeated
  prompts · plain prompts = one-offs · one goal per thread per git worktree.
- Emerging content categories [M]: hook policies, MCP constraints, skill routing
  hints, security zones, model/effort profiles, **Goal Mode Boundaries** (repo-
  wide scope limits every goal inherits).

## Effort & phrasing [H]
- Codex config enum: `model_reasoning_effort = minimal|low|medium|high|xhigh`
  (the API guide's "none" naming doesn't exist in Codex config — emit `minimal`).
  GPT-5.5 default medium; "higher effort isn't automatically better" — tuning
  knob, not a completeness fix. GPT-5.4-class defaults minimal/none — set
  explicitly.
- GPT-5.5 goal phrasing: outcome contract (end state, success criteria, allowed
  side effects, evidence rules, output shape); REMOVE step-by-step process
  prescriptions (5.4-era step lists are now an anti-pattern).
- Cookbook authoring rules: SINGLE objective, ONE stopping condition, no loose
  lists; include reference materials, validation artifacts, checkpoint workflow
  with progress logging; "done" fixed before execution. Six template components:
  outcome, verification surface, constraints, boundaries, iteration policy,
  blocked-stop condition.
- jdhodges pre-flight rubric [M]: measurable artifact · one-liner verification
  command · exact write scope · literal stop condition · pause condition — "if
  you can't fill all five, you're hoping."

## Fleet version map (operator's machines, 2026-07-04)
| CLI | Goals default-on | >4K goal | Budget enforcement | Notes |
|---|---|---|---|---|
| 0.130.0 (mac-studio) | NO — needs `[features] goals=true` | hard reject | none (advisory) | pre-0.141 thread/list bug |
| 0.139.0 (ubuntu) | yes | hard reject | none (advisory) | pre-0.141 thread/list bug |
| 0.142.3 / 0.142.5 (air / mac-mini) | yes | attachment spill | FULL (track/remind/abort) | pause-before-interrupt, audit item IDs |

## Primary sources
- Cookbook "Using Goals in Codex": developers.openai.com/cookbook/examples/codex/using_goals_in_codex [H]
- Changelog: developers.openai.com/codex/changelog (0.140.0/0.141.0/0.142.0 entries) [H]
- Follow-goals use case: developers.openai.com/codex/use-cases/follow-goals [H]
- Config reference: developers.openai.com/codex/config-reference (rollout_budget, model_reasoning_effort, project_doc_max_bytes) [H]
- App-server API: developers.openai.com/codex/app-server (thread/goal/set; 4,000-char prose; tokenBudget) [H]
- AGENTS.md guide: developers.openai.com/codex/guides/agents-md + agents.md [H]
- Source: github.com/openai/codex — codex-rs/protocol/src/protocol.rs (MAX_THREAD_GOAL_OBJECTIVE_CHARS), codex-rs/tui/src/goal_files.rs; PRs #27508/#27509/#27510; issues #21477, #24629, #25346, #23978; discussion #21764 [H]
- Practitioners: jdhodges.com/blog/codex-goal-feature-review · codex.danielvaughan.com (2026-05-03, 2026-06-15) · ralphable.com · adityabawankule.io/blog/codex-goal-meta-prompting · hayduk/lenny writeups · goalcraft (grp06) + patleeman goal-contract gist [M]
