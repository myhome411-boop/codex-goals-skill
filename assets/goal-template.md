# Fill-in template — AGENTS.md + Codex `/goal`

Two parts. `AGENTS.md` holds durable rules (committed at repo root). The `/goal` carries the mission. Replace every `<…>`.

---

## AGENTS.md (repo root)

```markdown
# <project/task> — agent working agreement (persists across all turns)

## What this is
<one line: product vs spike; what "good" means>. Completeness and HONEST failure
reporting beat polish. Never fabricate, stub, retry-into-a-pass, or green-wash.

## Commands (these define DONE — run ALL after every change and before finishing)
- Build: `<cmd>`   Test: `<cmd>`   Types: `<cmd>`   Lint: `<cmd>`
- Run/verify: `<the command whose output proves the outcome>`

## Conventions
- <language/runtime>; <Dockerized?>; pin EVERY dependency to an exact `==` version.
- <domain-specific invariants the agent must never violate>.
- Secrets from env (gitignored). Never hard-code or print them.

## Do-not (hard)
- No network egress except <allowlist>. Do not edit outside <dir/>.
- Do not touch git history, CI, or secrets. No `git reset --hard` / `git checkout --`.
- No broad try/except that swallows a failure. A failed check is RECORDED with its
  real error — never silenced, retried into a pass, or stubbed.

## Done means
<concrete artifacts exist + the verify command passes + failures appear as honest
no-go/blocked rows>.
```

---

## The `/goal` (paste into an interactive Codex session in the repo)

```
/goal <desired end state>, verified by <command/artifact that proves it> while obeying AGENTS.md.

OUTCOME: <what must be true; the artifact(s) to emit>.

ACCEPTANCE CHECKS (a unit passes only if all hold; a failure is recorded with its real error — never stub/skip silently):
  A. <checkable condition>
  B. <checkable condition>
  ...

ITERATION POLICY (milestones; verify each before the next): M1 <…>; M2 <…>; ... Update the plan on any scope change; do not let it go stale.

REASONING EFFORT (of THIS Codex run): medium; escalate to high only for <hard part> if needed; do NOT use xhigh.

PAUSE-AND-ESCALATE CONTRACT (stop the goal and report — do not work around):
  * PAUSE & ASK THE USER (cannot proceed): <missing creds/services unreachable/auth/ambiguous spec>.
  * CHECKPOINT — PAUSE at: <milestone(s) the user must confirm before fan-out/irreversible/expensive work>.
  * PAUSE & ESCALATE (assumption invalidated — do NOT silently fall back): <premise the plan depends on; if false, stop and report — it's a design change>.
  * RECORD & CONTINUE (not architecture-affecting): a single unit fails (record no-go + real error) or is unavailable (mark [blocked] + what's missing) — continue the rest.

SELF-REVIEW BEFORE DONE: review the diff, re-run every AGENTS.md command, reconcile all TODO/plan items (zero pending/in_progress), then STOP — do not loop re-reading files.

REPORTING (concise, path-referenced — no file dumps): <the exact tables/summary you want; one-line reason per failure; reference result paths>.

BUDGET: set a token budget before launching (confirm exact syntax via `codex --help` / config-reference). Do not run unbounded.
```

---

### Notes
- Enable goals if pre-GA: `goals = true` under `[features]` in `~/.codex/config.toml`, or `codex features enable goals`.
- Set `reasoning_effort` explicitly on any GPT-5.4-class call (its default is `none`).
- Keep the goal "narrow enough to audit, broad enough to let Codex choose the next action" — don't micromanage the path on GPT-5.5.
