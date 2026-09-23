| [中文](README.zh.md) | English |
| -------------------- | ------- |

# agent-gitignore

AI coding harnesses — CLI agents, IDE assistants, and review agents such as Claude Code, Cursor, CodeRabbit, and Qwen Code — leave things behind in your workspace: chat histories, plan files, caches, auto-generated skills, and personal settings. Most of it should stay out of version control. Meanwhile, a few files that look like clutter — `AGENTS.md`, `.agents/`, `.zcodeignore` — are designed to be committed.

This repository collects the workspace artifacts of 47 AI coding harnesses, verifies every entry against official documentation, and provides ready-to-use example `.gitignore` files. Entries were last verified against upstream documentation in September 2026.

## Quick Start

Copy [examples/agent.gitignore](examples/agent.gitignore) into your repository root as `.gitignore`, or append the sections you need:

```bash
# Overwrite .gitignore with the full version
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore -o .gitignore

# Or merge into an existing .gitignore
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore >> .gitignore
```

Appending is not idempotent — run it once, or paste only the sections you need. Entries inside a directory that your existing `.gitignore` already excludes will not take effect.

Two flavors are available:

- [examples/agent.gitignore](examples/agent.gitignore) — the full version. Follows official defaults where they exist (for example, Aider ignores `.aider*` by itself) and marks case-by-case entries as comments.
- [examples/agent-conservative.gitignore](examples/agent-conservative.gitignore) — a minimal subset: only unambiguous runtime state, caches, and personal files. Nothing here hides a shareable config.

On gitignore semantics: patterns without a slash match at any directory level, while a `**/` prefix covers every level of nested directories — so `**/.claude/settings.local.json` also protects nested worktrees.

Every entry below carries one of three verdicts: **ignore** — runtime state, caches, and personal overrides that should stay local; **commit** — rules, skills, and shared configuration designed for version control; **case by case** — files that may hold secrets or personal preferences, so read the entry before committing. Where a harness leaves nothing behind in the project, sections say **Nothing** (confirmed: runtime state lives outside the project) or **Nothing documented** (the official docs describe no project artifacts), occasionally with a qualifier such as "by default".

## Overview

| Harness                                           | Recommended to ignore                                                                                   | Designed to be committed                                                             | Notes                                                                |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------- |
| [Aider](#aider)                                   | `.aider*`                                                                                               | `.aider.conf.yml`, `.aiderignore` (if shared)                                        | Aider writes `.aider*` into `.gitignore` by default                  |
| [Amazon Q Developer](#amazon-q-developer)         | —                                                                                                       | `.amazonq/rules/`, `.amazonq/cli-agents/`                                            | Agent JSONs with MCP credentials belong in env vars                  |
| [Amp](#amp)                                       | —                                                                                                       | `.amp/settings.json`, `.agents/setup`, `.agents/resume`                              | Threads live on Amp's servers                                        |
| [Augment Code](#augment-code)                     | `.augment/settings.local.json`                                                                          | `.augment/settings.json`, `.augment/rules/`, `.augment-guidelines`, `.augmentignore` | `settings.local.json` is auto-added to `.gitignore`                  |
| [Baidu Comate](#baidu-comate)                     | —                                                                                                       | `.comate/rules/`                                                                     | Project rules are shared; personal rules are private                 |
| [Claude Code](#claude-code)                       | `CLAUDE.local.md`, `.claude/settings.local.json`, `.claude/agent-memory-local/`                         | `CLAUDE.md`, `.mcp.json`, everything else in `.claude/`                              | `settings.local.json` is auto-excluded via global excludes           |
| [Cline](#cline)                                   | —                                                                                                       | `.clinerules/` or `.cline/`, `.clineignore`                                          | Runtime state lives in `~/.cline/`                                   |
| [CodeBuddy](#codebuddy)                           | `.codebuddy/settings.local.json`, `CODEBUDDY.local.md`                                                  | `CODEBUDDY.md`, everything else in `.codebuddy/`                                     | `settings.local.json` is auto-added to `.gitignore`                  |
| [Codebuff](#codebuff)                             | —                                                                                                       | `knowledge.md`, `.agents/`                                                           | Skips `.gitignore`d files by default                                 |
| [CodeGeeX](#codegeex)                             | —                                                                                                       | —                                                                                    | No project artifacts in official docs                                |
| [CodeRabbit](#coderabbit)                         | —                                                                                                       | `.coderabbit.yaml`, `.coderabbit.config.ts`                                          | Review config travels with the repo; learnings live in the cloud     |
| [Codex](#codex)                                   | —                                                                                                       | `AGENTS.md`, `.codex/skills/`, `.agents/skills/`                                     | `.codex/config.toml` depends on its content                          |
| [Continue](#continue)                             | —                                                                                                       | `.continue/rules/`                                                                   | Index cache lives in `~/.continue/index`                             |
| [Crush](#crush)                                   | `.crush/`                                                                                               | `.crushrc`, `.crushignore`, `crush.json` (deprecated)                                | Logs land in `.crush/logs/`; sessions in the user data directory     |
| [Cursor](#cursor)                                 | —                                                                                                       | `.cursor/rules/`, `.cursorignore`                                                    | `.cursor/mcp.json` may hold secrets                                  |
| [DeepSeek Harness](#deepseek-harness)             | `AGENTS.local.md`, `CLAUDE.local.md`                                                                    | `AGENTS.md`, `CLAUDE.md`                                                             | Local overlays are "deliberately not committed"                      |
| [Devin](#devin)                                   | —                                                                                                       | `.devin/wiki.json`, `AGENTS.md`                                                      | Cloud agent; CLI locals covered under Windsurf                       |
| [Firebase Studio](#firebase-studio)               | `.idx/dev.local.nix`                                                                                    | `.idx/dev.nix`, `.idx/icon.png`                                                      | Official docs show the `.gitignore` entry verbatim; sunset announced |
| [Gemini CLI](#gemini-cli)                         | —                                                                                                       | `GEMINI.md`, `.gemini/settings.json`, `.gemini/commands/`                            | Checkpoints live in `~/.gemini/`, not in the project                 |
| [Gemini Code Assist](#gemini-code-assist)         | —                                                                                                       | `.gemini/config.yaml`, `.aiexclude`                                                  | IDE plugin and GitHub review bot; shares `.gemini/` with the CLI     |
| [GitHub Copilot](#github-copilot)                 | —                                                                                                       | `.github/copilot-instructions.md`, `.github/instructions/`                           | CLI runtime data lives in `~/.copilot/`                              |
| [Google Antigravity](#google-antigravity)         | —                                                                                                       | `.agents/` (legacy `.agent/`)                                                        | `.agents/` is read by several harnesses; do not ignore it            |
| [Goose](#goose)                                   | `.goose/`                                                                                               | `.goosehints`, `AGENTS.md`                                                           | The Memory Extension auto-writes `.goose/memory/`                    |
| [Hermes Agent](#hermes-agent)                     | `AGENTS.override.md`                                                                                    | `.hermes.md`, `HERMES.md`                                                            | Officially "typically gitignored"                                    |
| [iFlow CLI](#iflow-cli)                           | —                                                                                                       | `IFLOW.md`, `.iflowignore`                                                           | Discontinued 2026-04; `settings.json` may hold keys                  |
| [JetBrains AI Assistant](#jetbrains-ai-assistant) | —                                                                                                       | `.aiassistant/rules/`, `.aiignore`                                                   | Honors `.cursorignore`, `.codeiumignore`, or `.aiexclude` instead    |
| [Jules](#jules)                                   | —                                                                                                       | `AGENTS.md`                                                                          | Works in a cloud VM; delivers through pull requests                  |
| [Junie](#junie)                                   | —                                                                                                       | `.junie/AGENTS.md`, `.junie/plans/`                                                  | Plans are officially "editable, committable"                         |
| [Kilo Code](#kilo-code)                           | —                                                                                                       | `kilo.jsonc`, `.kilo/rules/`, `.kilocodeignore`                                      | `.kilo/tui.json` is a personal preference                            |
| [Kimi Code CLI](#kimi-code-cli)                   | `.kimi-code/local.toml`                                                                                 | `AGENTS.md`, `.kimi-code/mcp.json`                                                   | Officially recommends ignoring `local.toml`                          |
| [Kiro](#kiro)                                     | —                                                                                                       | `.kiro/steering/`, `.kiro/specs/`, `.kiro/hooks/`, `.kiroignore`                     | `.kiro/settings/mcp.json` must stay credential-free                  |
| [MiMo Code](#mimo-code)                           | `.mimocode/cache/`, `.mimocode/wiki/`, `.mimocode/wikis/`, `.mimo-worktrees/`                           | `.mimocode/` (config, skills, workflows)                                             | Entries mirror the official repository's own `.gitignore`            |
| [OpenCode](#opencode)                             | `.opencode/plans/`, `.opencode/node_modules/`, `.opencode/package.json`, `.opencode/package-lock.json`  | `opencode.json`, `.opencode/` (agents, commands, plugins, ...)                       | Plugin dependencies are auto-installed into `.opencode/`             |
| [OpenHands](#openhands)                           | —                                                                                                       | `.openhands/`, `.agents/skills/`, `AGENTS.md`                                        | Legacy `.openhands/microagents/` still supported                     |
| [Pi](#pi)                                         | `AGENTS.override.md`                                                                                    | `.pi/` (settings, skills, prompts, ...)                                              | Sessions live in `~/.pi/agent/sessions/`                             |
| [Qoder](#qoder)                                   | `.qoder/settings.local.json`, `.qoder/worktrees/`                                                       | `.qoder/rules/`, `.qoder/settings.json`, `.qoder/repowiki/`                          | `rules/` is shareable by default                                     |
| [Qwen Code](#qwen-code)                           | `.qwen/skills/auto-skill-*/`, `.qwen/skills/learned-skill-*/`, `.qwen/pending-skills/`, `.qwen-session` | `QWEN.md`, `.qwen/commands/`, `.qwen/agents/`, `.qwen/team-memory/`                  | The official repository ignores `.qwen/*` with a whitelist           |
| [Replit](#replit)                                 | `.local/`                                                                                               | `.replit`, `replit.nix`, `replit.md`                                                 | Local Agent skills live in `.local/secondary_skills/`                |
| [Roo Code](#roo-code)                             | —                                                                                                       | `.roo/rules/`, `.roomodes`, `.rooignore`                                             | `.roo/rules/` is meant for version control                           |
| [Serena](#serena)                                 | `.serena/cache/`, `.serena/project.local.yml`                                                           | `.serena/project.yml`, `.serena/memories/`                                           | Serena writes its own `.serena/.gitignore` on activation             |
| [Sourcegraph Cody](#sourcegraph-cody)             | —                                                                                                       | —                                                                                    | Server-side context; file lookup respects `.gitignore`               |
| [Tabnine](#tabnine)                               | —                                                                                                       | `.tabnine/guidelines/`                                                               | Agent-style project guidelines                                       |
| [Trae](#trae)                                     | —                                                                                                       | `.trae/rules/`                                                                       | Memories live in the user home directory                             |
| [Warp](#warp)                                     | —                                                                                                       | `WARP.md`, `.warp/workflows/`                                                        | `.warp/rules/` does not exist officially                             |
| [Windsurf](#windsurf)                             | `AGENTS.local.md`, `.devin/config.local.json`, `.devin/mcp_config.local.json`                           | `.devin/` (rules, skills, config), `.windsurf/` (legacy)                             | Renamed Devin Desktop in June 2026                                   |
| [ZCode](#zcode)                                   | `.zcode/` (or just `.zcode/plans/`)                                                                     | `AGENTS.md`, `.zcodeignore`, `.zcode/skills/`                                        | Session plans are runtime artifacts                                  |
| [Zed](#zed)                                       | —                                                                                                       | `.rules`, `.zed/`, `.agents/skills/`                                                 | Sessions live in Zed's user data directory                           |

## Harnesses

### [Aider](https://aider.chat)

> Documentation: <https://aider.chat/docs/config/options.html>

Recommended to ignore:

- `.aider*` — chat history (`.aider.chat.history.md`), input history (`.aider.input.history`), repo-map cache (`.aider.tags.cache.v4/`), and more. The official `--gitignore` switch is on by default, so Aider writes `.aider*` into your `.gitignore` on first run.

Keep in version control (un-ignore if needed):

- `.aider.conf.yml` — team configuration when placed at the repository root
- `.aiderignore` — declares which files Aider should not touch

### [Amazon Q Developer](https://aws.amazon.com/q/developer/)

> Documentation: <https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/context-project-rules.html>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.amazonq/rules/*.md` — project rules; the docs walk through "Commit, review, and merge your changes"
- `.amazonq/cli-agents/*.json` — workspace agent configurations, shared with team members "via version control" (the legacy `.amazonq/mcp.json` has been folded into these agent files)

Case by case:

- Agent JSONs containing MCP credentials — "Use environment variables for sensitive configuration" and keep the secrets out of the committed files

### [Amp](https://ampcode.com)

> Documentation: <https://ampcode.com/docs/cli/settings>

Recommended to ignore:

- Nothing — threads live on Amp's servers and are shared via URLs, and pre-clone scripts are stored outside the repository

Keep in version control:

- `.amp/settings.json` (or `.jsonc`) — workspace settings, searched upward to the repository root
- `.agents/setup`, `.agents/resume` — Orb setup scripts; "Both files are optional. Commit them to the repository." A 2026-08 feature additionally allows setting up orbs without committing these files

### [Augment Code](https://www.augmentcode.com)

> Documentation: <https://docs.augmentcode.com/cli/config>

Recommended to ignore:

- `.augment/settings.local.json` — "Automatically added to `.gitignore` and should not be committed"

Keep in version control:

- `.augment/settings.json`, `.augment/rules/*.md` — project rules "shared with your team via version control"
- `.augment-guidelines`, `.augmentignore`

### [Baidu Comate](https://comate.baidu.com)

> Documentation: <https://cloud.baidu.com/doc/COMATE/s/Zm9l4agw3>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.comate/rules/*.mdr` — project rules, shared with the project and its codebase

Case by case:

- Personal rules — the docs separate personal rules (private preferences) from project rules without naming a project path; keep personal content out of the shared directory

### [Claude Code](https://claude.ai/code)

> Documentation: <https://code.claude.com/docs/en/claude-directory>

Recommended to ignore:

- `CLAUDE.local.md` — personal instructions; the docs say "Create it manually and add it to `.gitignore`"
- `.claude/settings.local.json` — personal settings overriding project defaults. Claude Code adds `**/.claude/settings.local.json` to your global git excludes the first time it writes the file; add it to `.gitignore` yourself if you created the file by hand
- `.claude/agent-memory-local/` — local agent memories; "To keep memory out of version control use `memory: local`, which writes to `.claude/agent-memory-local/` instead"

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

### [Codebuff](https://www.codebuff.com)

> Documentation: <https://www.codebuff.com/docs/tips/knowledge-files>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `knowledge.md` — generated by `/init`, placed next to the code it describes
- `.agents/` — custom TypeScript agents and `.agents/skills/`

Notes:

- Codebuff skips files listed in `.gitignore` by default; `.codebuffignore` adds further exclusions
- The legacy `.codebuff/` directory from earlier versions is obsolete

### [CodeGeeX](https://codegeex.cn)

> Documentation: <https://github.com/CodeGeeX/codegeex-vscode-extension>

Recommended to ignore:

- Nothing documented — the open-source extension keeps its state in VS Code's private storage, and official sources describe no project files

Notes:

- Community posts mention a `.codegeex/` directory, but no official documentation confirms it; this repository does not collect unverified paths

### [CodeRabbit](https://www.coderabbit.ai)

> Documentation: <https://docs.coderabbit.ai/getting-started/yaml-configuration>

Recommended to ignore:

- Nothing — learned preferences ("Learnings") live in CodeRabbit's cloud database, not in the project

Keep in version control:

- `.coderabbit.yaml` (or `.yml`) — repository review configuration, read from the branch under review
- `.coderabbit.config.ts` — TypeScript alternative; a committed YAML file always takes precedence

Notes:

- `.coderabbitignore` appears in community posts but is not an official feature; file filtering goes through `path_filters` in the YAML configuration

### [Codex](https://github.com/openai/codex)

> Documentation: <https://developers.openai.com/codex/guides/agents-md>

Recommended to ignore:

- Nothing documented — sessions, history, and auth all live in `~/.codex/`

Keep in version control:

- `AGENTS.md`, `.codex/skills/`, `.agents/skills/` — Codex discovers `.agents/skills/` at every level from the project root down

Case by case:

- `.codex/config.toml` — project-level configuration layer; share hooks and permissions, keep personal settings local (no official `.local` convention exists)

### [Continue](https://continue.dev)

> Documentation: <https://docs.continue.dev/customize/rules>

Recommended to ignore:

- Nothing — the index cache lives in `~/.continue/index`, outside the project

Keep in version control:

- `.continue/rules/*.md` — project rules, "Version controlled alongside your code"

Case by case:

- `.continueignore` — "follows the exact same rules as .gitignore"; the official docs define it without a commit recommendation

### [Crush](https://github.com/charmbracelet/crush)

> Documentation: <https://github.com/charmbracelet/crush>

Recommended to ignore:

- `.crush/` — runtime logs land at `.crush/logs/crush.log`; session state lives in `~/.local/share/crush/`

Keep in version control:

- `.crushrc` (or `crushrc`) — project-level commands and configuration
- `.crushignore` — keeps files out of Crush's context; Crush itself respects `.gitignore` by default
- `crush.json` — legacy configuration, still supported but deprecated

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

### [Devin](https://devin.ai)

> Documentation: <https://docs.devin.ai>

Recommended to ignore:

- Nothing by itself — the cloud agent works in its own VM and delivers through pull requests; the Devin CLI's personal files (`.devin/config.local.json`, `.devin/mcp_config.local.json`) are already covered in the [Windsurf](#windsurf) section

Keep in version control:

- `.devin/wiki.json` — DeepWiki customization; "Commit the file and regenerate your wiki"
- `AGENTS.md` — "Devin will look for the file before it starts coding"

### [Firebase Studio](https://firebase.google.com/docs/studio)

> Documentation: <https://firebase.google.com/docs/studio/devnix-reference>

Recommended to ignore:

- `.idx/dev.local.nix` — personal Nix overrides; the official docs literally include this entry in a `.gitignore` example

Keep in version control:

- `.idx/dev.nix` — "share your Nix configuration file as part of your Git repository to ensure everyone who works on your project has the same environment configuration"
- `.idx/icon.png` — "can be checked into source control"

Case by case:

- `.idx/mcp.json` — MCP server configuration; the docs give no git guidance

Notes:

- Google has announced a sunset for Firebase Studio; the entries above apply to existing workspaces

### [Gemini CLI](https://geminicli.com)

> Documentation: <https://geminicli.com/docs/cli/settings>

Recommended to ignore:

- Nothing documented — checkpoints and conversation history live in `~/.gemini/`, not in the project

Keep in version control:

- `GEMINI.md`, `.gemini/commands/*.toml` — "can be committed to version control and shared with your team"
- `.geminiignore` — Gemini CLI's own access filter, like `.gitignore`

Case by case:

- `.gemini/settings.json` — workspace settings override user settings; review for personal values before committing

### [Gemini Code Assist](https://docs.cloud.google.com/gemini/docs)

> Documentation: <https://docs.cloud.google.com/gemini/docs/code-review/customize-repo-review>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.gemini/config.yaml`, `.gemini/styleguide.md` — repository configuration for the GitHub review bot, read from the repository
- `.aiexclude` — keeps files out of Gemini's context, using `.gitignore` syntax

Case by case:

- `.aiexclude` — ignore it only when it holds personal paths

Notes:

- The IDE plugin and the GitHub review bot share the `.gemini/` directory with [Gemini CLI](#gemini-cli); `.gemini/settings.json` and `.geminiignore` belong to Gemini CLI

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

- Do not ignore `.agents/` — [Codex](#codex), [Zed](#zed), and [Replit](#replit) read the same directory for skills

### [Goose](https://goose-docs.ai)

> Documentation: <https://goose-docs.ai/docs/mcp/memory-mcp>

Recommended to ignore:

- `.goose/` — the Memory Extension stores project memories at `.goose/memory/`, while sessions live in `~/.local/share/goose/sessions/`; no official `.gitignore` recommendation exists, so this entry follows from the documented auto-storage behavior

Keep in version control:

- `.goosehints`, `AGENTS.md` — the default context files Goose loads

### [Hermes Agent](https://hermes-agent.nousresearch.com)

> Documentation: <https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files>

Recommended to ignore:

- `AGENTS.override.md` — "Personal, per-directory override of AGENTS.md (typically gitignored)"

Keep in version control:

- `.hermes.md` or `HERMES.md` — highest-priority project instructions (priority order: `.hermes.md` → `AGENTS.override.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules`)

### [iFlow CLI](https://github.com/iflow-ai/iflow-cli)

> Documentation: <https://github.com/iflow-ai/iflow-cli>

> iFlow CLI was discontinued on April 17, 2026, and the vendor recommends migrating to Qoder in its farewell post (<https://vibex.iflow.cn/t/topic/4819>). The entries below apply to existing repositories.

Recommended to ignore:

- Nothing documented — checkpoints and sessions live in `~/.iflow/` and never enter the project's Git repository

Keep in version control:

- `IFLOW.md` — project context generated by `/init`
- `.iflowignore`, `.iflow/sandbox-macos-custom.sb`, `.iflow/sandbox.Dockerfile` — shared file-discovery and sandbox configuration

Case by case:

- `.iflow/settings.json` — project settings may hold `apiKey` and `baseUrl`; keep credential-bearing files local (no official gitignore guidance exists)

### [JetBrains AI Assistant](https://www.jetbrains.com/ai-assistant/)

> Documentation: <https://www.jetbrains.com/help/ai-assistant/configure-project-rules.html>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.aiassistant/rules/*.md` — project rules (always, manual `@rule:`, model decision, or file patterns)
- `.aiignore` — same syntax as `.gitignore`; JetBrains also honors `.cursorignore`, `.codeiumignore`, or `.aiexclude` when present

### [Jules](https://jules.google)

> Documentation: <https://jules.google/docs>

Recommended to ignore:

- Nothing — Jules clones the repository into a cloud VM and delivers its work through branches and pull requests

Keep in version control:

- `AGENTS.md` — "Jules will also refer to agents.md"

### [Junie](https://www.jetbrains.com/junie/)

> Documentation: <https://junie.jetbrains.com/docs/guidelines-and-memory.html>

Recommended to ignore:

- Nothing — plans and guidelines are designed to be committed

Keep in version control:

- `.junie/AGENTS.md` — team coding conventions; the legacy `.junie/guidelines.md` is still supported
- `.junie/plans/` — "editable, committable" per the product homepage; the JetBrains blog calls it "living task documentation"

### [Kilo Code](https://kilo.ai)

> Documentation: <https://kilo.ai/docs/customize/custom-rules>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `kilo.jsonc` — project configuration; committed project config cannot use `{env:VAR}` references, so keep secrets in global config
- `.kilo/rules/` (legacy `.kilocode/rules/`), `.kilocodeignore`

Case by case:

- `.kilo/tui.json` / `.kilo/tui.jsonc` — terminal-UI preferences (sounds, theme, keybindings); personal rather than team material

### [Kimi Code CLI](https://github.com/MoonshotAI/kimi-code)

> Documentation: <https://moonshotai.github.io/kimi-code/en/configuration/config-files.html>

Recommended to ignore:

- `.kimi-code/local.toml` — "we recommend adding .kimi-code/local.toml to your project's .gitignore so it is not committed" (it stores machine-specific absolute paths)

Keep in version control:

- `AGENTS.md` — generated and updated via `/init`
- `.kimi-code/mcp.json` — project-scoped MCP servers

Notes:

- The predecessor Kimi CLI (`MoonshotAI/kimi-cli`) is archived; its state lived entirely in `~/.kimi/`

### [Kiro](https://kiro.dev)

> Documentation: <https://kiro.dev/docs/>

Recommended to ignore:

- Nothing by default — "Shared project configuration travels with your repository through .kiro/"

Keep in version control:

- `.kiro/steering/` — "Steering files are part of your codebase"
- `.kiro/specs/`, `.kiro/hooks/`, `.kiroignore`

Case by case:

- `.kiro/settings/mcp.json` — workspace MCP servers; "Never commit configuration files with credentials to version control" — use `${VARIABLE}` references or keep the file local

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

- `.opencode/plans/` — plan files written by plan mode (inside a Git repository; otherwise they land in the global data directory)
- `.opencode/node_modules/`, `.opencode/package.json`, `.opencode/package-lock.json` — plugin dependencies that OpenCode auto-installs once `.opencode/` exists (OpenCode writes its own `.opencode/.gitignore` for these)

Keep in version control:

- `opencode.json` / `opencode.jsonc` — "safe to be checked into Git"
- `.opencode/agents/`, `.opencode/commands/`, `.opencode/plugins/`, `.opencode/skills/`, `.opencode/tools/`, `.opencode/themes/`
- `AGENTS.md` — "You should commit your project's AGENTS.md file to Git"

### [OpenHands](https://github.com/All-Hands-AI/OpenHands)

> Documentation: <https://docs.openhands.dev/openhands/usage/customization/repository>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.openhands/setup.sh` — runs every time OpenHands starts working with the repository
- `.openhands/hooks.json`, `.openhands/hooks/` — lifecycle hooks
- `.agents/skills/` — the recommended repo skills location; legacy `.openhands/skills/` and `.openhands/microagents/` remain supported
- `AGENTS.md` — always loaded as repo context

### [Pi](https://pi.dev)

> Documentation: <https://pi.dev/docs/latest/configuration>

Recommended to ignore:

- `AGENTS.override.md` — replaces `AGENTS.md` or `CLAUDE.md` in the same directory only; personal by convention

Keep in version control:

- `.pi/settings.json`, `.pi/SYSTEM.md`, `.pi/APPEND_SYSTEM.md`, `.pi/skills/`, `.pi/extensions/`, `.pi/prompts/`, `.pi/themes/` — the official repository commits its own `.pi/` directory

Notes:

- Sessions live in `~/.pi/agent/sessions/`, grouped by working directory

### [Qoder](https://qoder.com)

> Documentation: <https://docs.qoder.com/cli/config-scope>

Recommended to ignore:

- `.qoder/settings.local.json` — "Typically, `.qoder/settings.local.json` should be added to `.gitignore`"
- `.qoder/worktrees/` — isolated worktrees created by the CLI's `--worktree` switch

Keep in version control:

- `.qoder/rules/`, `.qoder/settings.json`, `.qoder/skills/` — suitable for committing to the version control repository
- `.qoder/repowiki/` — locally generated Repo Wiki; `wiki_plan.yaml` "is shared with the team via Git commits"
- `AGENTS.md`, `.qoderignore`

Case by case:

- `.qoder/rules/` — for local-only rules the documentation recommends adding this directory to `.gitignore` instead

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

### [Roo Code](https://roocode.com)

> Documentation: <https://roocodeinc.github.io/Roo-Code/features/custom-instructions>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.roo/rules/`, `.roo/rules-{mode}/` — "under version control to standardize Roo's behavior for specific projects"
- `.roomodes` — project-level custom modes
- `.rooignore`, `AGENTS.md`

Case by case:

- `.roorules` — the single-file fallback for rules; shareable by convention, though the official git guidance targets the directory form

### [Serena](https://github.com/oraios/serena)

> Documentation: <https://oraios.github.io/serena/>

Recommended to ignore:

- `.serena/cache/`, `.serena/project.local.yml` — local state; Serena writes its own `.serena/.gitignore` (containing exactly these two entries) on first activation, so these lines mainly protect you before that

Keep in version control:

- `.serena/project.yml` — "intended to be versioned together with the project"
- `.serena/memories/` — "can be committed, reviewed in PRs, and reverted like any other repository artifact"

### [Sourcegraph Cody](https://sourcegraph.com/docs/cody)

> Documentation: <https://sourcegraph.com/docs/cody>

Recommended to ignore:

- Nothing documented — prompts and context live on the Sourcegraph server, and Cody's file lookup respects `.gitignore`

Case by case:

- `.sourcegraph/instructions.md` — a convention from earlier Cody versions; current official docs no longer describe it

### [Tabnine](https://www.tabnine.com)

> Documentation: <https://docs.tabnine.com/main/getting-started/tabnine-agent/guidelines.md>

Recommended to ignore:

- Nothing documented

Keep in version control:

- `.tabnine/guidelines/*.md` — project guidelines, "in a similar fashion to the agents.md file that other agentic tools use"

Case by case:

- `.tabnine/agent/settings.json` — project-specific overrides; commit them when they are team-wide, keep personal preferences local

### [Trae](https://trae.ai)

> Documentation: <https://docs.trae.cn/ide_rules>

Recommended to ignore:

- Nothing documented — memories and global rules live in `~/.trae-cn/`, and no runtime artifacts are written into the project

Keep in version control:

- `.trae/rules/*.md` — project rules, nestable up to three levels

Notes:

- Trae also reads `AGENTS.md`, `CLAUDE.md`, and `CLAUDE.local.md`; ignore the `.local.` variant as usual

### [Warp](https://www.warp.dev)

> Documentation: <https://docs.warp.dev/agents/capabilities/rules>

Recommended to ignore:

- Nothing documented — agent memory lives in Warp's cloud, and global rules live in Warp Drive

Keep in version control:

- `WARP.md` (or `AGENTS.md`) — project rules; when both exist, `WARP.md` takes priority
- `.warp/workflows/*.yaml` — repository workflows "can be accessed by anyone who has cloned the repo"

Notes:

- `.warp/rules/` appears in community templates but does not exist in the official documentation

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

### [ZCode](https://zcode.z.ai)

> Documentation: <https://zcode.z.ai> — the public documentation does not describe these workspace paths; entries below reflect observed behavior in local workspaces

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

## Contributing

Issues and pull requests are welcome. Maintenance guidelines — entry verification requirements, document structure, ordering conventions — live in [AGENTS.md](AGENTS.md) (currently written in Chinese). If an entry has drifted from the official docs, please open an issue.

Quick rules for contributions:

1. Every entry needs an official documentation page or an official repository as its source — no guessed paths.
2. Classify each entry as ignore (runtime state, caches, personal overrides), commit (rules, shared configuration), or case by case (may hold secrets or personal preferences).
3. Keep all four places in sync: both READMEs and both example files, in alphabetical order.
4. Run `deno task fmt` and `deno task test` before submitting.

## License

[MIT](LICENSE)
