# UPGRADE PROTOCOL — codex-goals skill

Self-contained prompt for a Claude Code (Fable) session to refresh this skill.
Run when `Last verified` in `references/goal-mode-mechanics.md` is >30 days old,
when Codex ships a goals-related change, or when a goal authored from this skill
hits a mechanic the skill didn't predict (record that trigger in the changelog).

---

## The prompt (paste verbatim, or say "run skills/codex-goals/UPGRADE.md")

You are upgrading the `codex-goals` skill in this repo. Work evidence-first; never
update a fact from memory.

1. RESEARCH (comprehensive, parallel where possible). Primary sources first:
   - developers.openai.com/codex/changelog — every entry since the reference's
     `Last verified` date.
   - developers.openai.com/cookbook/examples/codex/using_goals_in_codex
   - developers.openai.com/codex/use-cases/follow-goals
   - developers.openai.com/codex/config-reference — budget keys, [features], goals config.
   - The current GPT-5.x prompting guide (effort defaults, goal phrasing).
   - agents.md + Codex docs on AGENTS.md behavior (layering, done-gate).
   - Practitioner/community: GitHub openai/codex issues, Simon Willison, X/HN —
     flag [M]/[L] accordingly.
   Load-bearing facts to ALWAYS re-verify: goal-input character limit and
   overflow behavior; budget syntax (per-goal flag vs config key); evidence-gate
   behavior; /goal subcommands; headless/exec goal support; effort defaults per
   current model generation.

2. EMPIRICAL CHECK (if a Codex build is available on this machine): `codex --version`,
   `codex --help` (goal + budget flags), and — for the character limit — paste a
   known-length test string into `/goal` in a throwaway session and record the
   observed behavior (accepted / truncated at N / rejected). Empirical beats web.

3. DIFF: compare every finding against `references/goal-mode-mechanics.md` and
   `SKILL.md`. List: changed facts (old→new+source), new facts, retired facts.

4. UPDATE: apply the diff to `references/goal-mode-mechanics.md` (bump its
   `Last verified` date, keep confidence flags [H]/[M]/[L]/[U] on every claim),
   `SKILL.md` (authoring doctrine — only if the diff genuinely changes how goals
   should be written), and `assets/goal-template.md`.

5. VERSION: add a `CHANGELOG.md` entry (semver: MAJOR doctrine change / MINOR
   facts-mechanics update / PATCH wording). Include the research date, what
   changed, and the sources.

6. SHIP: commit (`skill(codex-goals): vX.Y.Z — <summary>`), push, and remind the
   operator to `git pull && ./install.sh` on each machine.

Honesty rules: a fact you could not re-verify keeps its old confidence flag and
gains a `re-verify` note — never silently re-assert it. If a source contradicts
the operator's field experience, record both and mark the conflict.
