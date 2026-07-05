# Changelog — codex-goals skill

## [2.0.0] — 2026-07-04
MAJOR: doctrine changes from a comprehensive research pass (Claude Fable session,
10-agent verification workflow; all load-bearing facts source-checked, several at
source-code level).

### Added
- **4,000-Unicode-char objective cap** (source: `MAX_THREAD_GOAL_OBJECTIVE_CHARS`,
  codex-rs/protocol; app-server prose) with version-split overflow behavior
  (<0.140.0 hard reject; ≥0.140.0 attachment spill) and a mandatory pre-emit
  character count targeting ≤3,900. Resolves the operator-remembered "~3990".
- Three-layer authoring pattern: AGENTS.md + committed goal-brief doc + short /goal.
- jdhodges five-item pre-flight rubric as a mandatory gate.
- Budget doctrine: no `--budget` flag exists; explicit budget sentence in every
  goal (self-imposed-budget footgun #24629); `[features.rollout_budget]` five keys;
  enforcement only ≥0.142.0; sizing heuristics.
- Fleet version map (0.130.0 / 0.139.0 / 0.142.x behavior differences).
- External working-memory scaffolding for long-horizon goals; recovery playbook;
  Desktop paste hole warning (#25346); meta-prompting cap note; Goal Mode
  Boundaries AGENTS.md section pattern; goal-per-thread lifecycle facts.

### Changed
- AGENTS.md is NOT a runtime done-gate (trained adherence only) — replaced the
  "runs tests before finishing" claim; documented the precise discovery chain +
  32 KiB silent-truncation cap + 30–50-line sizing guidance.
- Effort enum corrected to `minimal|low|medium|high|xhigh`.
- Goals default-on since 0.133.0 (flag only needed below).
- Headless `codex exec --goal`: upgraded from "undocumented" to
  maintainer-confirmed unsupported (#21764).
- Template upgraded to the cookbook's six components with pause-and-escalate
  wired into the blocked-stop slot.

### Meta
- Repo-ized: versioned, installable via `install.sh`, upgradeable via `UPGRADE.md`.

## [1.0.0] — 2026-06-27
Initial skill: authoring doctrine, pause-and-escalate contract, mechanics
reference (first verification pass), fill-in template. Lived only in
`~/.claude/skills/` on one machine (unversioned).
