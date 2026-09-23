#!/usr/bin/env bash
# Regression tests for the example .gitignore files in examples/.
#
# Spins up a throwaway git repository, materializes every path the README
# talks about, and asserts — via `git check-ignore` — that each example file
# ignores exactly the paths it claims to ignore. Run it after any change to
# examples/ or the README tables:
#
#   bash scripts/test-gitignore.sh
set -euo pipefail
cd "$(dirname "$0")/.." || exit 1
REPO_ROOT=$(pwd)

FULL=examples/agent.gitignore
CONSERVATIVE=examples/agent-conservative.gitignore

# Paths expected to be IGNORED by both example files.
COMMON_IGNORED=".aider.chat.history.md .aider.input.history .aider.llm.history
.aider.tags.cache.v4/v
.augment/settings.local.json
.claude/settings.local.json pkg/.claude/settings.local.json .claude/agent-memory-local/m.md
CLAUDE.local.md sub/CLAUDE.local.md
.codebuddy/settings.local.json CODEBUDDY.local.md
AGENTS.local.md sub/AGENTS.local.md
.devin/config.local.json .devin/mcp_config.local.json
AGENTS.override.md sub/AGENTS.override.md
.crush/logs/crush.log
.goose/memory/m.md
.kimi-code/local.toml
.mimocode/cache/c .mimocode/wiki/w .mimocode/wikis/w .mimo-worktrees/t
.opencode/plans/p.md .opencode/node_modules/n .opencode/package.json .opencode/package-lock.json
.qwen/skills/auto-skill-abc/f .qwen/skills/learned-skill-x/f .qwen/pending-skills/f .qwen-session
.serena/cache/c .serena/project.local.yml
.idx/dev.local.nix"

# Paths expected to be KEPT (committed) by both example files.
COMMON_KEEP="AGENTS.md CLAUDE.md GEMINI.md QWEN.md CODEBUDDY.md IFLOW.md
replit.md kilo.jsonc opencode.json .replit .rules .zcodeignore .geminiignore .cursorignore
.augment-guidelines .augmentignore
.augment/settings.json .augment/rules/r.md
.claude/settings.json .claude/rules/r.md
.kimi-code/mcp.json
.mimocode/mimocode.json
.opencode/agents/a.md
.qoder/rules/r.md .qoder/settings.json .qoder/repowiki/zh/x
.qwen/skills/my-skill/f .qwen/commands/c.toml .qwen/team-memory/tm
.serena/project.yml .serena/memories/m.md
.zed/settings.json .pi/settings.json .windsurf/rules/r.md .trae/rules/r.md .kilo/rules/r.md
.cursor/rules/r.mdc .codex/skills/s/SKILL.md .agents/skills/s/SKILL.md .agents/setup
.devin/wiki.json .devin/rules/r.md .devin/config.json
.gemini/settings.json .mcp.json
.idx/dev.nix .idx/icon.png .idx/mcp.json
.crushrc .crushignore crush.json .goosehints"

# Blanket patterns that only the full version uses.
FULL_IGNORED=".aider.conf.yml .aiderignore
.crush/other .goose/other
.qoder/worktrees/wt
.local/s .local/secondary_skills/s
.zcode/plans/plan-sess_abc.md .zcode/skills/s .zcode/anything"

# The conservative version ignores only precise runtime paths.
CONSERVATIVE_IGNORED=".qoder/settings.local.json
.local/secondary_skills/s
.zcode/plans/plan-sess_abc.md"

# The conservative version deliberately keeps these shareable files.
CONSERVATIVE_KEEP=".aider.conf.yml .aiderignore
.crush/other .goose/other
.qoder/worktrees/wt .local/s
.zcode/skills/s .zcode/anything"

failures=0

run_suite() {
  local label=$1 gitignore=$2 ignored=$3 kept=$4
  local tmp
  tmp=$(mktemp -d)
  (
    cd "$tmp" && git init -q
    for p in $ignored $kept; do mkdir -p "$(dirname "$p")"; touch "$p"; done
    cp "$REPO_ROOT/$gitignore" .gitignore
    for p in $ignored; do
      git check-ignore -q "$p" || { echo "  [$label] FAIL $p should be ignored"; exit 1; }
    done
    for p in $kept; do
      if git check-ignore -q "$p"; then
        echo "  [$label] FAIL $p should be kept"
        exit 1
      fi
    done
  ) || failures=$((failures + 1))
  rm -rf "$tmp"
  echo "  [$label] done"
}

echo "Testing examples/agent.gitignore"
run_suite full "$FULL" "$COMMON_IGNORED $FULL_IGNORED" "$COMMON_KEEP"

echo "Testing examples/agent-conservative.gitignore"
run_suite conservative "$CONSERVATIVE" \
  "$COMMON_IGNORED $CONSERVATIVE_IGNORED" "$COMMON_KEEP $CONSERVATIVE_KEEP"

if [ "$failures" -gt 0 ]; then
  echo "$failures suite(s) failed"
  exit 1
fi
echo "All gitignore expectations met."
