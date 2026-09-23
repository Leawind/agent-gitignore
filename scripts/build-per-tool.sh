#!/usr/bin/env bash
# Generate examples/per-tool/*.gitignore from examples/agent.gitignore.
#
# The combined file is the single source of truth: sections are delimited by
# `# ---- <Tool> ----` headers and extracted verbatim into one file per tool.
# Never hand-edit files under examples/per-tool/ — edit the combined file and
# re-run this script. CI regenerates and fails on any drift.
set -euo pipefail
cd "$(dirname "$0")/.."

src=examples/agent.gitignore
outdir=examples/per-tool
mkdir -p "$outdir"
rm -f "$outdir"/*.gitignore

awk -v out="$outdir" '
  /^# ---- .+----$/ {
    name = $0
    sub(/^# ---- /, "", name)
    sub(/-+$/, "", name)
    sub(/ +$/, "", name)
    slug = name
    sub(/ \(.*/, "", slug)
    slug = tolower(slug)
    gsub(/[^a-z0-9]+/, "-", slug)
    gsub(/^-+|-+$/, "", slug)
    file = out "/" slug ".gitignore"
    printing = (slug != "case-by-case")
    if (printing) {
      print "# " name " — generated from examples/agent.gitignore" > file
      print "# Do not edit: change the combined file and run scripts/build-per-tool.sh" > file
      started = 0
    }
    next
  }
  printing {
    if (!started) {
      if ($0 ~ /^[[:space:]]*$/) next
      started = 1
    }
    print > file
  }
' "$src"

echo "Generated $(ls "$outdir"/*.gitignore | wc -l) per-tool files in $outdir/"
