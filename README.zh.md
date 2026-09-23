| 中文 | [English](README.md) |
| ---- | -------------------- |

# agent-gitignore

AI 编码框架（harness，即 CLI 智能体与 IDE 助手）——Claude Code、Cursor、Aider、Qwen Code 等——会在工作区里留下各种杂物：对话历史、计划文件、缓存、自动生成的技能、个人设置，它们大多不应进入版本控制。与此同时，一些看起来像杂物的文件——`AGENTS.md`、`.agents/`、`.zcodeignore`——恰恰是设计为提交共享的。

本仓库收集 40+ 个 AI 编码框架的工作区产物，每一条目均经官方文档核实，并提供可直接使用的示例 `.gitignore` 文件。条目最后核对官方文档的时间为 2026 年 9 月。

## 快速开始

将 [examples/agent.gitignore](examples/agent.gitignore) 复制到仓库根目录作为 `.gitignore`，或按需追加其中的条目：

```bash
# 用完整版覆盖 .gitignore
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore -o .gitignore

# 或合并进已有的 .gitignore
curl -fsSL https://raw.githubusercontent.com/Leawind/agent-gitignore/main/examples/agent.gitignore >> .gitignore
```

追加合并非幂等 — 请只执行一次，或仅粘贴你需要的部分。若已有的 `.gitignore` 排除了某个父目录，其内部条目将不会生效。

提供两种版本：

- [examples/agent.gitignore](examples/agent.gitignore) — 完整版。凡有官方默认值之处遵循官方默认（例如 Aider 会自行忽略 `.aider*`），需要酌情判断的条目以注释形式标注。
- [examples/agent-conservative.gitignore](examples/agent-conservative.gitignore) — 保守版，只含无歧义的运行时状态、缓存和个人文件，不会误伤任何可共享配置。

关于 gitignore 语法：不带斜杠的模式在任意目录层级生效；`**/` 前缀可覆盖嵌套目录的每一层，因此 `**/.claude/settings.local.json` 对嵌套工作树同样有效。

下文每个条目都有三种判定之一：**建议忽略** — 应留在本地的运行时状态、缓存与个人覆盖文件；**建议提交** — 为版本控制而设计的规则、技能与共享配置；**视情况** — 可能含密钥或个人偏好，提交前请先阅读条目。当框架不在项目内留下任何东西时，章节会写 **无**（已核实：运行时状态保存在项目之外）或 **无官方记载**（官方文档未描述任何项目内产物）。

## 总览

| 框架                                      | 建议忽略                                                                                                | 建议提交                                                                             | 备注                                            |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------- |
| [Aider](#aider)                           | `.aider*`                                                                                               | `.aider.conf.yml`、`.aiderignore`（如需共享）                                        | Aider 默认自动把 `.aider*` 写入 `.gitignore`    |
| [Amazon Q Developer](#amazon-q-developer) | —                                                                                                       | `.amazonq/rules/`、`.amazonq/cli-agents/`                                            | 含 MCP 凭据的 agent JSON 走环境变量             |
| [Amp](#amp)                               | —                                                                                                       | `.amp/settings.json`、`.agents/setup`、`.agents/resume`                              | 线程保存在 Amp 服务端                           |
| [Augment Code](#augment-code)             | `.augment/settings.local.json`                                                                          | `.augment/settings.json`、`.augment/rules/`、`.augment-guidelines`、`.augmentignore` | `settings.local.json` 官方自动加入 `.gitignore` |
| [Baidu Comate](#baidu-comate)             | —                                                                                                       | `.comate/rules/`                                                                     | 项目规则随库共享，个人规则私有                  |
| [Claude Code](#claude-code)               | `CLAUDE.local.md`、`.claude/settings.local.json`、`.claude/agent-memory-local/`                         | `CLAUDE.md`、`.mcp.json`、`.claude/` 其余内容                                        | `settings.local.json` 自动进全局 git 排除       |
| [Cline](#cline)                           | —                                                                                                       | `.clinerules/` 或 `.cline/`、`.clineignore`                                          | 运行时状态保存在 `~/.cline/`                    |
| [CodeBuddy](#codebuddy)                   | `.codebuddy/settings.local.json`、`CODEBUDDY.local.md`                                                  | `CODEBUDDY.md`、`.codebuddy/` 其余内容                                               | `settings.local.json` 官方自动加入 `.gitignore` |
| [Codebuff](#codebuff)                     | —                                                                                                       | `knowledge.md`、`.agents/`                                                           | 默认跳过 `.gitignore` 命中的文件                |
| [CodeGeeX](#codegeex)                     | —                                                                                                       | —                                                                                    | 官方无项目产物记载                              |
| [Codex](#codex)                           | —                                                                                                       | `AGENTS.md`、`.codex/skills/`、`.agents/skills/`                                     | `.codex/config.toml` 视内容而定                 |
| [Continue](#continue)                     | —                                                                                                       | `.continue/rules/`                                                                   | 索引缓存位于 `~/.continue/index`                |
| [Crush](#crush)                           | `.crush/`                                                                                               | `.crushrc`、`.crushignore`、`crush.json`（已弃用）                                   | 日志落在 `.crush/logs/`，会话在用户数据目录     |
| [Cursor](#cursor)                         | —                                                                                                       | `.cursor/rules/`、`.cursorignore`                                                    | `.cursor/mcp.json` 可能含密钥                   |
| [DeepSeek Harness](#deepseek-harness)     | `AGENTS.local.md`、`CLAUDE.local.md`                                                                    | `AGENTS.md`、`CLAUDE.md`                                                             | 本地覆盖文件“刻意不提交”                        |
| [Devin](#devin)                           | —                                                                                                       | `.devin/wiki.json`、`AGENTS.md`                                                      | 云端代理；CLI 本地条目见 Windsurf 章节          |
| [Firebase Studio](#firebase-studio)       | `.idx/dev.local.nix`                                                                                    | `.idx/dev.nix`、`.idx/icon.png`                                                      | 官方文档直接给出 gitignore 示例；已宣布 sunset  |
| [Gemini CLI](#gemini-cli)                 | —                                                                                                       | `GEMINI.md`、`.gemini/settings.json`、`.gemini/commands/`                            | 检查点保存在 `~/.gemini/`，不进项目             |
| [GitHub Copilot](#github-copilot)         | —                                                                                                       | `.github/copilot-instructions.md`、`.github/instructions/`                           | CLI 运行时数据保存在 `~/.copilot/`              |
| [Google Antigravity](#google-antigravity) | —                                                                                                       | `.agents/`（旧版 `.agent/`）                                                         | `.agents/` 被多个框架读取，请勿忽略             |
| [Goose](#goose)                           | `.goose/`                                                                                               | `.goosehints`、`AGENTS.md`                                                           | Memory 扩展自动写入 `.goose/memory/`            |
| [Hermes Agent](#hermes-agent)             | `AGENTS.override.md`                                                                                    | `.hermes.md`、`HERMES.md`                                                            | 官方注明"typically gitignored"                  |
| [iFlow CLI](#iflow-cli)                   | —                                                                                                       | `IFLOW.md`、`.iflowignore`                                                           | 2026 年 4 月停服；`settings.json` 可能含密钥    |
| [Jules](#jules)                           | —                                                                                                       | `AGENTS.md`                                                                          | 云端 VM 工作，通过 PR 交付                      |
| [Junie](#junie)                           | —                                                                                                       | `.junie/AGENTS.md`、`.junie/plans/`                                                  | 计划官方明言 "editable, committable"            |
| [Kilo Code](#kilo-code)                   | —                                                                                                       | `kilo.jsonc`、`.kilo/rules/`、`.kilocodeignore`                                      | `.kilo/tui.json` 属个人偏好                     |
| [Kimi Code CLI](#kimi-code-cli)           | `.kimi-code/local.toml`                                                                                 | `AGENTS.md`、`.kimi-code/mcp.json`                                                   | 官方明确建议忽略 `local.toml`                   |
| [Kiro](#kiro)                             | —                                                                                                       | `.kiro/steering/`、`.kiro/specs/`、`.kiro/hooks/`、`.kiroignore`                     | `.kiro/settings/mcp.json` 不得含凭据            |
| [MiMo Code](#mimo-code)                   | `.mimocode/cache/`、`.mimocode/wiki/`、`.mimocode/wikis/`、`.mimo-worktrees/`                           | `.mimocode/`（配置、技能、工作流）                                                   | 条目与官方仓库自身的 `.gitignore` 一致          |
| [OpenCode](#opencode)                     | `.opencode/plans/`、`.opencode/node_modules/`、`.opencode/package.json`、`.opencode/package-lock.json`  | `opencode.json`、`.opencode/`（agents、commands、plugins 等）                        | 插件依赖会被自动安装进 `.opencode/`             |
| [OpenHands](#openhands)                   | —                                                                                                       | `.openhands/`、`.agents/skills/`、`AGENTS.md`                                        | 旧版 `.openhands/microagents/` 仍受支持         |
| [Pi](#pi)                                 | `AGENTS.override.md`                                                                                    | `.pi/`（settings、skills、prompts 等）                                               | 会话保存在 `~/.pi/agent/sessions/`              |
| [Qoder](#qoder)                           | `.qoder/settings.local.json`、`.qoder/worktrees/`                                                       | `.qoder/rules/`、`.qoder/settings.json`、`.qoder/repowiki/`                          | `rules/` 默认可共享                             |
| [Qwen Code](#qwen-code)                   | `.qwen/skills/auto-skill-*/`、`.qwen/skills/learned-skill-*/`、`.qwen/pending-skills/`、`.qwen-session` | `QWEN.md`、`.qwen/commands/`、`.qwen/agents/`、`.qwen/team-memory/`                  | 官方仓库以白名单方式忽略 `.qwen/*`              |
| [Replit](#replit)                         | `.local/`                                                                                               | `.replit`、`replit.nix`、`replit.md`                                                 | 本地 Agent 技能位于 `.local/secondary_skills/`  |
| [Roo Code](#roo-code)                     | —                                                                                                       | `.roo/rules/`、`.roomodes`、`.rooignore`                                             | `.roo/rules/` 设计为版本控制                    |
| [Serena](#serena)                         | `.serena/cache/`、`.serena/project.local.yml`                                                           | `.serena/project.yml`、`.serena/memories/`                                           | 激活时自动生成 `.serena/.gitignore`             |
| [Sourcegraph Cody](#sourcegraph-cody)     | —                                                                                                       | —                                                                                    | 上下文在服务端；检索遵循 `.gitignore`           |
| [Tabnine](#tabnine)                       | —                                                                                                       | `.tabnine/guidelines/`                                                               | 类 AGENTS.md 的项目指引                         |
| [Trae](#trae)                             | —                                                                                                       | `.trae/rules/`                                                                       | 记忆数据保存在用户主目录                        |
| [Warp](#warp)                             | —                                                                                                       | `WARP.md`、`.warp/workflows/`                                                        | 官方不存在 `.warp/rules/`                       |
| [Windsurf](#windsurf)                     | `AGENTS.local.md`、`.devin/config.local.json`、`.devin/mcp_config.local.json`                           | `.devin/`（rules、skills、config）、`.windsurf/`（旧版）                             | 2026 年 6 月更名为 Devin Desktop                |
| [ZCode](#zcode)                           | `.zcode/`（或仅 `.zcode/plans/`）                                                                       | `AGENTS.md`、`.zcodeignore`、`.zcode/skills/`                                        | 会话计划属运行时产物                            |
| [Zed](#zed)                               | —                                                                                                       | `.rules`、`.zed/`、`.agents/skills/`                                                 | 会话保存在 Zed 的用户数据目录                   |

## 框架

### [Aider](https://aider.chat)

> 文档: <https://aider.chat/docs/config/options.html>

建议忽略:

- `.aider*` — 对话历史（`.aider.chat.history.md`）、输入历史（`.aider.input.history`）、repo map 缓存（`.aider.tags.cache.v4/`）等。官方 `--gitignore` 开关默认开启，首次运行时 Aider 会自动把 `.aider*` 写入 `.gitignore`

建议提交（需放行时取消注释）:

- `.aider.conf.yml` — 放在仓库根目录即为团队共享配置
- `.aiderignore` — 声明 Aider 不应触碰的文件

### [Amazon Q Developer](https://aws.amazon.com/q/developer/)

> 文档: <https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/context-project-rules.html>

建议忽略:

- 无官方记载

建议提交:

- `.amazonq/rules/*.md` — 项目规则；官方文档流程明确 "Commit, review, and merge your changes"
- `.amazonq/cli-agents/*.json` — 工作区级 agent 配置，官方说明可经版本控制与团队共享（"via version control"）（旧版 `.amazonq/mcp.json` 已并入这些 agent 文件）

视情况:

- 含 MCP 凭据的 agent JSON — 官方建议 "Use environment variables for sensitive configuration"，密钥不进已提交的文件

### [Amp](https://ampcode.com)

> 文档: <https://ampcode.com/docs/cli/settings>

建议忽略:

- 无 — 线程保存在 Amp 服务端并通过 URL 共享，pre-clone 脚本也存放在仓库之外

建议提交:

- `.amp/settings.json`（或 `.jsonc`）— 工作区设置，从当前目录向上搜索到仓库根
- `.agents/setup`、`.agents/resume` — Orb 初始化脚本；官方原文 "Both files are optional. Commit them to the repository."（2026 年 8 月另推出了免提交的 setup 流程）

### [Augment Code](https://www.augmentcode.com)

> 文档: <https://docs.augmentcode.com/cli/config>

建议忽略:

- `.augment/settings.local.json` — 官方原文 "Automatically added to `.gitignore` and should not be committed"

建议提交:

- `.augment/settings.json`、`.augment/rules/*.md` — 项目规则，官方说明通过版本控制与团队共享
- `.augment-guidelines`、`.augmentignore`

### [Baidu Comate](https://comate.baidu.com)

> 文档: <https://cloud.baidu.com/doc/COMATE/s/Zm9l4agw3>

建议忽略:

- 无官方记载

建议提交:

- `.comate/rules/*.mdr` — 项目规则，官方原文“随项目/代码库共享，团队成员均可使用”

视情况:

- 个人 Rules — 官方区分“个人 Rules”（个人偏好）与项目规则，但未说明个人规则的项目内路径；私有内容请勿放入共享目录

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

### [Codebuff](https://www.codebuff.com)

> 文档: <https://www.codebuff.com/docs/tips/knowledge-files>

建议忽略:

- 无官方记载

建议提交:

- `knowledge.md` — 由 `/init` 生成，紧邻其描述的代码存放
- `.agents/` — 自定义 TypeScript agent 与 `.agents/skills/`

说明:

- Codebuff 默认跳过 `.gitignore` 命中的文件；`.codebuffignore` 可追加排除
- 旧版本的 `.codebuff/` 目录结构已废弃

### [CodeGeeX](https://codegeex.cn)

> 文档: <https://github.com/CodeGeeX/codegeex-vscode-extension>

建议忽略:

- 无官方记载 — 开源插件把状态保存在 VS Code 私有存储中，官方来源未描述任何项目内文件

说明:

- 社区文章提到 `.codegeex/` 目录，但没有任何官方文档证实；本仓库不收录未经验证的路径

### [Codex](https://github.com/openai/codex)

> 文档: <https://developers.openai.com/codex/guides/agents-md>

建议忽略:

- 无官方记载 — 会话、历史与凭据都保存在 `~/.codex/`

建议提交:

- `AGENTS.md`、`.codex/skills/`、`.agents/skills/` — Codex 会在从项目根到当前目录的每一层发现 `.agents/skills/`

视情况:

- `.codex/config.toml` — 项目级配置层；钩子与权限可共享，个人设置请留在本地（官方尚无 `.local` 约定）

### [Continue](https://continue.dev)

> 文档: <https://docs.continue.dev/customize/rules>

建议忽略:

- 无 — 索引缓存位于 `~/.continue/index`，在项目之外

建议提交:

- `.continue/rules/*.md` — 项目规则，官方说明 "Version controlled alongside your code"

视情况:

- `.continueignore` — 官方原文 "follows the exact same rules as .gitignore"；官方仅定义功能，未表态是否提交

### [Crush](https://github.com/charmbracelet/crush)

> 文档: <https://github.com/charmbracelet/crush>

建议忽略:

- `.crush/` — 运行日志落在 `.crush/logs/crush.log`；会话状态保存在 `~/.local/share/crush/`

建议提交:

- `.crushrc`（或 `crushrc`）— 项目级命令与配置
- `.crushignore` — 让 Crush 跳过指定文件；Crush 默认遵循 `.gitignore`
- `crush.json` — 旧版配置，仍受支持但已弃用

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

### [Devin](https://devin.ai)

> 文档: <https://docs.devin.ai>

建议忽略:

- 云端代理本身无本地产物 — 它在自己的 VM 中工作，通过 PR 交付；Devin CLI 的个人文件（`.devin/config.local.json`、`.devin/mcp_config.local.json`）已在 [Windsurf](#windsurf) 章节覆盖

建议提交:

- `.devin/wiki.json` — DeepWiki 定制；官方原文 "Commit the file and regenerate your wiki"
- `AGENTS.md` — 官方说明 "Devin will look for the file before it starts coding"

### [Firebase Studio](https://firebase.google.com/docs/studio)

> 文档: <https://firebase.google.com/docs/studio/devnix-reference>

建议忽略:

- `.idx/dev.local.nix` — 本地个人化 Nix 配置；官方文档的 `.gitignore` 示例中直接包含这一条

建议提交:

- `.idx/dev.nix` — 官方原文 "share your Nix configuration file as part of your Git repository to ensure everyone who works on your project has the same environment configuration"
- `.idx/icon.png` — 官方原文 "can be checked into source control"

视情况:

- `.idx/mcp.json` — MCP 服务器配置；官方未给出 git 指引

说明:

- Google 已宣布 Firebase Studio 进入退役阶段（sunset）；以上条目适用于存量工作区

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

- `.agents/rules/`、`.agents/workflows/`、`.agents/skills/` — 工作区资产（旧版 `.agent/` 仍被读取；两者并存时带 s 的 `.agents/` 优先）
- 项目根目录的 `GEMINI.md` 同样会被读取

说明:

- 请勿忽略 `.agents/` — [Codex](#codex)、[Zed](#zed)、[Replit](#replit) 等框架会读取同一目录下的技能

### [Goose](https://goose-docs.ai)

> 文档: <https://goose-docs.ai/docs/mcp/memory-mcp>

建议忽略:

- `.goose/` — Memory 扩展把项目记忆自动写入 `.goose/memory/`，会话保存在 `~/.local/share/goose/sessions/`；官方无 `.gitignore` 建议，此条基于官方“自动存储”的描述

建议提交:

- `.goosehints`、`AGENTS.md` — Goose 默认加载的上下文文件

### [Hermes Agent](https://hermes-agent.nousresearch.com)

> 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files>

建议忽略:

- `AGENTS.override.md` — 官方原文 "Personal, per-directory override of AGENTS.md (typically gitignored)"

建议提交:

- `.hermes.md` 或 `HERMES.md` — 最高优先级的项目指令（优先级：`.hermes.md` → `AGENTS.override.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules`）

### [iFlow CLI](https://github.com/iflow-ai/iflow-cli)

> 文档: <https://github.com/iflow-ai/iflow-cli>

> iFlow CLI 已于 2026 年 4 月 17 日停止服务，官方建议迁移至 Qoder。以下条目适用于存量仓库。

建议忽略:

- 无官方记载 — 检查点与会话保存在 `~/.iflow/`，从不进入项目的 Git 仓库

建议提交:

- `IFLOW.md` — 由 `/init` 生成的项目上下文
- `.iflowignore`、`.iflow/sandbox-macos-custom.sb`、`.iflow/sandbox.Dockerfile` — 共享的文件发现与沙箱配置

视情况:

- `.iflow/settings.json` — 项目设置可能含 `apiKey`、`baseUrl` 等字段，含凭据时请留在本地（官方无 .gitignore 建议）

### [Jules](https://jules.google)

> 文档: <https://jules.google/docs>

建议忽略:

- 无 — Jules 把仓库克隆到云端 VM 中工作，通过分支和 PR 交付

建议提交:

- `AGENTS.md` — 官方说明 "Jules will also refer to agents.md"

### [Junie](https://www.jetbrains.com/junie/)

> 文档: <https://junie.jetbrains.com/docs/guidelines-and-memory.html>

建议忽略:

- 无 — 计划与规范均设计为提交

建议提交:

- `.junie/AGENTS.md` — 团队编码规范；旧版 `.junie/guidelines.md` 仍受支持
- `.junie/plans/` — 产品主页原文 "editable, committable"；JetBrains 官方博客称之为 "living task documentation"

### [Kilo Code](https://kilo.ai)

> 文档: <https://kilo.ai/docs/customize/custom-rules>

建议忽略:

- 无官方记载

建议提交:

- `kilo.jsonc` — 项目配置；已提交的项目配置不能使用 `{env:VAR}` 引用，密钥请放在全局配置中
- `.kilo/rules/`（旧版 `.kilocode/rules/`）、`.kilocodeignore`

视情况:

- `.kilo/tui.json` / `.kilo/tui.jsonc` — 终端 UI 偏好（声音、主题、快捷键），属个人配置

### [Kimi Code CLI](https://github.com/MoonshotAI/kimi-code)

> 文档: <https://moonshotai.github.io/kimi-code/en/configuration/config-files.html>

建议忽略:

- `.kimi-code/local.toml` — 官方原文 "we recommend adding .kimi-code/local.toml to your project's .gitignore so it is not committed"（其中保存本机专属的绝对路径）

建议提交:

- `AGENTS.md` — 由 `/init` 生成和更新
- `.kimi-code/mcp.json` — 项目级 MCP 服务器

说明:

- 前代 Kimi CLI（`MoonshotAI/kimi-cli`）仓库已归档，其状态完全存放在 `~/.kimi/`

### [Kiro](https://kiro.dev)

> 文档: <https://kiro.dev/docs/>

建议忽略:

- 默认无 — 官方原文 "Shared project configuration travels with your repository through .kiro/"

建议提交:

- `.kiro/steering/` — 官方原文 "Steering files are part of your codebase"
- `.kiro/specs/`、`.kiro/hooks/`、`.kiroignore`

视情况:

- `.kiro/settings/mcp.json` — 工作区 MCP 服务器；官方红线 "Never commit configuration files with credentials to version control"，请用 `${VARIABLE}` 引用或留在本地

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

- `.opencode/plans/` — plan 模式写入的计划文件（位于 Git 仓库内时；否则写入全局数据目录）
- `.opencode/node_modules/`、`.opencode/package.json`、`.opencode/package-lock.json` — `.opencode/` 目录存在后 OpenCode 自动安装的插件依赖（OpenCode 会为它们写入自己的 `.opencode/.gitignore`）

建议提交:

- `opencode.json` / `opencode.jsonc` — 官方原文 "safe to be checked into Git"
- `.opencode/agents/`、`.opencode/commands/`、`.opencode/plugins/`、`.opencode/skills/`、`.opencode/tools/`、`.opencode/themes/`
- `AGENTS.md` — 官方原文 "You should commit your project's AGENTS.md file to Git"

### [OpenHands](https://github.com/All-Hands-AI/OpenHands)

> 文档: <https://docs.openhands.dev/openhands/usage/customization/repository>

建议忽略:

- 无官方记载

建议提交:

- `.openhands/setup.sh` — OpenHands 每次开始处理该仓库时运行
- `.openhands/hooks.json`、`.openhands/hooks/` — 生命周期钩子
- `.agents/skills/` — 推荐的仓库技能位置；旧版 `.openhands/skills/` 与 `.openhands/microagents/` 仍受支持
- `AGENTS.md` — 始终作为仓库上下文加载

### [Pi](https://pi.dev)

> 文档: <https://pi.dev/docs/latest/configuration>

建议忽略:

- `AGENTS.override.md` — 仅覆盖同目录的 `AGENTS.md` 或 `CLAUDE.md`，按惯例属个人文件

建议提交:

- `.pi/settings.json`、`.pi/SYSTEM.md`、`.pi/APPEND_SYSTEM.md`、`.pi/skills/`、`.pi/extensions/`、`.pi/prompts/`、`.pi/themes/` — 官方仓库自身就提交了 `.pi/` 目录

说明:

- 会话按工作目录分组保存在 `~/.pi/agent/sessions/`

### [Qoder](https://qoder.com)

> 文档: <https://docs.qoder.com/cli/config-scope>

建议忽略:

- `.qoder/settings.local.json` — 官方原文 "Typically, `.qoder/settings.local.json` should be added to `.gitignore`"
- `.qoder/worktrees/` — CLI `--worktree` 开关创建的隔离工作树

建议提交:

- `.qoder/rules/`、`.qoder/settings.json`、`.qoder/skills/` — 官方说明适合提交到版本控制仓库
- `.qoder/repowiki/` — 本地生成的 Repo Wiki；`wiki_plan.yaml` 官方原文 "is shared with the team via Git commits"
- `AGENTS.md`、`.qoderignore`

视情况:

- `.qoder/rules/` — 若规则仅供本地使用，官方文档建议改为把该目录加入 `.gitignore`

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

- `.replit`、`replit.nix` — `[gitHubImport]` 的 `requiredFiles` 默认值即这两项，设计上随仓库一同提交

视情况:

- `replit.md` — 由 Replit Agent 自动维护；含团队约定时提交
- `.agents/skills/` — 已安装技能是常规文件，可共享

### [Roo Code](https://roocode.com)

> 文档: <https://roocodeinc.github.io/Roo-Code/features/custom-instructions>

建议忽略:

- 无官方记载

建议提交:

- `.roo/rules/`、`.roo/rules-{mode}/` — 官方原文 "under version control to standardize Roo's behavior for specific projects"
- `.roomodes` — 项目级自定义模式
- `.rooignore`、`AGENTS.md`

视情况:

- `.roorules` — 规则的单文件回退形式；按惯例可共享，但官方版本控制指引针对目录形式

### [Serena](https://github.com/oraios/serena)

> 文档: <https://oraios.github.io/serena/>

建议忽略:

- `.serena/cache/`、`.serena/project.local.yml` — 本地状态；Serena 首次激活时会自动生成内容恰为这两项的 `.serena/.gitignore`，此处的条目用于在那之前兜底

建议提交:

- `.serena/project.yml` — 官方原文 "intended to be versioned together with the project"
- `.serena/memories/` — 官方原文 "can be committed, reviewed in PRs, and reverted like any other repository artifact"

### [Sourcegraph Cody](https://sourcegraph.com/docs/cody)

> 文档: <https://sourcegraph.com/docs/cody>

建议忽略:

- 无官方记载 — 提示词与上下文保存在 Sourcegraph 服务端，Cody 的文件查找遵循 `.gitignore`

视情况:

- `.sourcegraph/instructions.md` — 早期版本的社区惯例；现行官方文档已不再提及

### [Tabnine](https://www.tabnine.com)

> 文档: <https://docs.tabnine.com/main/getting-started/tabnine-agent/guidelines.md>

建议忽略:

- 无官方记载

建议提交:

- `.tabnine/guidelines/*.md` — 项目指引，官方原文 "in a similar fashion to the agents.md file that other agentic tools use"

视情况:

- `.tabnine/agent/settings.json` — 项目级覆盖设置；团队统一配置可提交，个人偏好留在本地

### [Trae](https://trae.ai)

> 文档: <https://docs.trae.cn/ide_rules>

建议忽略:

- 无官方记载 — 记忆与全局规则保存在 `~/.trae-cn/`，项目内无运行时产物

建议提交:

- `.trae/rules/*.md` — 项目规则，最多支持三层嵌套

说明:

- Trae 还会读取 `AGENTS.md`、`CLAUDE.md` 与 `CLAUDE.local.md`；`.local.` 变体按惯例忽略

### [Warp](https://www.warp.dev)

> 文档: <https://docs.warp.dev/agents/capabilities/rules>

建议忽略:

- 无官方记载 — Agent 记忆保存在 Warp 云端，全局规则存于 Warp Drive

建议提交:

- `WARP.md`（或 `AGENTS.md`）— 项目规则；两者并存时 `WARP.md` 优先
- `.warp/workflows/*.yaml` — 仓库级工作流，官方原文 "can be accessed by anyone who has cloned the repo"

说明:

- `.warp/rules/` 见于社区模板，但现行官方文档中不存在该目录

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

### [ZCode](https://zcode.z.ai)

> 文档: <https://zcode.z.ai> — 公开文档未记载这些工作区路径；以下条目基于本地工作区的实际观察

建议忽略:

- `.zcode/` — 存放会话数据的工作区目录（如 `.zcode/plans/plan-sess_<uuid>.md`）；不共享工作区资产时，整目录忽略是最简单的做法
- 替代方案：只忽略 `.zcode/plans/`，保留 `.zcode/skills/` 与 `.zcode/commands/` 供团队共享

建议提交:

- `AGENTS.md`、`.zcodeignore` — 上下文排除策略与 `.gitignore` 一样属于仓库级配置
- `.zcode/config.json`、`.zcode/skills/`、`.zcode/commands/` — 工作区级配置，"can be shared with a team through version control"

### [Zed](https://zed.dev)

> 文档: <https://zed.dev/docs/ai/instructions>

建议忽略:

- 无 — 会话与线程保存在 Zed 的用户数据目录，Zed 不会在项目内创建运行时文件

建议提交:

- `.rules` — 始终生效的指令文件（优先级：`.rules` → `.cursorrules` → `.windsurfrules` → `.clinerules` → `.github/copilot-instructions.md` → `AGENT.md` → `AGENTS.md` → `CLAUDE.md` → `GEMINI.md`）
- `.zed/settings.json`、`.zed/tasks.json`、`.zed/debug.json`、`.agents/skills/`

## 请勿忽略这些文件

以下文件看似框架杂物，实则设计为提交共享：

- 根指令文件：`AGENTS.md`、`CLAUDE.md`、`GEMINI.md`、`QWEN.md`、`CODEBUDDY.md`
- `.agents/` 目录 — 跨框架的技能目录，Codex、Zed、Replit、Google Antigravity 等都会读取
- 规则目录：`.cursor/rules/`、`.claude/rules/`、`.trae/rules/`、`.devin/rules/`、`.kilo/rules/`、`.clinerules/`
- 忽略策略文件本身：`.zcodeignore`、`.aiderignore`、`.cursorignore`、`.geminiignore`、`.clineignore`、`.kilocodeignore`

个人文件的通用命名约定是 `.local.` / `.override.` 后缀（`AGENTS.local.md`、`CLAUDE.local.md`、`AGENTS.override.md`）以及 `settings.local.json`——这正是本仓库收集的条目。会话、缓存、计划等运行时状态大多保存在用户主目录，因此表现良好的框架在项目里留下的往往只有可共享的配置。

## 参与贡献

欢迎提交 Issue 与 Pull Request。维护规范——条目核实要求、文档结构、排序约定——见 [AGENTS.md](AGENTS.md)（当前以中文撰写）。发现条目与官方文档不符，欢迎提 Issue 反馈。

贡献速记：

1. 每个条目必须有官方文档页或官方仓库作为出处，不收录猜测的路径。
2. 每个条目归入 建议忽略（运行时状态、缓存、个人覆盖）、建议提交（规则、共享配置）、视情况（可能含密钥或个人偏好）之一。
3. 四处同步：双语 README 与两个示例文件，并保持字母排序。
4. 提交前运行 `deno task fmt` 与 `deno task test`。

## 许可证

[MIT](LICENSE)
