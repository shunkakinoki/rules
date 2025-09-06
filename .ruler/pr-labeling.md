# GitHub PR Labeling Rules

This rule defines how PR labels are applied automatically. It uses the default labels defined in `labels.ts` and maps Conventional Commit types to GitHub labels.

## Default Labels (source of truth)

Names come from `labels.ts`:

- bug
- documentation
- duplicate
- enhancement
- good first issue
- help wanted
- invalid
- question
- wontfix
- dependabot
- renovate
- dependencies
- automerge

## Label Mapping Rules

- feat → enhancement
- fix → bug
- docs → documentation
- chore(deps), build(deps) → dependencies
- PR authored by dependabot → dependabot
- PR authored by renovate → renovate
- If title contains "[automerge]" or label "automerge" is requested in the description, also add automerge

Notes:
- Only apply one of enhancement/bug/documentation based on the primary Conventional Commit type at the start of the PR title.
- Do not add unrelated labels automatically.

## gh CLI Automation Snippet

Use this non-interactive script to apply labels on current PR. It:
- Detects PR title, author, and branch
- Maps commit type to label
- Adds dependency labels if applicable
- Adds bot-specific labels

```bash
# Requires: gh, jq
set -euo pipefail

# Fetch current PR metadata
TITLE=$(gh pr view --json title --jq .title)
AUTHOR=$(gh pr view --json author --jq .author.login)
BRANCH=$(gh pr view --json headRefName --jq .headRefName)
NUMBER=$(gh pr view --json number --jq .number)

labels=()

# Map Conventional Commit type → label
# Expected title formats: "feat: ...", "fix(scope): ...", etc.
TYPE=$(printf '%s' "$TITLE" | sed -E 's/^([a-zA-Z!]+)(\(.+\))?:.*/\1/' | tr 'A-Z' 'a-z' | sed 's/!$//')
case "$TYPE" in
  feat) labels+=("enhancement") ;;
  fix) labels+=("bug") ;;
  docs) labels+=("documentation") ;;
  # Optional: add more mappings if desired
esac

# Dependencies-related labels
if printf '%s' "$TITLE" | grep -qiE '^chore\(deps\)|^build\(deps\)|\bdeps\b|\bdependency\b'; then
  labels+=("dependencies")
fi

# Bot-specific labels
if printf '%s' "$AUTHOR" | grep -qi '^dependabot'; then
  labels+=("dependabot")
fi
if printf '%s' "$AUTHOR" | grep -qi '^renovate'; then
  labels+=("renovate")
fi

# Auto-merge request detection
if printf '%s' "$TITLE" | grep -qi '\[automerge\]'; then
  labels+=("automerge")
fi
if gh pr view --json body --jq .body | grep -qiE '^labels?:.*automerge' ; then
  labels+=("automerge")
fi

# De-duplicate labels
unique_labels=$(printf '%s\n' "${labels[@]:-}" | awk 'NF' | awk '!seen[$0]++' | paste -sd, -)

if [ -n "$unique_labels" ]; then
  echo "Adding labels to PR #$NUMBER: $unique_labels"
  gh pr edit "$NUMBER" --add-label "$unique_labels"
else
  echo "No labels to add for PR #$NUMBER"
fi
```

### Fish CLI Automation Snippet

The same logic implemented for Fish shell.

```fish
#!/usr/bin/env fish
# Requires: gh, jq

# Fetch current PR metadata
set TITLE (gh pr view --json title --jq .title)
set AUTHOR (gh pr view --json author --jq .author.login)
set BRANCH (gh pr view --json headRefName --jq .headRefName)
set NUMBER (gh pr view --json number --jq .number)

set labels

# Map Conventional Commit type → label
set TYPE (printf '%s' "$TITLE" | sed -E 's/^([a-zA-Z!]+)(\(.+\))?:.*/\1/' | tr 'A-Z' 'a-z' | sed 's/!$//')
switch "$TYPE"
case feat
  set labels $labels enhancement
case fix
  set labels $labels bug
case docs
  set labels $labels documentation
end

# Dependencies-related labels
if printf '%s' "$TITLE" | grep -qiE '^chore\(deps\)|^build\(deps\)|\bdeps\b|\bdependency\b'
  set labels $labels dependencies
end

# Bot-specific labels
if printf '%s' "$AUTHOR" | grep -qi '^dependabot'
  set labels $labels dependabot
end
if printf '%s' "$AUTHOR" | grep -qi '^renovate'
  set labels $labels renovate
end

# Auto-merge request detection
if printf '%s' "$TITLE" | grep -qi '\[automerge\]'
  set labels $labels automerge
end
if gh pr view --json body --jq .body | grep -qiE '^labels?:.*automerge'
  set labels $labels automerge
end

# De-duplicate labels
set unique_labels (printf '%s\n' $labels | awk 'NF' | awk '!seen[$0]++' | paste -sd, -)

if test -n "$unique_labels"
  echo "Adding labels to PR #$NUMBER: $unique_labels"
  gh pr edit "$NUMBER" --add-label "$unique_labels"
else
  echo "No labels to add for PR #$NUMBER"
end
```

## Usage

- Run the snippet after creating the PR, or integrate it into your local automation.
- Ensure the label names exist in the repository (they are provisioned via Pulumi from `labels.ts`).

## Maintenance

- If you change labels in `labels.ts`, update the list above and (optionally) extend the mapping.
- Keep mappings minimal to avoid mislabeling; prefer explicit over implicit where uncertain.
