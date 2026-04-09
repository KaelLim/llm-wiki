# llm-wiki

A Claude Code plugin for building personal knowledge bases using LLMs.

Based on Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (April 2026) — the idea that the correct way to use LLMs with documents is not retrieval (RAG), but **knowledge compilation** into a persistent, interlinked wiki.

```
raw/ (you add)  →  LLM compiles  →  wiki/ (agent maintains)  →  Obsidian (you read)
```

## Installation

### Claude Code (Plugin Marketplace)

```bash
# 1. Add the marketplace
/plugin marketplace add KaelLim/llm-wiki

# 2. Install the plugin
/plugin install llm-wiki@llm-wiki
```

### Manual Setup (any LLM agent)

Copy `skills/llm-wiki/SKILL.md` content into your agent's system instructions (CLAUDE.md / AGENTS.md).

## Quick Start

```bash
# 1. Bootstrap a new wiki
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
| `evolve schema` | Suggest improvements to CLAUDE.md conventions |
| Any question | Query the wiki first, then answer |

## Architecture

Based on Karpathy's three-layer design:

| Layer | Owner | Purpose |
|-------|-------|---------|
| `raw/` | Human | Immutable source material |
| `wiki/` | LLM | Compiled, interlinked knowledge pages |
| `CLAUDE.md` | Both | Schema governing wiki conventions |

## Recommended Obsidian Plugins

- **Dataview** — Query pages by frontmatter fields
- **Calendar** — Track learning logs
- **Graph View** (built-in) — Visualize knowledge connections

## License

MIT
