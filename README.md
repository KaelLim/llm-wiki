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
# 1. Bootstrap a new wiki (creates directories + sets global config)
bash scripts/wiki-bootstrap.sh ~/my-wiki

# 2. Open the wiki directory and start Claude Code
cd ~/my-wiki
claude

# 3. Drop a source and ingest
#    (save an article to raw/articles/my-article.md, then:)
> ingest raw/articles/my-article.md

# 4. Query your wiki
> What do I know about distributed systems?

# 5. Health check
> lint
```

## Multi-Project Setup

The wiki is a **single, central knowledge base** — not one per project. The bootstrap script automatically saves the wiki path to `~/.config/llm-wiki/root`, so the agent knows where to find it from any project.

To explicitly point a project to the wiki, add this to the project's `CLAUDE.md`:

```
wiki-root: /absolute/path/to/my-wiki
```

The agent will never create `raw/` or `wiki/` inside a code project directory.

## Usage

The skill triggers automatically via natural language. Just tell the agent what you want:

```
> ingest raw/articles/my-article.md     ← processes source into wiki pages
> lint                                   ← checks wiki health
> What is event-driven architecture?     ← queries wiki, cites pages
```

All six workflows (ingest, query, lint, enhance, compile, evolve-schema) are documented in `skills/llm-wiki/SKILL.md`.

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
