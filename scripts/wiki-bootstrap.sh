#!/usr/bin/env bash
# llm-wiki bootstrap — creates the wiki directory structure
# Usage: bash scripts/wiki-bootstrap.sh [target_dir]

set -euo pipefail

TARGET="${1:-.}"

echo "🔧 Bootstrapping LLM Wiki in: $TARGET"

# Create directory structure
mkdir -p "$TARGET/raw"/{articles,papers,repos,notes,images,projects}
mkdir -p "$TARGET/wiki"/{concepts,entities,guides,comparisons,learning}

# Create index.md if it doesn't exist
if [ ! -f "$TARGET/wiki/index.md" ]; then
  cat > "$TARGET/wiki/index.md" << 'EOF'
---
title: Knowledge Base Index
updated: REPLACE_DATE
---

# Knowledge Base Index

## Software Development
(No pages yet)

## Personal Learning
(No pages yet)

---
*This index is maintained by the LLM. Do not edit manually.*
EOF
  sed -i "s/REPLACE_DATE/$(date +%Y-%m-%d)/" "$TARGET/wiki/index.md"
  echo "  ✅ Created wiki/index.md"
fi

# Create log.md if it doesn't exist
if [ ! -f "$TARGET/wiki/log.md" ]; then
  cat > "$TARGET/wiki/log.md" << EOF
---
title: Operation Log
---

# Wiki Operation Log

## [$(date +%Y-%m-%d)] bootstrap | Wiki initialized
EOF
  echo "  ✅ Created wiki/log.md"
fi

# Create CLAUDE.md if it doesn't exist
if [ ! -f "$TARGET/CLAUDE.md" ]; then
  cat > "$TARGET/CLAUDE.md" << 'SCHEMA'
# LLM Wiki Schema

## Project Overview
This is a personal knowledge base using the LLM Wiki pattern.
The agent compiles raw sources into structured wiki pages.

## Conventions
- Language: Traditional Chinese (繁體中文) for content, English for technical terms
- All wiki pages use YAML frontmatter
- Use [[wiki-links]] for cross-references (Obsidian-compatible)
- Every claim cites a raw/ source
- Raw sources are immutable — never modify files in raw/

## Workflows
See the llm-wiki skill for ingest, query, lint, enhance, and compile workflows.

## Custom Rules
(Add your project-specific rules here as the wiki evolves)
SCHEMA
  echo "  ✅ Created CLAUDE.md"
fi

# Create .gitignore if it doesn't exist
if [ ! -f "$TARGET/.gitignore" ]; then
  cat > "$TARGET/.gitignore" << 'EOF'
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.trash/
node_modules/
EOF
  echo "  ✅ Created .gitignore"
fi

# Set global wiki root config
WIKI_ROOT="$(cd "$TARGET" && pwd)"
mkdir -p ~/.config/llm-wiki
echo "$WIKI_ROOT" > ~/.config/llm-wiki/root
echo "  ✅ Set global wiki root: $WIKI_ROOT"

echo ""
echo "🎉 LLM Wiki bootstrapped successfully!"
echo ""
echo "Wiki root saved to: ~/.config/llm-wiki/root"
echo "All projects will use this as the central knowledge base."
echo ""
echo "Next steps:"
echo "  1. Open '$TARGET' as an Obsidian vault"
echo "  2. Drop your first source into raw/articles/"
echo "  3. Tell Claude Code: ingest raw/articles/<filename>"
echo ""
echo "Optional: Add 'wiki-root: $WIKI_ROOT' to each project's CLAUDE.md"
echo ""
