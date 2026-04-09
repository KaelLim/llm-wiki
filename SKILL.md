---
name: llm-wiki
description: >-
  Use when the user wants to build, maintain, or query a personal knowledge base
  using the LLM Wiki pattern (raw sources → compiled wiki → schema). Triggers on
  keywords: ingest, wiki, knowledge base, lint wiki, enhance page, compile knowledge,
  raw sources, wiki index. Also triggers when the user drops new files into raw/ and
  wants them processed, or asks questions that should be answered from the wiki.
---

# LLM Wiki — Knowledge Compilation Skill

> Based on Andrej Karpathy's LLM Wiki pattern (April 2026).
> The correct way to use LLMs is not Q&A — it's **compilation**.

## Overview

This skill turns a coding agent into a disciplined wiki maintainer. Instead of
rediscovering knowledge from scratch on every question (RAG), the agent
**compiles** raw sources into a persistent, interlinked Markdown wiki that
compounds over time.

The agent owns the wiki layer. The human owns the raw sources and the schema.
The human reads; the agent writes.

## Three-Layer Architecture

```
raw/            ← Human-owned. Immutable source material.
  articles/       Web articles, blog posts (via Obsidian Web Clipper)
  papers/         Papers, whitepapers, PDFs
  repos/          README excerpts, code notes
  notes/          Freeform notes, thoughts
  images/         Screenshots, diagrams

wiki/           ← Agent-owned. Compiled knowledge.
  concepts/       Concept pages (e.g., REST API, TDD, spaced repetition)
  entities/       Entity pages (e.g., React, Rust, a specific book)
  guides/         How-to guides (e.g., Docker deployment, Git branching)
  comparisons/    Side-by-side comparisons (e.g., PostgreSQL vs MySQL)
  learning/       Learning logs, reading notes
  index.md        Master index (agent-maintained)
  log.md          Append-only operation log

CLAUDE.md       ← Co-owned. Schema that governs wiki conventions.
```

## Page Template

Every wiki page MUST have YAML frontmatter:

```yaml
---
title: Page Title
type: concept | entity | guide | comparison | learning
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources:
  - raw/articles/2026-04-09-source.md
tags:
  - tag1
  - tag2
confidence: high | medium | low
---
```

Body conventions:
- Use `[[wiki-links]]` for all cross-references (Obsidian-compatible)
- Every factual claim cites a `raw/` source
- Code examples use fenced code blocks with language tags
- Contradictions between sources are explicitly noted

## Workflows

### INGEST — Processing new raw sources

Announce: "Using llm-wiki skill to ingest new sources."

Trigger: User says "ingest", drops files in raw/, or says "process new sources."

**Checklist:**

- [ ] Read the source file(s) in raw/
- [ ] Identify key concepts, entities, and facts
- [ ] **Discuss with user:** Present key takeaways as a numbered list. Ask what to emphasize, what to skip, and whether anything was surprising. Wait for user input before proceeding.
- [ ] For each concept/entity, check if a wiki page already exists
- [ ] **If page exists:** Update it with new information, add source to frontmatter, note any contradictions with existing content, update the `updated` date
- [ ] **If page doesn't exist:** Create new page using the page template, place in correct subdirectory
- [ ] Add `[[wiki-links]]` to connect new/updated pages to related existing pages
- [ ] Update `wiki/index.md` with any new pages
- [ ] Append operation summary to `wiki/log.md` using format: `## [YYYY-MM-DD] ingest | <source title>`
- [ ] Report: pages created, pages updated, contradictions found, suggested follow-ups

**Red flags — DO NOT:**
- Modify anything in `raw/` — sources are immutable
- Create pages without citing raw sources
- Skip updating cross-references
- Forget to update `wiki/index.md`
- Skip the discussion step — ingest is collaborative, not fully automated

### QUERY — Answering questions from the wiki

Announce: "Using llm-wiki skill to query the knowledge base."

Trigger: User asks a question that the wiki should be able to answer.

**Checklist:**

- [ ] Read `wiki/index.md` to locate relevant pages
- [ ] Read relevant wiki pages
- [ ] Synthesize answer from wiki content
- [ ] Cite specific wiki pages in the answer: "According to [[page-name]]..."
- [ ] If wiki lacks sufficient information, say so explicitly and suggest what raw sources to add
- [ ] If the question reveals a gap, suggest creating a new wiki page
- [ ] If the answer is substantial (comparison, analysis, synthesis), ask the user: "This answer could be a wiki page — want me to save it?" If yes, create a page in the appropriate subdirectory and update index

**Red flags — DO NOT:**
- Answer from general knowledge when wiki content exists — use the wiki
- Hallucinate information not in the wiki without clearly marking it as external knowledge
- Skip citing sources
- Let valuable synthesis disappear into chat history — propose saving it to wiki

### LINT — Wiki health check

Announce: "Using llm-wiki skill to run wiki health check."

Trigger: User says "lint", "health check", or "audit wiki."

**Checklist:**

- [ ] Scan all wiki pages for broken `[[wiki-links]]`
- [ ] Identify orphan pages (no incoming links)
- [ ] Identify referenced-but-missing pages (linked but don't exist)
- [ ] Check for contradictions between pages
- [ ] Flag pages with stale sources or low confidence
- [ ] Check frontmatter completeness (missing fields)
- [ ] Verify `wiki/index.md` is complete and accurate
- [ ] Report findings sorted by severity: critical → warning → suggestion
- [ ] Append lint results to `wiki/log.md` using format: `## [YYYY-MM-DD] lint | <summary>`

### ENHANCE — Improve a specific page

Announce: "Using llm-wiki skill to enhance a wiki page."

Trigger: User says "enhance", "improve", "expand" a specific page.

**Checklist:**

- [ ] Read the target page and all its linked pages
- [ ] Read all raw sources cited by the page
- [ ] Identify gaps: missing context, incomplete explanations, absent examples
- [ ] Add content to fill gaps, citing sources
- [ ] Improve cross-references to related pages
- [ ] Suggest new pages that should exist based on referenced concepts
- [ ] Update frontmatter dates

### COMPILE — Full rebuild from raw sources

Announce: "Using llm-wiki skill to compile wiki from scratch."

Trigger: User says "compile", "rebuild", or "full recompile."

**WARNING:** This is expensive (many tokens). Confirm with user before proceeding.

**Checklist:**

- [ ] Inventory all files in `raw/` recursively
- [ ] Process each source, creating/updating wiki pages (same as INGEST per file)
- [ ] After all sources processed, run LINT
- [ ] Rebuild `wiki/index.md` from scratch
- [ ] Append to `wiki/log.md` using format: `## [YYYY-MM-DD] compile | full rebuild from <N> sources`
- [ ] Report full summary: total pages, total sources processed, issues found

### EVOLVE-SCHEMA — Suggest schema improvements

Announce: "Using llm-wiki skill to suggest schema improvements."

Trigger: After every 5 ingest operations, or when the LLM notices recurring patterns
that the current schema doesn't capture well, or user says "evolve schema."

**Checklist:**

- [ ] Review `wiki/log.md` for recent operations and any recurring friction
- [ ] Read current `CLAUDE.md` schema
- [ ] Identify gaps: new page types needed, missing frontmatter fields, workflow steps that don't fit, naming conventions that emerged organically
- [ ] Present specific proposals to the user (not vague suggestions):
  - "Add `status: active | archived` to frontmatter because X pages are outdated"
  - "Create a new `wiki/patterns/` subdirectory because Y guides are actually design patterns"
  - "Add a `related-projects` frontmatter field because cross-project references keep appearing"
- [ ] Only apply changes the user approves
- [ ] Append schema change to `wiki/log.md`

**Red flags — DO NOT:**
- Modify CLAUDE.md without user approval — schema is co-owned
- Propose changes that are purely cosmetic
- Over-engineer the schema — only add what's proven necessary

## Bootstrap — First-Time Setup

When the wiki directory structure doesn't exist yet:

```bash
# Run from project root
mkdir -p raw/{articles,papers,repos,notes,images}
mkdir -p wiki/{concepts,entities,guides,comparisons,learning}
touch wiki/index.md wiki/log.md
```

Then create initial `wiki/index.md`:

```markdown
---
title: Knowledge Base Index
updated: YYYY-MM-DD
---

# Knowledge Base Index

## Software Development
(No pages yet)

## Personal Learning
(No pages yet)

---
*This index is maintained by the LLM. Do not edit manually.*
```

## Multi-Project Usage

The wiki is a **single, central knowledge base** — not one per project. Knowledge
compounds across domains: a concept from Project A may connect to insights from
Project B. Splitting into separate wikis loses this cross-pollination.

Recommended `raw/` structure for multiple projects:

```
raw/
  articles/           General articles, blog posts
  papers/             Papers, whitepapers
  notes/              Freeform notes
  images/             Screenshots, diagrams
  projects/           Per-project sources
    project-a/
    project-b/
```

The `wiki/` layer remains flat — pages are organized by knowledge type, not by
project. Use frontmatter `tags` (e.g. `tags: [project-a]`) to track provenance.
Obsidian Dataview can filter by tag.

## Scaling

At small scale (~50 pages), `wiki/index.md` is sufficient for the LLM to navigate.

As the wiki grows:
- **~100+ pages:** Consider adding a search tool. [qmd](https://github.com/tobi/qmd) provides hybrid BM25/vector search with an MCP server the LLM can use as a native tool.
- **~500+ pages:** The index file becomes unwieldy. Split into per-category indexes (e.g. `wiki/concepts/_index.md`) and keep the master index as a high-level overview.
- **Any scale:** `grep` over `wiki/log.md` using the `## [date] operation | description` format gives fast chronological navigation.

## Integration with Obsidian

The wiki is designed to be opened as an Obsidian vault:

- `[[wiki-links]]` render as clickable links
- Graph View shows the knowledge graph
- Tags in frontmatter are searchable
- Obsidian Web Clipper deposits directly into `raw/articles/`

The agent never needs to interact with Obsidian directly. Obsidian is the
human's reading interface; the agent works with files on disk.

## Integration with Git

Recommended: version control the entire wiki.

```bash
git init
echo "node_modules/" > .gitignore
git add -A && git commit -m "wiki: initial setup"
```

After each significant ingest or compile, commit:

```bash
git add -A && git commit -m "wiki: ingest <source-description>"
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Editing files in `raw/` | Raw sources are immutable. Create a new file instead. |
| Creating wiki pages without frontmatter | Every page needs YAML frontmatter. Use the template. |
| Forgetting cross-references | Every page should link to at least 2 related pages. |
| Not updating index.md | Index must reflect every page in the wiki. |
| Answering from general knowledge | Always check wiki first. Mark external knowledge explicitly. |
| Giant monolithic pages | Split into focused concept/entity pages. One topic per page. |
| Skipping the log | Always append to `wiki/log.md` after operations. |
