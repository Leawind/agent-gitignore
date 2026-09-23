> **归档说明 / Archived**: 本仓库已改作他用（agent-gitignore）。本文档为旧用途「Vibe Coding Tools 规则文件大全」的存档版本，不再维护；当前内容见根目录 README.md / README.zh.md。历史版本可参考 tag `vibe-rule-files-final`。

| 中文 | [English](README.md) |
| ---- | -------------------- |

# Rule Files of Vibe Coding Tools

## 总览

| 工具               | 项目规则文件                                                        | 备注                                                                     |
| ------------------ | ------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Aider              | `CONVENTIONS.md`                                                    | 通过 `--read` 或 `.aider.conf.yml` 的 `read:` 以只读方式加载             |
| Claude Code        | `CLAUDE.md`、`.claude/rules/*.md`                                   | 支持 `@import` 语法导入其他文件                                          |
| Cline              | `.clinerules/*.md`                                                  | 同时兼容 `.cursorrules`、`.windsurfrules`、`AGENTS.md`                   |
| CodeBuddy          | `CODEBUDDY.md`、`.codebuddy/rules/*/RULE.mdc`                       | 规则类型分为 Always、Agent Requested、Manual                             |
| Codex              | `AGENTS.md`                                                         | 支持 `@import` 语法导入其他文件                                          |
| Cursor             | `.cursor/rules/*.mdc`、`AGENTS.md`                                  | `.mdc` 文件支持 frontmatter 控制触发方式                                 |
| DeepSeek Harness   | `AGENTS.md`、`CLAUDE.md`                                            | 支持 `.local.md` 本地覆盖与层级加载；全局文件位于 `~/.dsh/`              |
| Gemini CLI         | `GEMINI.md`                                                         | 支持 `@file.md` 语法导入子文件                                           |
| GitHub Copilot     | `.github/copilot-instructions.md`、`AGENTS.md`                      | 路径特定规则放在 `.github/instructions/*.instructions.md`                |
| Google Antigravity | `.agents/rules/*.md`                                                | 激活模式：Manual、Always On、Model Decision、Glob；支持 `@filename` 引用 |
| Hermes Agent       | `.hermes.md`、`HERMES.md`、`AGENTS.md`、`CLAUDE.md`、`.cursorrules` | 支持渐进式子目录发现；`SOUL.md` 用于全局个性定制                         |
| Kilo Code          | `.kilo/rules/*.md` (推荐)                                           | 通过 `kilo.jsonc` 配置指令路径，兼容旧版 `.kilocode/`                    |
| MiMo Code          | `AGENTS.md`、`CLAUDE.md`                                            | 可在 `mimocode.json` 中自定义指令文件路径                                |
| OpenCode           | `AGENTS.md`                                                         | 可在 `opencode.json` 中自定义指令文件路径                                |
| Pi                 | `AGENTS.md`                                                         | 按全局到项目的层级加载 `AGENTS.md` 并注入系统提示                        |
| Qwen Code          | `QWEN.md`                                                           | 三层级：全局 `~/.qwen/QWEN.md`、项目根、子目录                           |
| Replit             | `replit.md`                                                         | 由 Replit Agent 自动维护，内容过长时自动压缩                             |
| Trae               | `.trae/rules/*.md`                                                  | 支持 frontmatter 控制触发场景（如 `scene: git_message`）                 |
| Windsurf           | `.devin/rules/*.md`、`.windsurf/rules/*.md`                         | frontmatter `trigger`：`always_on`、`model_decision`、`glob`、`manual`   |
| Zed                | `.rules`、`AGENTS.md`                                               | 自动识别 `.cursorrules`、`.windsurfrules` 等，首个匹配生效               |

## 工具

### [Aider](https://aider.chat)

> 文档: <https://aider.chat/docs/usage/tips.html>

项目规则文件:

- 主要: 项目根目录的 `CONVENTIONS.md` — 描述代码编写规范
- 加载方式: 通过 `--read` 参数传入，或在 `.aider.conf.yml` 中配置 `read: CONVENTIONS.md`

加载说明:

- 规范文件以只读方式注入每次对话
- 其他只读上下文文件也可用同样方式配置

### [Claude Code](https://claude.ai/code)

> 文档: <https://docs.anthropic.com/en/docs/claude-code/memory>

项目规则文件:

- 主要: 项目根目录的 `CLAUDE.md` 或 `.claude/CLAUDE.md`
- 细分规则: `.claude/rules/*.md` — 可按文件路径或主题拆分
- 个人偏好: `CLAUDE.local.md` — 加入 `.gitignore`，不提交到版本控制

层级加载顺序 (从宽到窄):

1. 组织级: `/etc/claude-code/CLAUDE.md`
2. 用户级: `~/.claude/CLAUDE.md`
3. 项目级: `./CLAUDE.md` 或 `./.claude/CLAUDE.md`
4. 本地级: `./CLAUDE.local.md`

### [Cline](https://cline.bot)

> 文档: <https://docs.cline.bot/features/cline-rules>

项目规则文件:

- 主要: `.clinerules/*.md` — 支持 `.md` 和 `.txt` 文件
- 自动兼容: 也会识别 `.cursorrules`、`.windsurfrules`、`AGENTS.md`
- 全局规则: `~/Documents/Cline/Rules/`

### [CodeBuddy](https://www.codebuddy.ai)

> 文档: <https://www.codebuddy.ai/docs/ide/Rules>

项目规则文件:

- 主文件: 项目根目录的 `CODEBUDDY.md` — 提供项目上下文和全局指令
- 细分规则: `.codebuddy/rules/*/RULE.mdc` — 每个规则对应一个包含 `RULE.mdc`
  的文件夹
- 全局规则: `~/.codebuddy/CODEBUDDY.md` 及 `~/.codebuddy/rules/`

规则类型:

| 类型              | 说明                      |
| ----------------- | ------------------------- |
| `Always`          | 始终生效                  |
| `Agent Requested` | AI 根据上下文自行判断启用 |
| `Manual`          | 仅在手动指定时生效        |

### [Codex](https://github.com/openai/codex)

> 文档: <https://github.com/openai/codex>

项目规则文件:

- 主要: 项目根目录的 `AGENTS.md` — 提供项目级指令
- 支持 `@import` 语法导入其他文件
- 全局: `~/.codex/AGENTS.md`（如适用）

### [Cursor](https://cursor.com)

> 文档: <https://cursor.com/docs/rules>

项目规则文件:

- 主要: `.cursor/rules/*.mdc` — 使用 `.mdc` 扩展名，通过 frontmatter
  控制触发方式
- 简单替代: 项目根目录的 `AGENTS.md` — 纯 Markdown，无需配置

规则类型 (通过 frontmatter 控制):

| 类型                    | 说明                        |
| ----------------------- | --------------------------- |
| `alwaysApply: true`     | 每次对话都生效              |
| `globs: "src/**/*.tsx"` | 匹配特定文件时自动生效      |
| `description: "..."`    | AI 根据描述自行判断是否启用 |
| 手动 `@rule-name`       | 仅在聊天中 @提及时生效      |

### [DeepSeek Harness](https://www.deepseek.com/harness/en/)

> 文档: <https://github.com/deepseek-ai/deepseek-harness>

项目规则文件:

- 主要: `AGENTS.md` — 从全局目录及项目目录链中的每一层目录加载
- 兼容: `CLAUDE.md` — 与 `AGENTS.md` 一同加载，重复内容自动去重
- 本地覆盖: `AGENTS.local.md`、`CLAUDE.local.md` — 追加式本地文件，在基础文件之后加载
- 全局: `~/.dsh/`（或 `$DSH_HOME`）中的 `AGENTS.md`

层级加载顺序 (从宽到窄):

1. 全局: `~/.dsh/` 中的 `AGENTS.md`
2. 项目链: 从项目根目录到会话工作目录之间每一层的 `AGENTS.md` / `CLAUDE.md`
3. 动态刷新: 文件操作到达更深目录后，自动纳入该层级的指令文件

配置说明:

- 由内置插件 `@deepseek-ai/dsh-agent-instructions` 加载；文件候选、项目根标记、字节预算等均可通过插件配置调整
- 渲染结果受字节预算约束（默认 65,536 字节）；超预算时优先省略较宽泛的文件，而非截断最具体的文件

### [Gemini CLI](https://geminicli.com)

> 文档: <https://geminicli.com/docs/cli/gemini-md>

项目规则文件:

- 主要: 项目根目录的 `GEMINI.md`
- 子目录: 任意子目录中的 `GEMINI.md` — 仅在访问该目录时加载
- 全局: `~/.gemini/GEMINI.md`

层级加载顺序:

1. 全局: `~/.gemini/GEMINI.md`
2. 工作区: 从当前目录向上搜索 `GEMINI.md`
3. 即时加载 (JIT): 访问文件/目录时自动加载该目录的 `GEMINI.md`

支持导入语法: `@path/to/file.md`

### [GitHub Copilot](https://github.com/features/copilot)

> 文档: <https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot>

项目规则文件:

- 仓库级: `.github/copilot-instructions.md` — 对整个仓库生效
- 路径特定: `.github/instructions/*.instructions.md` — 文件名必须以
  `.instructions.md` 结尾
- Agent 指令: 项目根目录的 `AGENTS.md`（或 `CLAUDE.md`、`GEMINI.md`）

### [Google Antigravity](https://antigravity.google)

> 文档: <https://antigravity.google/docs/rules-workflows/>

项目规则文件:

- 主要: `.agents/rules/*.md` — 工作区级规则，每个 Markdown 文件对应一条规则
- 全局: `~/.gemini/GEMINI.md` — 对所有工作区生效
- 引用: `@filename` — 在对话中附加其他规则文件

激活模式:

| 模式           | 说明                             |
| -------------- | -------------------------------- |
| Manual         | 仅在手动指定时生效               |
| Always On      | 每次交互都生效                   |
| Model Decision | 智能体判断相关时自行读取完整规则 |
| Glob           | 触碰匹配 glob 模式的文件时生效   |

### [Hermes Agent](https://hermes-agent.nousresearch.com)

> 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files>

项目规则文件:

- 主要: `.hermes.md` 或 `HERMES.md` — 最高优先级的项目指令
- 兼容: `AGENTS.md`、`CLAUDE.md`、`.cursorrules` — 同样会被检测和加载
- 全局个性: `~/.hermes/SOUL.md` — 控制代理的语气和沟通风格
- Cursor 规则: `.cursor/rules/*.mdc` — Cursor IDE 规则模块（如果没有更高优先级的文件）

优先级系统 (第一个匹配的生效):

1. `.hermes.md` / `HERMES.md`
2. `AGENTS.md`
3. `CLAUDE.md`
4. `.cursorrules`

特性:

- 渐进式子目录发现: 导航到子目录时会自动加载其中的 `AGENTS.md` 文件
- 安全扫描: 所有上下文文件都会检查提示注入模式
- 大小限制: 超过 20,000 字符的文件会被截断（70% 头部，20% 尾部）

### [Kilo Code](https://kilo.ai)

> 文档: <https://kilo.ai/docs/customize/custom-rules>

项目规则文件:

- 推荐配置: 在 `kilo.jsonc` 中通过 `instructions` 数组指定路径，默认推荐 `.kilo/rules/*.md`
- 兼容路径: `.kilocode/rules/*.md` — 旧版路径，仍被支持但不推荐新建项目使用
- 全局规则: 在 `~/.config/kilo/kilo.jsonc` 中配置

规则说明:

- 支持通过规则统一代码格式化标准、限制敏感文件访问及强制执行编码规范
- 建议通过配置文件显式管理不同用途的规则文件，而非依赖自动识别的模式目录

### [MiMo Code](https://mimo.xiaomi.com/mimocode)

> 文档: <https://mimo.xiaomi.com/zh/mimocode/rules>

项目规则文件:

- 主要: `AGENTS.md` 或兼容的 `CLAUDE.md` — 作为项目级规则文件
- 配置文件: `mimocode.json` 或全局 `~/.config/mimocode/mimocode.json`

配置说明:

- 可在 JSON 配置文件中指定自定义指令文件路径，复用现有规则
- 全局规则文件 (`~/.config/mimocode/AGENTS.md`) 对所有项目会话生效，实现跨项目指令持久化

### [OpenCode](https://opencode.ai)

> 文档: <https://opencode.ai/docs/rules/>

项目规则文件:

- 主要: 项目根目录的 `AGENTS.md` — 提供自定义指令
- 配置文件: `opencode.json` 或全局 `~/.config/opencode/opencode.json`

配置说明:

- 可在 `opencode.json` 中指定自定义指令文件的路径，复用现有规则而无需复制到
  `AGENTS.md`
- 支持通过 `/init` 命令快速生成或更新 `AGENTS.md` 文件

### [Pi](https://pi.dev)

> 文档: <https://pi.dev/docs/latest/usage>

项目规则文件:

- 主要: `AGENTS.md` — 启动时加载并注入系统提示
- 发现机制: 按全局到项目层级的顺序逐层加载

加载说明:

- 上下文文件用于存放项目约定、常用命令、安全规则与个人偏好
- 支持通过 skills、prompt 模板和 TypeScript 扩展进一步定制

### [Qwen Code](https://github.com/QwenLM/qwen-code)

> 文档: <https://qwenlm.github.io/qwen-code-docs/>

项目规则文件:

- 主要: 项目根目录的 `QWEN.md` — 可通过 `/init` 命令生成
- 子目录: 任意子目录中的 `QWEN.md` — 访问该目录时加载
- 全局: `~/.qwen/QWEN.md`

层级加载顺序:

1. 全局: `~/.qwen/QWEN.md`
2. 项目根: `QWEN.md` — 作为持久项目上下文在每次交互中加载
3. 子目录: 访问时加载子目录中的 `QWEN.md`

### [Replit](https://replit.com)

> 文档: <https://docs.replit.com/features/project-setup/replit-dot-md>

项目规则文件:

- 主要: 项目根目录的 `replit.md` — 定制 Replit Agent 的行为、编码风格和项目上下文

配置说明:

- 用户可手动编辑，Replit Agent 也会自动维护该文件
- 内容超过约 100 行时会被自动压缩精简

### [Trae](https://trae.ai)

> 文档: <https://docs.trae.ai/ide/rules>

项目规则文件:

- 主要: `.trae/rules/*.md` — 存放于项目根目录的隐藏目录下
- 个人规则: 在 IDE 设置中配置，对所有项目全局生效

规则类型 (通过 frontmatter 控制):

| 类型                 | 说明                            |
| -------------------- | ------------------------------- |
| `alwaysApply: true`  | 每次对话都生效                  |
| `scene: git_message` | 仅在生成 Git 提交信息时自动生效 |
| 手动触发             | 在聊天中通过 `@` 提及时生效     |

### [Windsurf](https://windsurf.com)

> 文档: <https://docs.devin.ai/desktop/cascade/memories>

项目规则文件:

- 主要: `.devin/rules/*.md` — 每个 Markdown 文件对应一条规则，通过 frontmatter 控制激活方式
- 兼容: `.windsurf/rules/*.md` — 旧版目录，仍被支持
- 旧版: 工作区根目录的 `.windsurfrules` — 纯 Markdown，始终生效
- 全局规则在设置中配置；根目录的 `AGENTS.md` 同样会被读取

规则类型 (通过 frontmatter 的 `trigger` 控制):

| 类型             | 说明                                   |
| ---------------- | -------------------------------------- |
| `always_on`      | 完整内容随系统提示在每条消息中生效     |
| `model_decision` | 仅显示描述，模型判断相关时读取完整文件 |
| `glob`           | 触碰匹配 `globs` 模式的文件时生效      |
| `manual`         | 仅在聊天中通过 `@rule-name` 提及时生效 |

> 注意：Windsurf 已于 2026 年 6 月更名为 Devin Desktop；现有 `.windsurf/` 路径继续受支持。

### [Zed](https://zed.dev)

> 文档: <https://zed.dev/docs/ai/instructions>

项目规则文件:

- 主要: 项目根目录的 `.rules` — 对 Zed Agent 始终生效的指令
- 自动兼容: 同时识别 `.cursorrules`、`.windsurfrules`、`AGENTS.md` 等文件

优先级系统 (第一个匹配的生效):

1. `.rules`
2. `.cursorrules`
3. `.windsurfrules`
4. `AGENTS.md`
