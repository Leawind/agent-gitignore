> **归档说明 / Archived**: 本仓库已改作他用（agent-gitignore）。本文档为旧用途「Vibe Coding Tools 规则文件大全」的存档版本，不再维护；当前内容见根目录 README.md / README.zh.md。历史版本可参考 tag `vibe-rule-files-final`。

| [中文](README.zh.md) | English |
| -------------------- | ------- |

# Rule Files of Vibe Coding Tools

## Overview

| Tool              | Project Rule Files                                                       | Notes                                                                                  |
| ----------------- | ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| Aider             | `CONVENTIONS.md`                                                         | Loaded as read-only files via `--read` or `read:` in `.aider.conf.yml`                 |
| Claude Code       | `CLAUDE.md`, `.claude/rules/*.md`                                        | Supports `@import` syntax to include other files                                       |
| Cline             | `.clinerules/*.md`                                                       | Also compatible with `.cursorrules`, `.windsurfrules`, `AGENTS.md`                     |
| CodeBuddy         | `CODEBUDDY.md`, `.codebuddy/rules/*/RULE.mdc`                            | Rule types: Always, Agent Requested, Manual                                            |
| Codex             | `AGENTS.md`                                                              | Supports `@import` syntax to include other files                                       |
| Cursor            | `.cursor/rules/*.mdc`, `AGENTS.md`                                       | `.mdc` files support frontmatter to control triggering                                 |
| DeepSeek Harness  | `AGENTS.md`, `CLAUDE.md`                                                 | Supports `.local.md` overlays and hierarchical loading; global file in `~/.dsh/`       |
| Gemini CLI        | `GEMINI.md`                                                              | Supports `@file.md` syntax to import subfiles                                          |
| GitHub Copilot    | `.github/copilot-instructions.md`, `AGENTS.md`                           | Path-specific rules placed in `.github/instructions/*.instructions.md`                 |
| Google Antigravity| `.agents/rules/*.md`                                                     | Activation modes: Manual, Always On, Model Decision, Glob; global `~/.gemini/GEMINI.md`|
| Hermes Agent      | `.hermes.md`, `HERMES.md`, `AGENTS.md`, `CLAUDE.md`, `.cursorrules`      | Supports progressive subdirectory discovery; `SOUL.md` for global personality          |
| Kilo Code         | `.kilo/rules/*.md` (recommended)                                         | Configure instruction paths via `kilo.jsonc`; compatible with legacy `.kilocode/`      |
| MiMo Code         | `AGENTS.md`, `CLAUDE.md`                                                 | Customizable instruction file paths in `mimocode.json`                                 |
| OpenCode          | `AGENTS.md`                                                              | Customizable instruction file paths in `opencode.json`                                 |
| Pi                | `AGENTS.md`                                                              | Loads `AGENTS.md` files hierarchically (global to project) into the system prompt      |
| Qwen Code         | `QWEN.md`                                                                | Three tiers: global `~/.qwen/QWEN.md`, project root, subdirectories                    |
| Replit            | `replit.md`                                                              | Auto-managed by Replit Agent; condensed automatically when it grows long               |
| Trae              | `.trae/rules/*.md`                                                       | Supports frontmatter to control trigger scenarios (e.g., `scene: git_message`)         |
| Windsurf          | `.devin/rules/*.md`, `.windsurf/rules/*.md`                              | frontmatter `trigger`: `always_on`, `model_decision`, `glob`, `manual`                 |
| Zed               | `.rules`, `AGENTS.md`                                                    | Auto-loads `.cursorrules`, `.windsurfrules`, etc.; first match wins                    |

## Tools

### [Aider](https://aider.chat)

> Documentation: <https://aider.chat/docs/usage/tips.html>

Project Rule Files:

- Primary: `CONVENTIONS.md` in the project root — describes coding conventions
- Loading: passed via the `--read` switch, or configured with `read: CONVENTIONS.md` in `.aider.conf.yml`

Loading Description:

- Convention files are injected into every chat as read-only files
- Additional read-only context files can be configured the same way

### [Claude Code](https://claude.ai/code)

> Documentation: <https://docs.anthropic.com/en/docs/claude-code/memory>

Project Rule Files:

- Primary: `CLAUDE.md` or `.claude/CLAUDE.md` in the project root
- Granular Rules: `.claude/rules/*.md` — can be split by file path or topic
- Personal Preferences: `CLAUDE.local.md` — add to `.gitignore`, do not commit to version control

Hierarchy Loading Order (from broad to narrow):

1. Organization Level: `/etc/claude-code/CLAUDE.md`
2. User Level: `~/.claude/CLAUDE.md`
3. Project Level: `./CLAUDE.md` or `./.claude/CLAUDE.md`
4. Local Level: `./CLAUDE.local.md`

### [Cline](https://cline.bot)

> Documentation: <https://docs.cline.bot/features/cline-rules>

Project Rule Files:

- Primary: `.clinerules/*.md` — supports `.md` and `.txt` files
- Auto-Compatible: Also recognizes `.cursorrules`, `.windsurfrules`, `AGENTS.md`
- Global Rules: `~/Documents/Cline/Rules/`

### [CodeBuddy](https://www.codebuddy.ai)

> Documentation: <https://www.codebuddy.ai/docs/ide/Rules>

Project Rule Files:

- Main File: `CODEBUDDY.md` in the project root — provides project context and global instructions
- Granular Rules: `.codebuddy/rules/*/RULE.mdc` — each rule corresponds to a folder containing `RULE.mdc`
- Global Rules: `~/.codebuddy/CODEBUDDY.md` and `~/.codebuddy/rules/`

Rule Types:

| Type              | Description                                   |
| ----------------- | --------------------------------------------- |
| `Always`          | Always active                                 |
| `Agent Requested` | AI decides whether to enable based on context |
| `Manual`          | Active only when manually specified           |

### [Codex](https://github.com/openai/codex)

> Documentation: <https://github.com/openai/codex>

Project Rule Files:

- Primary: `AGENTS.md` in the project root — provides project-level instructions
- Supports `@import` syntax to include other files
- Global: `~/.codex/AGENTS.md` (if applicable)

### [Cursor](https://cursor.com)

> Documentation: <https://cursor.com/docs/rules>

Project Rule Files:

- Primary: `.cursor/rules/*.mdc` — uses `.mdc` extension; controls triggering via frontmatter
- Simple Alternative: `AGENTS.md` in the project root — plain Markdown, no configuration required

Rule Types (controlled via frontmatter):

| Type                    | Description                                       |
| ----------------------- | ------------------------------------------------- |
| `alwaysApply: true`     | Active in every conversation                      |
| `globs: "src/**/*.tsx"` | Automatically active when matching specific files |
| `description: "..."`    | AI decides whether to enable based on description |
| Manual `@rule-name`     | Active only when mentioned with `@` in chat       |

### [DeepSeek Harness](https://www.deepseek.com/harness/en/)

> Documentation: <https://github.com/deepseek-ai/deepseek-harness>

Project Rule Files:

- Primary: `AGENTS.md` — loaded from the user-global directory and every directory in the project chain
- Compatible: `CLAUDE.md` — loaded alongside `AGENTS.md`, with duplicates collapsed automatically
- Local Overlays: `AGENTS.local.md`, `CLAUDE.local.md` — additive local files, loaded after the base files
- Global: `AGENTS.md` in `~/.dsh/` (or `$DSH_HOME`)

Hierarchy Loading Order (from broad to narrow):

1. Global: `AGENTS.md` in `~/.dsh/`
2. Project chain: every existing `AGENTS.md` / `CLAUDE.md` from the project root down to the session working directory
3. Dynamic refresh: nested instruction files are picked up after file operations reach deeper directories

Configuration Description:

- Loaded by the built-in `@deepseek-ai/dsh-agent-instructions` plugin; behavior (file candidates, project root markers, byte budget) is configurable via plugin config
- The rendered baseline is bounded by a byte budget (default 65,536 bytes); broader files are omitted before the most specific file is truncated

### [Gemini CLI](https://geminicli.com)

> Documentation: <https://geminicli.com/docs/cli/gemini-md>

Project Rule Files:

- Primary: `GEMINI.md` in the project root
- Subdirectories: `GEMINI.md` in any subdirectory — loaded only when accessing that directory
- Global: `~/.gemini/GEMINI.md`

Hierarchy Loading Order:

1. Global: `~/.gemini/GEMINI.md`
2. Workspace: Searches upward from the current directory for `GEMINI.md`
3. Just-In-Time (JIT): Automatically loads `GEMINI.md` of the directory when accessing files/directories

Supports import syntax: `@path/to/file.md`

### [GitHub Copilot](https://github.com/features/copilot)

> Documentation: <https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot>

Project Rule Files:

- Repository Level: `.github/copilot-instructions.md` — applies to the entire repository
- Path-Specific: `.github/instructions/*.instructions.md` — filenames must end with `.instructions.md`
- Agent Instructions: `AGENTS.md` (or `CLAUDE.md`, `GEMINI.md`) in the project root

### [Google Antigravity](https://antigravity.google)

> Documentation: <https://antigravity.google/docs/rules-workflows/>

Project Rule Files:

- Primary: `.agents/rules/*.md` — workspace-level rules, one rule per Markdown file
- Global: `~/.gemini/GEMINI.md` — applies to all workspaces
- References: `@filename` — attach additional rules in the conversation

Activation Modes:

| Mode              | Description                                        |
| ----------------- | -------------------------------------------------- |
| Manual            | Active only when manually invoked                  |
| Always On         | Included in every interaction                      |
| Model Decision    | Agent reads the full rule when it deems relevant   |
| Glob              | Active when files matching a glob pattern are touched |

### [Hermes Agent](https://hermes-agent.nousresearch.com)

> Documentation: <https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files>

Project Rule Files:

- Primary: `.hermes.md` or `HERMES.md` — highest priority project instructions
- Compatible: `AGENTS.md`, `CLAUDE.md`, `.cursorrules` — also detected and loaded
- Global Personality: `SOUL.md` in `~/.hermes/` — controls agent tone and communication style
- Cursor Rules: `.cursor/rules/*.mdc` — Cursor IDE rule modules (if no higher-priority file found)

Priority System (first match wins):

1. `.hermes.md` / `HERMES.md`
2. `AGENTS.md`
3. `CLAUDE.md`
4. `.cursorrules`

Features:

- Progressive subdirectory discovery: `AGENTS.md` files in subdirectories are loaded when navigating into them
- Security scanning: all context files are checked for prompt injection patterns
- Size limits: files truncated at 20,000 characters (70% head, 20% tail)

### [Kilo Code](https://kilo.ai)

> Documentation: <https://kilo.ai/docs/customize/custom-rules>

Project Rule Files:

- Recommended Configuration: Specify paths via the `instructions` array in `kilo.jsonc`; default recommendation is `.kilo/rules/*.md`
- Compatible Paths: `.kilocode/rules/*.md` — legacy path, still supported but not recommended for new projects
- Global Rules: Configured in `~/.config/kilo/kilo.jsonc`

Rule Description:

- Supports unifying code formatting standards, restricting access to sensitive files, and enforcing coding norms through rules
- It is recommended to explicitly manage rule files for different purposes via configuration files, rather than relying on automatically recognized pattern directories

### [MiMo Code](https://mimo.xiaomi.com/mimocode)

> Documentation: <https://mimo.xiaomi.com/zh/mimocode/rules>

Project Rule Files:

- Primary: `AGENTS.md` or compatible `CLAUDE.md` — serves as project-level rule files
- Configuration File: `mimocode.json` or global `~/.config/mimocode/mimocode.json`

Configuration Description:

- Custom instruction file paths can be specified in the JSON configuration file to reuse existing rules
- Global rule files (`~/.config/mimocode/AGENTS.md`) apply to all project sessions, enabling cross-project instruction persistence

### [OpenCode](https://opencode.ai)

> Documentation: <https://opencode.ai/docs/rules/>

Project Rule Files:

- Primary: `AGENTS.md` in the project root — provides custom instructions
- Configuration File: `opencode.json` or global `~/.config/opencode/opencode.json`

Configuration Description:

- Custom instruction file paths can be specified in `opencode.json` to reuse existing rules without copying them to `AGENTS.md`
- Supports quickly generating or updating `AGENTS.md` files via the `/init` command

### [Pi](https://pi.dev)

> Documentation: <https://pi.dev/docs/latest/usage>

Project Rule Files:

- Primary: `AGENTS.md` — loaded at startup and injected into the system prompt
- Discovery: hierarchical, from global to project-specific locations

Loading Description:

- Context files are used for project conventions, commands, safety rules, and preferences
- Supports skills, prompt templates, and TypeScript extensions for further customization

### [Qwen Code](https://github.com/QwenLM/qwen-code)

> Documentation: <https://qwenlm.github.io/qwen-code-docs/>

Project Rule Files:

- Primary: `QWEN.md` in the project root — generated via the `/init` command
- Subdirectories: `QWEN.md` in any subdirectory — loaded when accessing that directory
- Global: `~/.qwen/QWEN.md`

Hierarchy Loading Order:

1. Global: `~/.qwen/QWEN.md`
2. Project root: `QWEN.md` — loaded as durable project context for every interaction
3. Subdirectories: `QWEN.md` in subdirectories, loaded on access

### [Replit](https://replit.com)

> Documentation: <https://docs.replit.com/features/project-setup/replit-dot-md>

Project Rule Files:

- Primary: `replit.md` in the project root — customizes Replit Agent's behavior, coding style, and project context

Configuration Description:

- Editable by users and also auto-maintained by Replit Agent
- The file is condensed automatically when it exceeds roughly 100 lines

### [Trae](https://trae.ai)

> Documentation: <https://docs.trae.ai/ide/rules>

Project Rule Files:

- Primary: `.trae/rules/*.md` — stored in a hidden directory in the project root
- Personal Rules: Configured in IDE settings, applying globally to all projects

Rule Types (controlled via frontmatter):

| Type                 | Description                                                   |
| -------------------- | ------------------------------------------------------------- |
| `alwaysApply: true`  | Active in every conversation                                  |
| `scene: git_message` | Automatically active only when generating Git commit messages |
| Manual Trigger       | Active when mentioned with `@` in chat                        |

### [Windsurf](https://windsurf.com)

> Documentation: <https://docs.devin.ai/desktop/cascade/memories>

Project Rule Files:

- Primary: `.devin/rules/*.md` — one rule per Markdown file, with frontmatter controlling activation
- Compatible: `.windsurf/rules/*.md` — legacy directory, still supported
- Legacy: `.windsurfrules` at the workspace root — plain Markdown, always active
- Global rules are configured in Settings; root-level `AGENTS.md` is also read

Rule Types (controlled via frontmatter `trigger`):

| Type            | Description                                              |
| --------------- | -------------------------------------------------------- |
| `always_on`     | Full content included in the system prompt on every message |
| `model_decision`| Only the description is shown; the model reads the file when relevant |
| `glob`          | Active when files matching the `globs` pattern are touched |
| `manual`        | Active only when mentioned with `@rule-name` in chat     |

> Note: Windsurf was renamed Devin Desktop in June 2026; existing `.windsurf/` paths continue to be supported.

### [Zed](https://zed.dev)

> Documentation: <https://zed.dev/docs/ai/instructions>

Project Rule Files:

- Primary: `.rules` in the project root — always-on instructions for the Zed Agent
- Auto-Compatible: also detects `.cursorrules`, `.windsurfrules`, `AGENTS.md`, and similar files

Priority System (first match wins):

1. `.rules`
2. `.cursorrules`
3. `.windsurfrules`
4. `AGENTS.md`
