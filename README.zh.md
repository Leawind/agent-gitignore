| 中文 | [English](README.md) |
| ---- | -------------------- |

# agent-gitignore

AI 编码框架（harness）——Claude Code、Cursor、Aider、Qwen Code 等——会在工作区里留下各种杂物：对话历史、计划文件、缓存、自动生成的技能、个人设置，它们大多不应进入版本管理。与此同时，一些看起来像杂物的文件——`AGENTS.md`、`.agents/`、`.zcodeignore`——恰恰是设计为提交共享的。

本仓库收集常见 AI 编码框架会在工作区创建、但很可能不希望纳入版本管理的文件，每一条目均经官方文档核实，并提供可直接使用的示例 `.gitignore` 文件。

## 快速开始

将 [examples/agent.gitignore](examples/agent.gitignore) 复制到仓库根目录作为 `.gitignore`，或按需追加其中的条目：

```bash
# 用完整版覆盖 .gitignore
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore -o .gitignore

# 或合并进已有的 .gitignore
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore >> .gitignore
```

提供两种版本：

- [examples/agent.gitignore](examples/agent.gitignore) — 完整版。凡有官方默认值之处遵循官方默认（例如 Aider 会自行忽略 `.aider*`），需要酌情判断的条目以注释形式标注。
- [examples/agent-conservative.gitignore](examples/agent-conservative.gitignore) — 保守版，只含无歧义的运行时状态、缓存和个人文件，不会误伤任何可共享配置。

关于 gitignore 语法：不带斜杠的模式在任意目录层级生效；`**/` 前缀可覆盖嵌套目录的每一层，因此 `**/.claude/settings.local.json` 对嵌套工作区同样有效。

## 总览

| 工具               | 建议忽略                                                                                                | 建议提交                                                            | 备注                                            |
| ------------------ | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------- |
| Aider              | `.aider*`                                                                                               | `.aider.conf.yml`、`.aiderignore`（如需共享）                       | Aider 默认自动把 `.aider*` 写入 `.gitignore`    |
| Claude Code        | `CLAUDE.local.md`、`.claude/settings.local.json`、`.claude/agent-memory-local/`                         | `CLAUDE.md`、`.mcp.json`、`.claude/` 其余内容                       | `settings.local.json` 自动进全局 git 排除       |
| Cline              | —                                                                                                       | `.clinerules/` 或 `.cline/`、`.clineignore`                         | 运行时状态保存在 `~/.cline/`                    |
| CodeBuddy          | `.codebuddy/settings.local.json`、`CODEBUDDY.local.md`                                                  | `CODEBUDDY.md`、`.codebuddy/` 其余内容                              | `settings.local.json` 官方自动加入 `.gitignore` |
| Codex              | —                                                                                                       | `AGENTS.md`、`.codex/skills/`、`.agents/skills/`                    | `.codex/config.toml` 视内容而定                 |
| Cursor             | —                                                                                                       | `.cursor/rules/`、`.cursorignore`                                   | `.cursor/mcp.json` 可能含密钥                   |
| DeepSeek Harness   | `AGENTS.local.md`、`CLAUDE.local.md`                                                                    | `AGENTS.md`、`CLAUDE.md`                                            | 本地覆盖文件"刻意不提交"                        |
| Gemini CLI         | —                                                                                                       | `GEMINI.md`、`.gemini/settings.json`、`.gemini/commands/`           | 检查点保存在 `~/.gemini/`，不进项目             |
| GitHub Copilot     | —                                                                                                       | `.github/copilot-instructions.md`、`.github/instructions/`          | CLI 运行时数据保存在 `~/.copilot/`              |
| Google Antigravity | —                                                                                                       | `.agents/`（旧版 `.agent/`）                                        | `.agents/` 被多个框架读取，请勿忽略             |
| Hermes Agent       | `AGENTS.override.md`                                                                                    | `.hermes.md`、`HERMES.md`                                           | 官方注明"typically gitignored"                  |
| Kilo Code          | —                                                                                                       | `kilo.jsonc`、`.kilo/rules/`、`.kilocodeignore`                     | `.kilo/tui.json` 属个人偏好                     |
| MiMo Code          | `.mimocode/cache/`、`.mimocode/wiki/`、`.mimocode/wikis/`、`.mimo-worktrees/`                           | `.mimocode/`（配置、技能、工作流）                                  | 条目与官方仓库自身的 `.gitignore` 一致          |
| OpenCode           | `.opencode/plans/`、`.opencode/node_modules/`、`.opencode/package.json`、`.opencode/package-lock.json`  | `opencode.json`、`.opencode/`（agents、commands、plugins 等）       | 插件依赖会被自动安装进 `.opencode/`             |
| Pi                 | `AGENTS.override.md`                                                                                    | `.pi/`（settings、skills、prompts 等）                              | 会话保存在 `~/.pi/agent/sessions/`              |
| Qwen Code          | `.qwen/skills/auto-skill-*/`、`.qwen/skills/learned-skill-*/`、`.qwen/pending-skills/`、`.qwen-session` | `QWEN.md`、`.qwen/commands/`、`.qwen/agents/`、`.qwen/team-memory/` | 官方仓库以白名单方式忽略 `.qwen/*`              |
| Replit             | `.local/`                                                                                               | `.replit`、`replit.nix`、`replit.md`                                | 本地 Agent 技能位于 `.local/secondary_skills/`  |
| Trae               | —                                                                                                       | `.trae/rules/`                                                      | 记忆数据保存在用户主目录                        |
| Windsurf           | `AGENTS.local.md`、`.devin/config.local.json`、`.devin/mcp_config.local.json`                           | `.devin/`（rules、skills、config）、`.windsurf/`（旧版）            | 2026 年 6 月更名为 Devin Desktop                |
| ZCode              | `.zcode/`（或仅 `.zcode/plans/`）                                                                       | `AGENTS.md`、`.zcodeignore`、`.zcode/skills/`                       | 会话计划属运行时产物                            |
| Zed                | —                                                                                                       | `.rules`、`.zed/`、`.agents/skills/`                                | 会话保存在 Zed 用户数据目录                     |

## 工具

### [Aider](https://aider.chat)

> 文档: <https://aider.chat/docs/config/options.html>

建议忽略:

- `.aider*` — 对话历史（`.aider.chat.history.md`）、输入历史（`.aider.input.history`）、repo map 缓存（`.aider.tags.cache.v4/`）等。官方 `--gitignore` 开关默认开启，首次运行时 Aider 会自动把 `.aider*` 写入 `.gitignore`

建议提交（需放行时取消注释）:

- `.aider.conf.yml` — 放在仓库根目录即为团队共享配置
- `.aiderignore` — 声明 Aider 不应触碰的文件

### [Claude Code](https://claude.ai/code)

> 文档: <https://code.claude.com/docs/en/claude-directory>

建议忽略:

- `CLAUDE.local.md` — 个人指令；官方说明 "Create it manually and add it to `.gitignore`"
- `.claude/settings.local.json` — 覆盖项目默认值的个人设置。Claude Code 首次写入该文件时会自动把 `**/.claude/settings.local.json` 加入全局 git 排除；若文件为手动创建，请自行加入 `.gitignore`
- `.claude/agent-memory-local/` — 本地代理记忆，官方注明 "keep out of version control"

建议提交:

- `CLAUDE.md`、`.mcp.json`（密钥用 `${VAR}` 环境变量引用）、`.worktreeinclude`
- `.claude/settings.json`、`.claude/rules/`、`.claude/skills/`、`.claude/commands/`、`.claude/agents/`、`.claude/workflows/`、`.claude/agent-memory/`

### [Cline](https://cline.bot)

> 文档: <https://docs.cline.bot/getting-started/config>

建议忽略:

- 无 — 会话、任务、检查点和 API 密钥都保存在 `~/.cline/`，检查点影子仓库也放在项目 Git 历史之外

建议提交:

- `.clinerules/`（或 `.cline/rules/`）— 工作区规则；`.cline/` 下还有可共享的 `skills/`、`hooks/`、`agents/`、`plugins/`、`cron/`
- `.clineignore` — 类似 `.gitignore` 的文件访问过滤（上游已宣布废弃）

说明:

- `memory-bank/` 存放纯 Markdown 的项目记忆，供团队共享

### [CodeBuddy](https://www.codebuddy.ai)

> 文档: <https://www.codebuddy.ai/docs/cli/codebuddy-dir>

建议忽略:

- `.codebuddy/settings.local.json` 与 `CODEBUDDY.local.md` — 官方标注 "Auto-added to .gitignore"

建议提交:

- `CODEBUDDY.md`、`.codebuddy/settings.json`、`.codebuddy/agents/`、`.codebuddy/rules/`、`.codebuddy/skills/`、`.codebuddy/commands/`

### [Codex](https://github.com/openai/codex)

> 文档: <https://developers.openai.com/codex/guides/agents-md>

建议忽略:

- 无官方记载 — 会话、历史与凭据都保存在 `~/.codex/`

建议提交:

- `AGENTS.md`、`.codex/skills/`、`.agents/skills/` — Codex 会在从项目根到当前目录的每一层发现 `.agents/skills/`

视情况:

- `.codex/config.toml` — 项目级配置层；钩子与权限可共享，个人设置请留在本地（官方尚无 `.local` 约定）

### [Cursor](https://cursor.com)

> 文档: <https://cursor.com/docs/context/rules>

建议忽略:

- 无官方记载 — IDE 状态不落在项目内

建议提交:

- `.cursor/rules/*.mdc` — 官方建议 "Check your rules into git so your whole team benefits"
- `.cursorignore` — 限定 AI 可访问的文件范围

视情况:

- `.cursor/mcp.json` — 项目级 MCP 服务器；含明文密钥则忽略，或改用 `${env:VAR}` 引用后提交

### [DeepSeek Harness](https://www.deepseek.com/harness/en/)

> 文档: <https://github.com/deepseek-ai/deepseek-harness>

建议忽略:

- `AGENTS.local.md`、`CLAUDE.local.md` — 每个开发者的本地叠加文件，官方设计记录原文 "deliberately not committed"

建议提交:

- `AGENTS.md`、`CLAUDE.md` — 从项目根到会话目录逐层加载的基础指令

### [Gemini CLI](https://geminicli.com)

> 文档: <https://geminicli.com/docs/cli/settings>

建议忽略:

- 无官方记载 — 检查点与对话历史保存在 `~/.gemini/`，不进项目目录

建议提交:

- `GEMINI.md`、`.gemini/commands/*.toml` — 官方原文 "can be committed to version control and shared with your team"
- `.geminiignore` — Gemini CLI 自己的访问过滤文件，类似 `.gitignore`

视情况:

- `.gemini/settings.json` — 工作区设置会覆盖用户设置，提交前检查是否含个人配置

### [GitHub Copilot](https://github.com/features/copilot)

> 文档: <https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot>

建议忽略:

- 无 — CLI 配置与会话数据保存在 `~/.copilot/`，云端编码代理通过 PR 工作

建议提交:

- `.github/copilot-instructions.md`、`.github/instructions/*.instructions.md`、`AGENTS.md`

### [Google Antigravity](https://antigravity.google)

> 文档: <https://antigravity.google/docs/rules-workflows/>

建议忽略:

- 无官方记载

建议提交:

- `.agents/rules/`、`.agents/workflows/`、`.agents/skills/` — 工作区资产（旧版 `.agent/` 仍被读取；两者并存时复数 `.agents/` 优先）
- 项目根目录的 `GEMINI.md` 同样会被读取

说明:

- 请勿忽略 `.agents/` — Codex、Zed、Replit 等框架会读取同一目录下的技能

### [Hermes Agent](https://hermes-agent.nousresearch.com)

> 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files>

建议忽略:

- `AGENTS.override.md` — 官方原文 "Personal, per-directory override of AGENTS.md (typically gitignored)"

建议提交:

- `.hermes.md` 或 `HERMES.md` — 最高优先级的项目指令（优先级：`.hermes.md` → `AGENTS.override.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules`）

### [Kilo Code](https://kilo.ai)

> 文档: <https://kilo.ai/docs/customize/custom-rules>

建议忽略:

- 无官方记载

建议提交:

- `kilo.jsonc` — 项目配置；已提交的项目配置不能使用 `{env:VAR}` 引用，密钥请放全局配置
- `.kilo/rules/`（旧版 `.kilocode/rules/`）、`.kilocodeignore`

视情况:

- `.kilo/tui.json` / `.kilo/tui.jsonc` — 终端 UI 偏好（声音、主题、快捷键），属个人配置

### [MiMo Code](https://mimo.xiaomi.com/mimocode)

> 文档: <https://github.com/XiaomiMiMo/MiMo-Code>

建议忽略:

- `.mimocode/cache/`、`.mimocode/wiki/`、`.mimocode/wikis/`、`.mimo-worktrees/` — 与官方 MiMo-Code 仓库自身忽略的本地状态一致

建议提交:

- `.mimocode/mimocode.json`（或 `.jsonc`）、`.mimocode/agent/`、`.mimocode/skills/`、`.mimocode/workflows/`

说明:

- 会话、检查点与日志保存在 `~/.local/share/mimocode/` 和 `~/.cache/mimocode/`

### [OpenCode](https://opencode.ai)

> 文档: <https://opencode.ai/docs/config/>

建议忽略:

- `.opencode/plans/` — plan 模式写入的计划文件
- `.opencode/node_modules/`、`.opencode/package.json`、`.opencode/package-lock.json` — `.opencode/` 目录存在后 OpenCode 自动安装的插件依赖（OpenCode 会为它们写入自己的 `.opencode/.gitignore`）

建议提交:

- `opencode.json` / `opencode.jsonc` — 官方原文 "safe to be checked into Git"
- `.opencode/agents/`、`.opencode/commands/`、`.opencode/plugins/`、`.opencode/skills/`、`.opencode/tools/`、`.opencode/themes/`
- `AGENTS.md` — 官方原文 "You should commit your project's AGENTS.md file to Git"

### [Pi](https://pi.dev)

> 文档: <https://pi.dev/docs/latest/configuration>

建议忽略:

- `AGENTS.override.md` — 仅覆盖同目录的 `AGENTS.md` 或 `CLAUDE.md`，按惯例属个人文件

建议提交:

- `.pi/settings.json`、`.pi/SYSTEM.md`、`.pi/APPEND_SYSTEM.md`、`.pi/skills/`、`.pi/extensions/`、`.pi/prompts/`、`.pi/themes/` — 官方仓库自身就提交了 `.pi/` 目录

说明:

- 会话按工作目录分组保存在 `~/.pi/agent/sessions/`

### [Qwen Code](https://github.com/QwenLM/qwen-code)

> 文档: <https://github.com/QwenLM/qwen-code/blob/main/.gitignore>

建议忽略:

- `.qwen/skills/auto-skill-*/` — 由托管技能提取代理自动生成
- `.qwen/skills/learned-skill-*/` — 由 `/learn` 命令生成
- `.qwen/pending-skills/` — 自动生成技能的暂存区
- `.qwen-session` — `qwen serve` 生成的开发者本地会话标识

建议提交:

- `QWEN.md`、`.qwen/commands/`、`.qwen/agents/`、手写的 `.qwen/skills/`、`.qwen/team-memory/`（官方注释 "shared with collaborators THROUGH git"）、`.qwen/review-context.json`

说明:

- 官方仓库走得更远：整体忽略 `.qwen/*`，再以上述可共享路径做白名单放行

### [Replit](https://replit.com)

> 文档: <https://docs.replit.com/references/configuration/configuration>

建议忽略:

- `.local/` — 本地安装的 Agent 技能位于 `.local/secondary_skills/`

建议提交:

- `.replit`、`replit.nix` — `[gitHubImport]` 的 `requiredFiles` 默认值即这两项，设计上随仓库走

视情况:

- `replit.md` — 由 Replit Agent 自动维护；含团队约定时提交
- `.agents/skills/` — 已安装技能是常规文件，可共享

### [Trae](https://trae.ai)

> 文档: <https://docs.trae.cn/ide_rules>

建议忽略:

- 无官方记载 — 记忆与全局规则保存在 `~/.trae-cn/`，项目内无运行时产物

建议提交:

- `.trae/rules/*.md` — 项目规则，最多支持三层嵌套

说明:

- Trae 还会读取 `AGENTS.md`、`CLAUDE.md` 与 `CLAUDE.local.md`；`.local.` 变体按惯例忽略

### [Windsurf](https://windsurf.com)

> 文档: <https://docs.devin.ai/cli/reference/configuration/global-vs-local>

建议忽略:

- `AGENTS.local.md` — 官方原文 "Add it to your `.gitignore` so it stays local"
- `.devin/config.local.json`、`.devin/mcp_config.local.json` — 个人覆盖与本地 MCP 密钥，官方标注 "No (gitignored)"

建议提交:

- `.devin/rules/*.md`、`.devin/global_rules.md`、`.devin/config.json`、`.devin/mcp_config.json`、`.devin/skills/*/SKILL.md`
- `.windsurf/rules/*.md`、`.windsurfrules`、`.windsurf/skills/` — 旧版路径，仍被读取

说明:

- Windsurf 已于 2026 年 6 月更名为 Devin Desktop；CLI 会通过 `.git/info/exclude` 自动排除 `*.local.json` 文件
- Cascade 记忆保存在 `~/.codeium/windsurf/memories/`，从不进入仓库

### ZCode

> 文档: 未公开托管；以下条目基于本地工作区的实际观察

建议忽略:

- `.zcode/` — 存放会话数据的工作区目录（如 `.zcode/plans/plan-sess_<uuid>.md`）；不共享工作区资产时，整目录忽略是最简单的做法
- 替代方案：只忽略 `.zcode/plans/`，保留 `.zcode/skills/` 与 `.zcode/commands/` 供团队共享

建议提交:

- `AGENTS.md`、`.zcodeignore` — 上下文排除策略与 `.gitignore` 一样属于仓库级配置
- `.zcode/config.json`、`.zcode/skills/`、`.zcode/commands/` — 工作区级配置，"can be shared with a team through version control"

### [Zed](https://zed.dev)

> 文档: <https://zed.dev/docs/ai/instructions>

建议忽略:

- 无 — 会话与线程保存在 Zed 用户数据目录，Zed 不会在项目内创建运行时文件

建议提交:

- `.rules` — 始终生效的指令文件（优先级：`.rules` → `.cursorrules` → `.windsurfrules` → `.clinerules` → `.github/copilot-instructions.md` → `AGENT.md` → `AGENTS.md` → `CLAUDE.md` → `GEMINI.md`）
- `.zed/settings.json`、`.zed/tasks.json`、`.zed/debug.json`、`.agents/skills/`

## 请勿忽略这些文件

以下文件看似 harness 杂物，实则设计为提交共享：

- 根指令文件：`AGENTS.md`、`CLAUDE.md`、`GEMINI.md`、`QWEN.md`、`CODEBUDDY.md`
- `.agents/` 目录 — 跨框架的技能目录，Codex、Zed、Replit、Google Antigravity 等都会读取
- 规则目录：`.cursor/rules/`、`.claude/rules/`、`.trae/rules/`、`.devin/rules/`、`.kilo/rules/`、`.clinerules/`
- 忽略策略文件本身：`.zcodeignore`、`.aiderignore`、`.cursorignore`、`.geminiignore`、`.clineignore`、`.kilocodeignore`

个人文件的通用命名约定是 `.local.` / `.override.` 后缀（`AGENTS.local.md`、`CLAUDE.local.md`、`AGENTS.override.md`）以及 `settings.local.json`——这正是本仓库收集的条目。会话、缓存、计划等运行时状态大多保存在用户主目录，因此表现良好的框架在项目里留下的往往只有可共享的配置。

## 尚未覆盖

以下框架同样会向工作区写入文件，但尚未收集到经核实的条目：Augment Code、Amp、Crush、Devin（云端版）、Goose、Jules、Junie、Kiro、Serena。欢迎贡献，见 [AGENTS.md](AGENTS.md)。

## 参与贡献

欢迎提交 Issue 与 Pull Request。维护规范——条目核实要求、文档结构、排序约定——见 [AGENTS.md](AGENTS.md)。

## 许可证

[MIT](LICENSE)
