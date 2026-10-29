# radstack in OpenCode

[`scripts/install-opencode.sh`](../../scripts/install-opencode.sh) installs radstack for OpenCode V2:

```bash
git clone https://github.com/radityama/stack.git
./stack/scripts/install-opencode.sh
```

It symlinks every skill into `~/.config/opencode/skills/`, converts the two agents into `~/.config/opencode/agents/`, and writes the `/radstack-mode`, `/setup-radstack`, and `/radstack-help` commands. Re-run it after `git pull`; the skill symlinks update in place.

## What maps

| Cursor | OpenCode |
| --- | --- |
| `skills/<name>/SKILL.md` | `~/.config/opencode/skills/<name>/SKILL.md`. The skill ID is the directory name |
| `disable-model-invocation: true` | Honored as `opencode/autoinvoke: false`: hidden from the model's list, still loadable by ID |
| `/radstack-mode` | The command loads the `radstack-mode` skill with the `skill` tool, then runs your task |
| `subagent_type: radstack-agent` | The `subagent` tool with agent `radstack-agent` |
| `Task` | `subagent` (pass `background: true` for a background child) |
| `AskQuestion` | The `question` tool |
| Model per role | `agents.<id>.model` in `opencode.json`, or a command's `model` |

## Differences to keep in mind

- `/setup-radstack` writes `~/.cursor/rules/radstack-models.mdc`. On OpenCode, write the same role mapping as `agents.<id>.model` in `opencode.json`, or as a block in `~/.config/opencode/AGENTS.md`. The detection and budget steps still work.
- Skill IDs are global. radstack defines 58 common ones (`tdd`, `how`, `why`, `architect`, `arena`, ...), so installing into `~/.config/opencode/skills` shadows any skill with the same ID from `.claude/skills`, `.agents/skills`, or the built-ins. Rename a symlink if that clashes with your own skills.
- The skill prose still says `Task` and `AskQuestion`. Read those as `subagent` and `question` when you follow a skill.
