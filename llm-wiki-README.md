# llm-wiki — Superpowers Skill

A [Superpowers](https://github.com/obra/superpowers) skill for building personal knowledge bases using LLMs.

Based on Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (April 2026) — the idea that the correct way to use LLMs with documents is not retrieval (RAG), but **knowledge compilation** into a persistent, interlinked wiki.

## What it does

Turns your coding agent into a disciplined wiki maintainer. The agent **compiles** raw sources into structured, cross-referenced Markdown pages that compound over time.

```
raw/ (you add)  →  LLM compiles  →  wiki/ (agent maintains)  →  Obsidian (you read)
```

## Installation

### Claude Code (with Superpowers plugin installed)

```bash
# 1. Clone this repo
git clone https://github.com/KaelLim/llm-wiki.git

# 2. Copy the skill into Superpowers plugin directory
cp -r llm-wiki/llm-wiki-skill/skills/llm-wiki ~/.claude/plugins/superpowers/skills/

# 3. Restart Claude Code — the skill is now available
```

Alternatively, install into a specific project:

```bash
cp -r llm-wiki/llm-wiki-skill/skills/llm-wiki /path/to/your/project/.claude/skills/
```

### Manual Setup (any agent)

1. Copy `skills/llm-wiki/SKILL.md` content into your agent's system instructions (CLAUDE.md / AGENTS.md)
2. Run the bootstrap script:

```bash
bash scripts/wiki-bootstrap.sh ~/my-wiki
```

3. Open `~/my-wiki` as an Obsidian vault

## Quick Start

```bash
# 1. Bootstrap
bash scripts/wiki-bootstrap.sh ~/my-wiki
cd ~/my-wiki

# 2. Start Claude Code
claude

# 3. Drop a source and ingest
#    (save an article to raw/articles/my-article.md, then:)
> ingest raw/articles/my-article.md

# 4. Query your wiki
> What do I know about distributed systems?

# 5. Health check
> lint
```

## Commands

| Command | What it does |
|---------|-------------|
| `ingest <path>` | Process raw source into wiki pages |
| `ingest all new files in raw/` | Batch ingest |
| `lint` | Check wiki health (broken links, orphans, contradictions) |
| `enhance wiki/concepts/xxx.md` | Improve a specific page |
| `compile` | Full rebuild from all raw sources (expensive) |
| Any question | Query the wiki first, then answer |

## Recommended Obsidian Plugins

- **Dataview** — Query pages by frontmatter fields
- **Calendar** — Track learning logs
- **Graph View** (built-in) — Visualize knowledge connections

## Architecture

Based on Karpathy's three-layer design:

| Layer | Owner | Purpose |
|-------|-------|---------|
| `raw/` | Human | Immutable source material |
| `wiki/` | LLM | Compiled, interlinked knowledge pages |
| `CLAUDE.md` | Both | Schema governing wiki conventions |

## License

MIT
