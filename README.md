| [中文](README.zh.md) | English |
| -------------------- | ------- |

# agent-gitignore

AI coding harnesses — Claude Code, Cursor, Aider, Qwen Code and friends — leave things behind in your workspace: chat histories, plan files, caches, auto-generated skills, and personal settings. Most of it should stay out of version control. Meanwhile, a few files that look like clutter — `AGENTS.md`, `.agents/`, `.zcodeignore` — are designed to be committed.

This repository collects the files that common AI coding harnesses create in a workspace but you probably don't want in version control, verifies every entry against official documentation, and provides ready-to-use example `.gitignore` files.

## Quick Start

Copy [examples/agent.gitignore](examples/agent.gitignore) into your repository root as `.gitignore`, or append the sections you need:

```bash
# Overwrite .gitignore with the full version
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore -o .gitignore

# Or merge into an existing .gitignore
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore >> .gitignore
```

Two flavors are available:

- [examples/agent.gitignore](examples/agent.gitignore) — the full version. Follows official defaults where they exist (for example, Aider ignores `.aider*` by itself) and marks case-by-case entries as comments.
- [examples/agent-conservative.gitignore](examples/agent-conservative.gitignore) — a minimal subset: only unambiguous runtime state, caches, and personal files. Nothing here hides a shareable config.

On gitignore semantics: patterns without a slash match at any directory level, while a `**/` prefix covers every level of nested directories — so `**/.claude/settings.local.json` also protects nested worktrees.

## Overview

| Harness            | Recommended to ignore                                                                                   | Designed to be committed                                            | Notes                                                      |
| ------------------ | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ---------------------------------------------------------- |
| Aider              | `.aider*`                                                                                               | `.aider.conf.yml`, `.aiderignore` (if shared)                       | Aider writes `.aider*` into `.gitignore` by default        |
| Claude Code        | `CLAUDE.local.md`, `.claude/settings.local.json`, `.claude/agent-memory-local/`                         | `CLAUDE.md`, `.mcp.json`, everything else in `.claude/`             | `settings.local.json` is auto-excluded via global excludes |
| Cline              | —                                                                                                       | `.clinerules/` or `.cline/`, `.clineignore`                         | Runtime state lives in `~/.cline/`                         |
| CodeBuddy          | `.codebuddy/settings.local.json`, `CODEBUDDY.local.md`                                                  | `CODEBUDDY.md`, everything else in `.codebuddy/`                    | `settings.local.json` is auto-added to `.gitignore`        |
| Codex              | —                                                                                                       | `AGENTS.md`, `.codex/skills/`, `.agents/skills/`                    | `.codex/config.toml` depends on its content                |
| Cursor             | —                                                                                                       | `.cursor/rules/`, `.cursorignore`                                   | `.cursor/mcp.json` may hold secrets                        |
| DeepSeek Harness   | `AGENTS.local.md`, `CLAUDE.local.md`                                                                    | `AGENTS.md`, `CLAUDE.md`                                            | Local overlays are "deliberately not committed"            |
| Gemini CLI         | —                                                                                                       | `GEMINI.md`, `.gemini/settings.json`, `.gemini/commands/`           | Checkpoints live in `~/.gemini/`, not in the project       |
| GitHub Copilot     | —                                                                                                       | `.github/copilot-instructions.md`, `.github/instructions/`          | CLI runtime data lives in `~/.copilot/`                    |
| Google Antigravity | —                                                                                                       | `.agents/` (legacy `.agent/`)                                       | `.agents/` is read by several harnesses; do not ignore it  |
| Hermes Agent       | `AGENTS.override.md`                                                                                    | `.hermes.md`, `HERMES.md`                                           | Officially "typically gitignored"                          |
| Kilo Code          | —                                                                                                       | `kilo.jsonc`, `.kilo/rules/`, `.kilocodeignore`                     | `.kilo/tui.json` is a personal preference                  |
| MiMo Code          | `.mimocode/cache/`, `.mimocode/wiki/`, `.mimocode/wikis/`, `.mimo-worktrees/`                           | `.mimocode/` (config, skills, workflows)                            | Entries mirror the official repository's own `.gitignore`  |
| OpenCode           | `.opencode/plans/`, `.opencode/node_modules/`, `.opencode/package.json`, `.opencode/package-lock.json`  | `opencode.json`, `.opencode/` (agents, commands, plugins, ...)      | Plugin dependencies are auto-installed into `.opencode/`   |
| Pi                 | `AGENTS.override.md`                                                                                    | `.pi/` (settings, skills, prompts, ...)                             | Sessions live in `~/.pi/agent/sessions/`                   |
| Qwen Code          | `.qwen/skills/auto-skill-*/`, `.qwen/skills/learned-skill-*/`, `.qwen/pending-skills/`, `.qwen-session` | `QWEN.md`, `.qwen/commands/`, `.qwen/agents/`, `.qwen/team-memory/` | The official repository ignores `.qwen/*` with a whitelist |
| Replit             | `.local/`                                                                                               | `.replit`, `replit.nix`, `replit.md`                                | Local Agent skills live in `.local/secondary_skills/`      |
| Trae               | —                                                                                                       | `.trae/rules/`                                                      | Memories live in the user home directory                   |
| Windsurf           | `AGENTS.local.md`, `.devin/config.local.json`, `.devin/mcp_config.local.json`                           | `.devin/` (rules, skills, config), `.windsurf/` (legacy)            | Renamed Devin Desktop in June 2026                         |
| ZCode              | `.zcode/` (or just `.zcode/plans/`)                                                                     | `AGENTS.md`, `.zcodeignore`, `.zcode/skills/`                       | Session plans are runtime artifacts                        |
| Zed                | —                                                                                                       | `.rules`, `.zed/`, `.agents/skills/`                                | Sessions live in Zed's user data directory                 |

## Harnesses

### [Aider](https://aider.chat)

> Documentation: <https://aider.chat/docs/config/options.html>

Recommended to ignore:

- `.aider*` — chat history (`.aider.chat.history.md`), input history (`.aider.input.history`), repo-map cache (`.aider.tags.cache.v4/`), and more. The official `--gitignore` switch is on by default, so Aider writes `.aider*` into your `.gitignore` on first run.

Keep in version control (un-ignore if needed):

- `.aider.conf.yml` — team configuration when placed at the repository root
- `.aiderignore` — declares which files Aider should not touch

### [Claude Code](https://claude.ai/code)

> Documentation: <https://code.claude.com/docs/en/claude-directory>

Recommended to ignore:

- `CLAUDE.local.md` — personal instructions; the docs say "Create it manually and add it to `.gitignore`"
- `.claude/settings.local.json` — personal settings overriding project defaults. Claude Code adds `**/.claude/settings.local.json` to your global git excludes the first time it writes the file; add it to `.gitignore` yourself if you created the file by hand
- `.claude/agent-memory-local/` — local agent memories, "keep out of version control"

Keep in version control:

- `CLAUDE.md`, `.mcp.json` (secrets via `${VAR}` references), `.worktreeinclude`
- `.claude/settings.json`, `.claude/rules/`, `.claude/skills/`, `.claude/commands/`, `.claude/agents/`, `.claude/workflows/`, `.claude/agent-memory/`

### [Cline](https://cline.bot)

> Documentation: <https://docs.cline.bot/getting-started/config>

Recommended to ignore:

- Nothing — sessions, tasks, checkpoints, and API keys live in `~/.cline/`, and Cline keeps its checkpoint shadow repository outside your project's Git history

Keep in version control:

- `.clinerules/` (or `.cline/rules/`) — workspace rules; `.cline/` also holds shareable `skills/`, `hooks/`, `agents/`, `plugins/`, `cron/`
- `.clineignore` — works like `.gitignore` for Cline's file access (deprecated by upstream)

Notes:

- `memory-bank/` holds plain Markdown project memory and is meant to be shared

### [CodeBuddy](https://www.codebuddy.ai)

> Documentation: <https://www.codebuddy.ai/docs/cli/codebuddy-dir>

Recommended to ignore:

- `.codebuddy/settings.local.json` and `CODEBUDDY.local.md` — officially labeled "Auto-added to .gitignore"

Keep in version control:

- `CODEBUDDY.md`, `.codebuddy/settings.json`, `.codebuddy/agents/`, `.codebuddy/rules/`, `.codebuddy/skills/`, `.codebuddy/commands/`

### [Codex](https://github.com/openai/codex)

> Documentation: <https://developers.openai.com/codex/guides/agents-md>

Recommended to ignore:

- Nothing documented — sessions, history, and auth all live in `~/.codex/`

Keep in version control:

- `AGENTS.md`, `.codex/skills/`, `.agents/skills/` — Codex discovers `.agents/skills/` at every level from the project root down

Case by case:

- `.codex/config.toml` — project-level configuration layer; share hooks and permissions, keep personal settings local (no official `.local` convention exists)

### [Cursor](https://cursor.com)

> Documentation: <https://cursor.com/docs/context/rules>

Recommended to ignore:

- Nothing documented — IDE state lives outside the project

Keep in version control:

- `.cursor/rules/*.mdc` — "Check your rules into git so your whole team benefits"
- `.cursorignore` — limits which files AI can access

Case by case:

- `.cursor/mcp.json` — project MCP servers; ignore it if it holds plaintext secrets, or switch to `${env:VAR}` references and commit it

### [DeepSeek Harness](https://www.deepseek.com/harness/en/)

> Documentation: <https://github.com/deepseek-ai/deepseek-harness>

Recommended to ignore:

- `AGENTS.local.md`, `CLAUDE.local.md` — additive per-developer overlays, "deliberately not committed" per the official design notes

Keep in version control:

- `AGENTS.md`, `CLAUDE.md` — base instructions loaded from the project root down to the session directory

### [Gemini CLI](https://geminicli.com)

> Documentation: <https://geminicli.com/docs/cli/settings>

Recommended to ignore:

- Nothing documented — checkpoints and conversation history live in `~/.gemini/`, not in the project

Keep in version control:

- `GEMINI.md`, `.gemini/commands/*.toml` — "can be committed to version control and shared with your team"
- `.geminiignore` — Gemini CLI's own access filter, like `.gitignore`

Case by case:

- `.gemini/settings.json` — workspace settings override user settings; review for personal values before committing

### [GitHub Copilot](https://github.com/features/copilot)

> Documentation: <https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot>

Recommended to ignore:

- Nothing — CLI configuration and session data live in `~/.copilot/`, and the cloud coding agent works through pull requests

Keep in version control:

- `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md`, `AGENTS.md`

### [Google Antigravity](https://antigravity.google)

> Documentation: <https://antigravity.google/docs/rules-workflows/>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.agents/rules/`, `.agents/workflows/`, `.agents/skills/` — workspace assets (legacy `.agent/` is still read; the plural `.agents/` wins when both exist)
- `GEMINI.md` in the project root is also read

Notes:

- Do not ignore `.agents/` — Codex, Zed, and Replit read the same directory for skills

### [Hermes Agent](https://hermes-agent.nousresearch.com)

> Documentation: <https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files>

Recommended to ignore:

- `AGENTS.override.md` — "Personal, per-directory override of AGENTS.md (typically gitignored)"

Keep in version control:

- `.hermes.md` or `HERMES.md` — highest-priority project instructions (priority order: `.hermes.md` → `AGENTS.override.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules`)

### [Kilo Code](https://kilo.ai)

> Documentation: <https://kilo.ai/docs/customize/custom-rules>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `kilo.jsonc` — project configuration; committed project config cannot use `{env:VAR}` references, so keep secrets in global config
- `.kilo/rules/` (legacy `.kilocode/rules/`), `.kilocodeignore`

Case by case:

- `.kilo/tui.json` / `.kilo/tui.jsonc` — terminal-UI preferences (sounds, theme, keybindings); personal rather than team material

### [MiMo Code](https://mimo.xiaomi.com/mimocode)

> Documentation: <https://github.com/XiaomiMiMo/MiMo-Code>

Recommended to ignore:

- `.mimocode/cache/`, `.mimocode/wiki/`, `.mimocode/wikis/`, `.mimo-worktrees/` — the same local state the official MiMo-Code repository ignores itself

Keep in version control:

- `.mimocode/mimocode.json` (or `.jsonc`), `.mimocode/agent/`, `.mimocode/skills/`, `.mimocode/workflows/`

Notes:

- Sessions, checkpoints, and logs live in `~/.local/share/mimocode/` and `~/.cache/mimocode/`

### [OpenCode](https://opencode.ai)

> Documentation: <https://opencode.ai/docs/config/>

Recommended to ignore:

- `.opencode/plans/` — plan files written by plan mode
- `.opencode/node_modules/`, `.opencode/package.json`, `.opencode/package-lock.json` — plugin dependencies that OpenCode auto-installs once `.opencode/` exists (OpenCode writes its own `.opencode/.gitignore` for these)

Keep in version control:

- `opencode.json` / `opencode.jsonc` — "safe to be checked into Git"
- `.opencode/agents/`, `.opencode/commands/`, `.opencode/plugins/`, `.opencode/skills/`, `.opencode/tools/`, `.opencode/themes/`
- `AGENTS.md` — "You should commit your project's AGENTS.md file to Git"

### [Pi](https://pi.dev)

> Documentation: <https://pi.dev/docs/latest/configuration>

Recommended to ignore:

- `AGENTS.override.md` — replaces `AGENTS.md` or `CLAUDE.md` in the same directory only; personal by convention

Keep in version control:

- `.pi/settings.json`, `.pi/SYSTEM.md`, `.pi/APPEND_SYSTEM.md`, `.pi/skills/`, `.pi/extensions/`, `.pi/prompts/`, `.pi/themes/` — the official repository commits its own `.pi/` directory

Notes:

- Sessions live in `~/.pi/agent/sessions/`, grouped by working directory

### [Qwen Code](https://github.com/QwenLM/qwen-code)

> Documentation: <https://github.com/QwenLM/qwen-code/blob/main/.gitignore>

Recommended to ignore:

- `.qwen/skills/auto-skill-*/` — generated by the managed-skill extraction agent
- `.qwen/skills/learned-skill-*/` — generated by the `/learn` command
- `.qwen/pending-skills/` — staging area for auto-generated skills
- `.qwen-session` — developer-local session identifier created by `qwen serve`

Keep in version control:

- `QWEN.md`, `.qwen/commands/`, `.qwen/agents/`, hand-written `.qwen/skills/`, `.qwen/team-memory/` ("shared with collaborators THROUGH git"), `.qwen/review-context.json`

Notes:

- The official repository goes further and ignores `.qwen/*` wholesale with a whitelist of the shareable paths above

### [Replit](https://replit.com)

> Documentation: <https://docs.replit.com/references/configuration/configuration>

Recommended to ignore:

- `.local/` — locally installed Agent skills live in `.local/secondary_skills/`

Keep in version control:

- `.replit`, `replit.nix` — listed by `[gitHubImport]` `requiredFiles` defaults, so they are expected to travel with the repository

Case by case:

- `replit.md` — auto-maintained by Replit Agent; commit it if it holds team conventions
- `.agents/skills/` — installed skills are regular files and can be shared

### [Trae](https://trae.ai)

> Documentation: <https://docs.trae.cn/ide_rules>

Recommended to ignore:

- Nothing documented — memories and global rules live in `~/.trae-cn/`, and no runtime artifacts are written into the project

Keep in version control:

- `.trae/rules/*.md` — project rules, nestable up to three levels

Notes:

- Trae also reads `AGENTS.md`, `CLAUDE.md`, and `CLAUDE.local.md`; ignore the `.local.` variant as usual

### [Windsurf](https://windsurf.com)

> Documentation: <https://docs.devin.ai/cli/reference/configuration/global-vs-local>

Recommended to ignore:

- `AGENTS.local.md` — "Add it to your `.gitignore` so it stays local"
- `.devin/config.local.json`, `.devin/mcp_config.local.json` — personal overrides and local MCP secrets, officially labeled "No (gitignored)"

Keep in version control:

- `.devin/rules/*.md`, `.devin/global_rules.md`, `.devin/config.json`, `.devin/mcp_config.json`, `.devin/skills/*/SKILL.md`
- `.windsurf/rules/*.md`, `.windsurfrules`, `.windsurf/skills/` — legacy paths, still read

Notes:

- Windsurf was renamed Devin Desktop in June 2026; the CLI auto-excludes `*.local.json` files via `.git/info/exclude`
- Cascade memories live in `~/.codeium/windsurf/memories/` and never enter the repository

### ZCode

> Documentation: not publicly hosted; entries below reflect observed behavior in local workspaces

Recommended to ignore:

- `.zcode/` — workspace directory holding session data such as `.zcode/plans/plan-sess_<uuid>.md`; ignoring the whole directory is the simplest choice when you do not share workspace assets
- Alternative: ignore only `.zcode/plans/` to keep `.zcode/skills/` and `.zcode/commands/` shareable

Keep in version control:

- `AGENTS.md`, `.zcodeignore` — the context-exclusion policy belongs with the repository, just like `.gitignore` itself
- `.zcode/config.json`, `.zcode/skills/`, `.zcode/commands/` — workspace-scope configuration, "can be shared with a team through version control"

### [Zed](https://zed.dev)

> Documentation: <https://zed.dev/docs/ai/instructions>

Recommended to ignore:

- Nothing — sessions and threads live in Zed's user data directory, and Zed creates no runtime files in the project

Keep in version control:

- `.rules` — the always-on instructions file (priority: `.rules` → `.cursorrules` → `.windsurfrules` → `.clinerules` → `.github/copilot-instructions.md` → `AGENT.md` → `AGENTS.md` → `CLAUDE.md` → `GEMINI.md`)
- `.zed/settings.json`, `.zed/tasks.json`, `.zed/debug.json`, `.agents/skills/`

## Do Not Ignore These

These look like harness clutter but are designed to be committed:

- Root instruction files: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `QWEN.md`, `CODEBUDDY.md`
- The `.agents/` directory — a cross-harness skills location read by Codex, Zed, Replit, Google Antigravity, and others
- Rule directories: `.cursor/rules/`, `.claude/rules/`, `.trae/rules/`, `.devin/rules/`, `.kilo/rules/`, `.clinerules/`
- Ignore-policy files themselves: `.zcodeignore`, `.aiderignore`, `.cursorignore`, `.geminiignore`, `.clineignore`, `.kilocodeignore`

The recurring naming convention for personal files is the `.local.` / `.override.` suffix (`AGENTS.local.md`, `CLAUDE.local.md`, `AGENTS.override.md`) and `settings.local.json`. Those are the entries this repository collects. Runtime state such as sessions, caches, and plans mostly lives in the user home directory, so a well-behaved harness leaves little more than shareable configuration in your project.

## Not Yet Covered

These harnesses also write into workspaces, but verified entries are not collected yet: Augment Code, Amp, Crush, Devin (cloud), Goose, Jules, Junie, Kiro, Serena. Contributions are welcome — see [AGENTS.md](AGENTS.md).

## Contributing

Issues and pull requests are welcome. Maintenance guidelines — entry verification requirements, document structure, ordering conventions — live in [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
