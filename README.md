# codex-goals

A [Claude](https://www.anthropic.com/claude) **Agent Skill** for authoring optimized **OpenAI Codex Goal Mode** (`/goal`) prompts — and the `AGENTS.md` that backs them — so you can hand autonomous build, refactor, migration, or verification work to Codex and trust it to finish correctly, completely, and stop at the right moments.

## Why

Codex Goal Mode runs an objective autonomously across many turns (*plan → act → test → review*) until a **verified** completion condition is met. That power cuts both ways: a vague goal gets green-washed as "done," and an agent that never stops will happily certify a broken assumption. This skill encodes the practices that prevent that:

- **Evidence-gated "done"** — completion is defined as a command/artifact a goal can actually prove, never prose like "works correctly."
- **`AGENTS.md` vs goal split** — durable rules (build/test/lint commands, version pinning, do-not list) live in `AGENTS.md`; the `/goal` string carries only the mission. Keeps goals lean and drift-free.
- **A completeness contract** — failed checks are recorded with their real error, never stubbed, silenced, or retried into a pass.
- **A mandatory pause-and-escalate contract** (the headline feature) — every goal tells Codex *when to stop and ask the user* instead of pushing through.

### The pause-and-escalate contract

Four calibrated tiers, so the agent neither over-pauses on routine failures nor grinds past one that needed you:

| Tier | When | What Codex does |
|---|---|---|
| **Pause & ask** | missing creds, unreachable service, auth/ban, ambiguous spec | stop; report what it tried + what input it needs; don't guess |
| **Checkpoint** | a milestone you must confirm before fan-out / irreversible / expensive work | surface the result and stop |
| **Pause & escalate** | a plan-critical **assumption is invalidated** | stop and report — never silently fall back; it's a design change you own |
| **Record & continue** | a single unit fails / is unavailable | log `no-go`/`[blocked]` + the real error, continue |

## Install

Clone (or copy) into your Claude skills directory so Claude can discover it:

```bash
git clone https://github.com/myhome411-boop/codex-goals-skill ~/.claude/skills/codex-goals
```

The skill triggers automatically when you ask Claude to plan a Codex task, write or improve a `/goal`, or produce a Codex handoff — you don't have to name it. It produces a ready-to-paste `AGENTS.md` + `/goal` pair.

## What's inside

```
codex-goals/
├── SKILL.md                          # the skill: when it fits, the authoring procedure, the contract
├── references/goal-mode-mechanics.md # verified Goal Mode mechanics + confidence-flagged sources
└── assets/goal-template.md           # fill-in AGENTS.md + /goal scaffold with the contract pre-wired
```

## Requirements

OpenAI Codex with Goal Mode (`/goal`). Goal Mode reached GA on 2026-05-21; on older builds enable it with `goals = true` under `[features]` in `~/.codex/config.toml` (or `codex features enable goals`). The skill is designed to confirm version-specific details (especially the token-budget syntax) against your installed build rather than assume them.

## Accuracy note

`references/goal-mode-mechanics.md` carries confidence flags and a "last verified" date. Codex Goal Mode is a fast-moving feature; verify version-specific details against the official [Codex docs](https://developers.openai.com/codex) and your installed build.

## Contributing

Issues and PRs welcome — especially corrections to Goal Mode mechanics as Codex evolves, and additional task-type templates. Keep `SKILL.md` lean (progressive disclosure: deep detail goes in `references/`).

## License

[MIT](LICENSE)
