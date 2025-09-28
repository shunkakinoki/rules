# /commit-lint — Chainset Entry Generation for AI Agents

This document outlines the chainset entry generation guidelines that AI agents must follow when creating release documentation entries.

## Overview

The chainset system ensures consistent release documentation by automatically generating single-file chainset entries that describe changes using Changesets semantics. This approach provides structured, human-readable release notes while maintaining compatibility with conventional commit standards.

## Chainset Entry Generation

### LLM Prompt: "Create a Chainset Entry"

Use this reusable LLM prompt to generate chainset entries that reliably produce structured release documentation:

#### Role
You are a release notes assistant that writes **one chainset file** describing the current change. A **chainset** uses the *Changesets* front-matter semantics (quoted package name keys, value in `{major|minor|patch}`), followed by a short, human-readable description.

#### Inputs (provided by tools/context)
* `last_commit_message`: the full latest commit message.
* `diff_summary`: shortstat of the current branch vs base (files changed/insertions/deletions).
* `changed_paths`: list of files changed.
* `branch`: current branch name.
* `base_ref`: base branch or remote ref (e.g., `origin/main`).
* *(Optional)* `explicit_packages`: if provided, restrict to these package names.
* *(Optional)* `explicit_levels`: map of package → level overriding inference.

#### Rules

1. **Front matter (required):**
   * Start with a YAML block delimited by `---` on its own line above and below.
   * Each **key** is a **quoted package name** (e.g., `"viem"`).
   * Each **value** is one of: `major`, `minor`, `patch` (lowercase).
   * Include **only packages that actually changed**. If monorepo paths like `packages/<name>/…` exist, use `<name>`. If no package can be inferred, use `"repo"`.

2. **Level inference (unless explicitly provided):**
   * `major` if the latest commit indicates breaking change: `!` in type/scope or `BREAKING CHANGE`.
   * `minor` if the latest commit is a `feat:` (any scope).
   * `patch` otherwise (e.g., `fix:`, `chore:`, `docs:`, `refactor:`, etc.).
   * If multiple packages changed with mixed signals, prefer the **highest** applicable level per package.

3. **Description (required):**
   * One to two sentences max.
   * Lead with the user-visible outcome (what was added/changed/fixed).
   * Mention relevant scope (API/function/command/chain/network) if obvious from context.
   * Avoid commit jargon; no issue numbers unless essential.
   * Do not restate diff stats.
   * Keep it tense-consistent and crisp.

4. **Output format (strict):**
   * Output **only** the chainset content:
     ```
     ---
     "pkg-a": minor
     "pkg-b": patch
     ---
     Short description sentence…
     ```
   * No extra commentary, code fences, or explanations.

#### Heuristics for inferring packages
* If a path matches `packages/<name>/…`, map to `"name"`.
* Otherwise, fall back to `"repo"`.
* If `explicit_packages` is provided, intersect with inferred packages.

#### Safety checks
* If no changes are detectable from inputs, create a `"repo": patch` entry with a description summarizing the intent from `last_commit_message`'s first line.
* If `explicit_levels` conflicts with inference, **use explicit**.

### Integration with Commit Process

When AI agents make commits, they should:

1. **Generate chainset entries** using the LLM prompt above
2. **Include chainset files** in the same commit as the code changes
3. **Follow conventional commit format** for commit messages
4. **Maintain solo authorship** in commits (no co-authorship)

### Package Detection Guidelines

AI agents should automatically detect project structure and adapt chainset generation:

- **Monorepo projects**: Map file paths to package names using `packages/<name>/` patterns
- **Single package projects**: Use `"repo"` as the default package name
- **Multi-package changes**: Include all affected packages in the front matter

### Chainset File Naming

Chainset entries should be created with descriptive filenames that reference the change:

```
chainset/
├── feat-add-user-auth.md
├── fix-login-validation.md
└── docs-update-api-ref.md
```

## Quality Standards

### Chainset Content Standards
- **Focus on user impact**: Describe what users can do differently, not implementation details
- **Keep descriptions concise**: 1-2 sentences maximum
- **Use active voice**: "Adds support for..." not "Support for... was added"
- **Be specific**: Include relevant scope (API, UI, performance, etc.) when applicable

### Commit Message Standards
- Use conventional commit format: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- Keep messages under 72 characters
- Include descriptive details for complex changes
- Reference related issues when applicable

## Best Practices

### For AI Agents
- **Generate chainset entries** for every feature commit
- **Use the provided LLM prompt** for consistent formatting
- **Focus on user-visible changes** in descriptions
- **Include all affected packages** in monorepo scenarios
- **Test chainset generation** with various commit types

### Integration with Release Process
- Chainset entries accumulate in the `chainset/` directory
- Each entry represents one logical change
- Release process can aggregate entries for changelog generation
- Entries should be committed alongside their related code changes

### Examples

#### Feature Addition
```markdown
---
"viem": patch
---

Added estimateOperatorFee action for OP Stack chains
```

#### Package-Specific Change
```markdown
---
"wallets": minor
---

Added Ledger WebHID transport for hardware wallet connections
```

#### Breaking Change
```markdown
---
"core": major
---

Replaced legacy serializer with a new wire format incompatible with previous releases
```

This chainset approach ensures that all AI agent contributions include proper release documentation that follows consistent formatting and focuses on user-visible impact rather than implementation details.

