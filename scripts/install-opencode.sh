#!/usr/bin/env bash
# Install radstack into OpenCode: skills, agents, and slash commands.
# Re-run after a git pull; symlinked skills update in place.
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
oc="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

mkdir -p "$oc/skills" "$oc/agents" "$oc/commands"

for dir in "$root"/skills/*/; do
  ln -sfn "${dir%/}" "$oc/skills/$(basename "$dir")"
done

# Cursor-only frontmatter (`is_background`, `icon`, ...) is not OpenCode
# metadata, so rewrite the header and keep the body as the system prompt.
agent() { # $1 = source file, $2 = agent id
  {
    printf -- '---\nname: %s\n' "$2"
    sed -n '/^description:/p' "$1"
    printf 'mode: subagent\n---\n\n'
    awk '{ if ($0 == "---" && n < 2) { n++; next } if (n >= 2) print }' "$1"
  } > "$oc/agents/$2.md"
}

agent "$root/agents/radstack-agent.md" radstack-agent
agent "$root/agents/comment-sicko.md" comment-sicko

cmd() { # $1 = name, $2 = description
  cat > "$oc/commands/$1.md" <<EOF
---
description: $2
---
Load the \`$1\` skill with the skill tool, then do this task in that style. Follow its playbook, and keep its todo list updated.

\$ARGUMENTS
EOF
}

cmd radstack-mode "Run a task in radstack mode: rigorous, verified, unslopped"
cmd setup-radstack "Configure which models radstack uses per role"
cmd radstack-help "Find the radstack skill or guide page for a question"

echo "installed radstack into $oc"
echo "  skills:   $(ls "$root/skills" | wc -l) symlinked"
echo "  agents:   radstack-agent, comment-sicko"
echo "  commands: /radstack-mode, /setup-radstack, /radstack-help"
