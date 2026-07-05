# Fill-in template — AGENTS.md + brief doc + Codex `/goal`

Three layers. `AGENTS.md` = durable repo rules (committed at root, ≤~100 lines,
32 KiB combined cap). `docs/goal-brief.md` = mission detail too fat for the goal
(field specs, unit lists, seed data) — committed, referenced by the goal. The
`/goal` = the outcome contract, **≤3,900 Unicode characters (hard cap 4,000) —
COUNT IT before emitting**. Replace every `<…>`.

---

## AGENTS.md (repo root)

```markdown
# <project/task> — agent working agreement

## What this is
<one line>. Completeness and HONEST failure reporting beat polish. Never
fabricate, stub, retry-into-a-pass, or green-wash. An honestly documented
failure/gap IS a successful result on verification work.

## Commands (run ALL after every change and before finishing — imperative,
## adherence is trained tendency not enforcement, so state it plainly)
- Build: `<cmd>`  Test: `<cmd>`  Lint: `<cmd>`
- Verify: `<the command whose output proves the outcome>`

## Goal Mode Boundaries (every goal in this repo inherits these)
- Write scope: only <dirs>. Never touch <dirs/files>.
- No network egress except <allowlist>. No git history edits / force-push.
- Secrets: env only; never print values; custody facts only in docs.
- <irreversible actions> require explicit operator approval — never autonomous.

## Done means
<artifacts exist> + <verify command passes> + failures appear as honest
no-go/[blocked] rows with real errors + committed & pushed with SHA reported.
```

## docs/goal-brief.md (only when mission detail won't fit the goal)

```markdown
# Goal brief — <task>
Deliverables spec: <per-unit required fields, formats, checklists>
Unit inventory: <the full list the goal must cover>
Seed data / candidates: <anything long>
Milestone detail: <expanded from the goal's one-liners>
```

---

## The `/goal` (interactive session in the repo; ≤3,900 chars measured)

```
/goal <desired end state>, verified by <specific evidence/command>, obeying
AGENTS.md (Goal Mode Boundaries + Done means) and docs/goal-brief.md (full
deliverable spec — read it before planning).

OUTCOME: <what must be true; artifacts to emit>.

ACCEPTANCE (a unit passes only if all hold; failures recorded with real errors):
A. <checkable> B. <checkable> C. <checkable>

MILESTONES (verify each before next): M1 <…>; M2 <…>; M3 <…>. Keep the plan
current. Maintain <PLAN.md/checklist.md/progress log> as external working
memory — do not rely on context across compaction.

BUDGET: Set the token budget to <N> tokens. [or: Do not set a token budget.]
EFFORT: medium (escalate to high only for <hard part>; never xhigh).

PAUSE-AND-ESCALATE (stop and report — do not work around):
* PAUSE & ASK: <missing creds / unreachable service / auth-quota errors (never
  retry-hammer) / ambiguous spec>.
* CHECKPOINT: pause at <milestone> for operator confirmation before
  <fan-out/irreversible/expensive step>.
* PAUSE & ESCALATE (assumption invalidated): <plan-load-bearing premises>; if
  false, stop and report — no silent fallback.
* RECORD & CONTINUE: single-unit failures → no-go/[blocked] + real error.

SELF-REVIEW BEFORE DONE: re-run every AGENTS.md command; reconcile every
checklist/TODO to zero; review the diff; then STOP.

REPORTING: <exact final-message shape: paths, SHAs, coverage stats, gap list,
one line per failure>. No file dumps.
```

---

### Pre-emit checklist (the skill's gate)
- [ ] Five-item rubric holds: measurable artifact · one-liner verify command ·
      exact write scope · literal stop condition · pause condition.
- [ ] ONE objective, ONE stopping condition (split multi-workstream asks: one
      goal per thread per worktree).
- [ ] Budget sentence present (explicit set-or-don't).
- [ ] `python3 -c "print(len(open('goal.txt').read()))"` ≤ 3,900.
- [ ] Target build checked: `codex --version` (<0.133 needs goals flag; <0.140
      rejects >4K; <0.142 budget advisory-only).
- [ ] Not pasted into Codex Desktop (paste hole #25346) — type or use CLI/TUI.
```
