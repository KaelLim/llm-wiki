# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

This repo is the **distribution package** for the `llm-wiki` Superpowers skill — it is not a wiki instance itself. The skill turns a coding agent into a wiki maintainer that compiles raw sources into a persistent, interlinked Markdown wiki (Karpathy's LLM Wiki pattern).

## Repository Structure

- `SKILL.md` — The full skill definition (root copy, identical to the one inside `llm-wiki-skill/`)
- `llm-wiki-README.md` — User-facing README for the skill
- `llm-wiki-superpowers-skill.zip` — Packaged distribution archive
- `llm-wiki-skill/` — The installable skill directory:
  - `skills/llm-wiki/SKILL.md` — Skill definition (installed into Superpowers)
  - `commands/wiki-bootstrap.md` — Command metadata for the bootstrap workflow
  - `scripts/wiki-bootstrap.sh` — Shell script that creates wiki directory structure, index, log, CLAUDE.md schema, and .gitignore
  - `README.md` — Same content as `llm-wiki-README.md`

## Key Commands

```bash
# Bootstrap a new wiki instance at a target directory
bash llm-wiki-skill/scripts/wiki-bootstrap.sh ~/my-wiki

# Install skill into Superpowers (plugin marketplace version)
cp -r llm-wiki-skill/skills/llm-wiki ~/.claude/plugins/superpowers/skills/

# Install skill into a project's local skills
cp -r llm-wiki-skill/skills/llm-wiki /path/to/project/.claude/skills/
```

## Architecture (Three-Layer Wiki Pattern)

When the skill is used in a wiki instance, it enforces this structure:

| Layer | Owner | Purpose |
|-------|-------|---------|
| `raw/` | Human | Immutable source material (articles, papers, notes, images) |
| `wiki/` | LLM | Compiled knowledge pages (concepts, entities, guides, comparisons, learning) |
| `CLAUDE.md` | Both | Schema governing wiki conventions |

The skill defines five workflows: **INGEST** (process raw sources), **QUERY** (answer from wiki), **LINT** (health check), **ENHANCE** (improve a page), **COMPILE** (full rebuild). All are detailed in `SKILL.md`.

## Conventions

- Wiki pages require YAML frontmatter (title, type, created, updated, sources, tags, confidence)
- Cross-references use `[[wiki-links]]` for Obsidian compatibility
- The bootstrap script defaults content language to Traditional Chinese (繁體中文), English for technical terms
- Raw sources are strictly immutable — the skill must never modify `raw/`
