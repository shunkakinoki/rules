# /changesets — Automatic changeset management and generation

This command provides intelligent changeset detection and generation for repositories using the Changesets package. It automatically analyzes current changes (git diff, staged files, or PR context) and generates appropriate changeset entries following conventional commit standards.

## Overview

The changeset system intelligently:
- **Detects changesets setup**: Checks for `.changeset/` directory, `@changesets/cli` dependencies, and configuration files
- **Analyzes current context**: Examines git diff, staged files, or GitHub PR content to determine change types
- **Generates changeset entries**: Creates properly formatted changeset files with conventional commit types
- **Maintains consistency**: Ensures changeset messages align with conventional commit standards
- **Supports multiple workflows**: Works with git-based changes, PR-based changes, or manual entry

## Changesets Detection

The command automatically detects changesets usage through multiple indicators:

```bash
# Check for changesets directory
if [ -d ".changeset" ]; then
  CHANGESETS_ENABLED=true
fi

# Check for changesets CLI in dependencies
if grep -q "@changesets/cli" package.json 2>/dev/null; then
  CHANGESETS_ENABLED=true
fi

# Check for changesets configuration
if [ -f ".changeset/config.json" ]; then
  CHANGESETS_ENABLED=true
fi
```

### Detection Logic (Fish Shell)

```fish
# Check for changesets setup
set CHANGESETS_ENABLED false

if test -d .changeset
  set CHANGESETS_ENABLED true
end

if grep -q "@changesets/cli" package.json >/dev/null 2>&1
  set CHANGESETS_ENABLED true
end

if test -f .changeset/config.json
  set CHANGESETS_ENABLED true
end
```

## Prerequisites

### Changesets Installation
If changesets is not detected, install it first:

```bash
# Using npm
npm install --save-dev @changesets/cli @changesets/changelog-github

# Using yarn
yarn add -D @changesets/cli @changesets/changelog-github

# Using pnpm
pnpm add -D @changesets/cli @changesets/changelog-github

# Using bun
bun add -D @changesets/cli @changesets/changelog-github
```

### Configuration Setup
Initialize changesets if not already configured:

```bash
# Initialize changesets (creates .changeset/config.json)
npx @changesets/cli init

# Or with bun
bunx @changesets/cli init
```

### Required Dependencies
- `@changesets/cli` - Core changesets functionality
- `@changesets/changelog-github` - GitHub changelog integration
- Git repository with proper commit history

## Workflow

### 1. Context Analysis
The command analyzes the current context to determine changeset requirements:

```bash
# Analyze current git status
git status --porcelain

# Check for staged changes
git diff --cached --name-only

# Get recent commit messages for context
git log --oneline -5
```

### 2. Change Type Detection
Automatically determines the appropriate changeset type:

```fish
# Function to detect changeset type from changes
function detect_changeset_type
    set staged_files (git diff --cached --name-only)

    # Check for breaking changes (major version bump indicators)
    if string match -q "*BREAKING CHANGE*" (git log --oneline -1)
        echo "major"
        return
    end

    # Check for new features
    if string match -q "feat:*" (git log --oneline -1)
        echo "minor"
        return
    end

    # Check for bug fixes
    if string match -q "fix:*" (git log --oneline -1)
        echo "patch"
        return
    end

    # Default to patch for other changes
    echo "patch"
end
```

### 3. Changeset Generation
Creates changeset entries based on detected changes:

#### Interactive Generation (for manual use)
```bash
# Generate changeset with automatic type detection (interactive)
npx @changesets/cli add

# Or with specific bump type (interactive)
npx @changesets/cli add --type major
npx @changesets/cli add --type minor
npx @changesets/cli add --type patch
```

#### Non-Interactive Generation (for automation)
```bash
# Generate changeset with custom message (non-interactive)
npx @changesets/cli add --message "Add user authentication system

- Implement login and logout components
- Add JWT token management
- Create authentication context
- Update protected routes"

# Generate changeset for specific package with message
npx @changesets/cli add my-package --message "Update dependencies

- Update React to latest version
- Add new dev dependencies"

# Generate patch changeset for all packages
npx @changesets/cli add --message "Fix security vulnerabilities

- Update vulnerable dependencies
- Add security patches" --type patch
```

### 4. PR-Based Changesets
For GitHub PR context, automatically extracts information:

```bash
# Get PR title and body for changeset content
PR_TITLE=$(gh pr view --json title --jq '.title')
PR_BODY=$(gh pr view --json body --jq '.body')

# Generate changeset from PR context
npx @changesets/cli add --message "Update based on PR: $PR_TITLE"
```

## Automatic Changeset Generation

### Git Diff Analysis
Analyzes git diff to determine appropriate changeset content:

```fish
function generate_changeset_from_diff
    # Get staged changes
    set changed_files (git diff --cached --name-only)

    # Analyze file types and changes
    for file in $changed_files
        switch $file
            case "*.md"
                echo "Updated documentation"
            case "package.json"
                echo "Updated dependencies"
            case "src/**/*"
                echo "Modified source code"
            case "tests/**/*"
                echo "Updated tests"
        end
    end
end
```

### PR Context Analysis
Extracts changeset information from GitHub PR:

```fish
function generate_changeset_from_pr
    set pr_title (gh pr view --json title --jq '.title')
    set pr_number (gh pr view --json number --jq '.number')
    set pr_labels (gh pr view --json labels --jq '.labels[].name')

    # Generate changeset message based on PR content
    echo "Update based on PR #$pr_number: $pr_title"

    # Add labels as context
    if contains "breaking-change" $pr_labels
        echo "BREAKING CHANGE: This update includes breaking changes"
    end
end
```

### Manual Changeset Entry
For manual changeset creation with guided prompts:

```bash
# Interactive changeset creation
npx @changesets/cli add

# Answer prompts:
# - Which packages should have a changeset added? (package name)
# - What kind of change is this? (major/minor/patch)
# - Write a summary of the changes
```

### Automatic Package Detection
For automated workflows, detect which packages have changes:

```fish
# Function to detect changed packages
function detect_changed_packages
    set changed_files (git diff --cached --name-only)

    # Extract package names from changed files
    set packages
    for file in $changed_files
        # Check if file is in a package directory
        if string match -q "*/src/*" $file
            set package_name (string replace -r '.*/src/([^/]+).*' '$1' $file)
            if not contains $package_name $packages
                set packages $packages $package_name
            end
        end
    end

    # If no specific packages found, use all packages or main package
    if test (count $packages) -eq 0
        set packages (string split ',' (grep -r '"name"' package.json | head -1 | string replace -r '.*"name"\s*:\s*"([^"]+)".*' '$1'))
    end

    echo $packages
end
```

```bash
# Use in automation
CHANGED_PACKAGES=$(detect_changed_packages)
if [ -n "$CHANGED_PACKAGES" ]; then
  npx @changesets/cli add $CHANGED_PACKAGES --message "Update based on recent changes

- Modified package files
- Updated dependencies and configurations"
fi
```

## Changeset Types and Standards

### Version Bump Types
- **Major**: Breaking changes, API removals, or significant architectural changes
- **Minor**: New features, enhancements, or backward-compatible additions
- **Patch**: Bug fixes, security patches, or minor improvements

### Changeset Message Format
```markdown
---
"package-name": major|minor|patch
---

Summary of changes made

### Technical Details
- Implementation specifics
- Migration notes for breaking changes
- Testing verification steps

### Breaking Changes
- List of breaking changes if major bump
- Migration instructions for users
```

## Best Practices

### Changeset Management
- **Create changesets for every PR**: Each PR should have a corresponding changeset
- **Use conventional commit types**: Align changeset types with commit message conventions
- **Keep messages concise**: Focus on user-facing impact rather than implementation details
- **Include migration notes**: For breaking changes, provide clear upgrade instructions

### Git Workflow Integration
```bash
# Create feature branch
git checkout -b feat/new-feature

# Make changes and stage them
git add .

# Generate changeset based on changes
npx @changesets/cli add

# Commit with conventional message
git commit -m "feat: add new feature"

# Push branch and create PR
git push -u origin feat/new-feature
gh pr create --title "feat: add new feature" --body "..."
```

### Package-Specific Changesets
For monorepos with multiple packages:

```bash
# Add changeset for specific package
npx @changesets/cli add package-name

# Add changeset for multiple packages
npx @changesets/cli add package-a package-b

# Add changeset for all packages (default)
npx @changesets/cli add
```

## Integration with Other Commands

### Commit Integration
Works alongside `/commit-lint` and `/commit-push`:

```bash
# After making changes
git add .

# Generate changeset
npx @changesets/cli add

# Commit with conventional format
git commit -m "feat: add new feature"

# Push changes
git push
```

### PR Integration
Integrates seamlessly with `/pr-create` workflow:

#### Non-Interactive PR Changeset Generation
```bash
# Generate changeset based on PR context (non-interactive)
PR_TITLE=$(gh pr view --json title --jq '.title')
PR_NUMBER=$(gh pr view --json number --jq '.number')

npx @changesets/cli add --message "Update based on PR #$PR_NUMBER: $PR_TITLE

- Implement changes from pull request
- Address review feedback and requirements
- Ensure compatibility with existing functionality"

echo "✅ Changeset generated for PR #$PR_NUMBER"
```

#### Automated Package Detection for PRs
```bash
# Detect changed packages from PR files
PR_FILES=$(gh pr view $PR_NUMBER --json files --jq '.files[].path')
CHANGED_PACKAGES=""

for file in $PR_FILES; do
  if [[ $file =~ ^src/([^/]+)/ ]]; then
    package="${BASH_REMATCH[1]}"
    if [[ ! $CHANGED_PACKAGES =~ $package ]]; then
      CHANGED_PACKAGES="$CHANGED_PACKAGES $package"
    fi
  fi
done

# Generate changeset for detected packages
if [ -n "$CHANGED_PACKAGES" ]; then
  npx @changesets/cli add $CHANGED_PACKAGES --message "PR #$PR_NUMBER: $PR_TITLE

Changes implemented in this pull request:
- Modified package files
- Updated functionality and features
- Maintained backward compatibility"
fi
```

**Automatic Integration**: When using `/pr-create`, changeset generation happens automatically in Step 3 using non-interactive methods if changesets is detected in your repository.

## Advanced Usage

### Batch Changeset Generation
For multiple related changes:

```bash
# Create changeset for current changes
npx @changesets/cli add

# Add additional context
echo "Additional changes made:" >> .changeset/$(ls .changeset/ | tail -1)
```

### Changeset Version Management
```bash
# Check current version status
npx @changesets/cli status

# Preview upcoming version changes
npx @changesets/cli version --dry-run

# Apply version changes
npx @changesets/cli version
```

### Custom Changeset Configuration
```json
{
  "changelog": "@changesets/cli/changelog",
  "commit": "@changesets/cli/commit",
  "linked": [],
  "access": "restricted",
  "baseBranch": "main",
  "updateInternalDependencies": "patch",
  "ignore": []
}
```

## Error Handling

### Common Issues

**Changesets not detected:**
```bash
# Verify changesets installation
npx @changesets/cli --version

# Check for .changeset directory
ls -la .changeset/

# Reinitialize if needed
npx @changesets/cli init --yes
```

**Changeset generation fails:**
```bash
# Check git status
git status

# Ensure changes are staged
git add .

# Retry changeset generation
npx @changesets/cli add
```

**Version conflicts:**
```bash
# Check for conflicting changesets
npx @changesets/cli status

# Resolve conflicts manually or
git checkout HEAD -- .changeset/
npx @changesets/cli add
```

### Troubleshooting Commands
```bash
# Verify changesets setup
npx @changesets/cli --help

# Check current changesets
ls .changeset/

# View changeset content
cat .changeset/$(ls .changeset/ | head -1)

# Validate changeset format
npx @changesets/cli status
```

## CI/CD Integration

### Automated Changeset Validation
```yaml
# .github/workflows/changesets.yml
name: Changesets
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  validate-changesets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npx @changesets/cli status
```


### Version Publishing
```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npx @changesets/cli version
      - run: npm publish
```

## Examples

### Feature Addition (Interactive)
```bash
# After implementing user authentication
git add src/components/Auth/ src/hooks/useAuth.ts
npx @changesets/cli add --message "Add user authentication system

- Implement login and logout components
- Add JWT token management
- Create authentication context
- Update protected routes"

git commit -m "feat: add user authentication system"
```

### Feature Addition (Non-Interactive)
```bash
# After implementing user authentication (automated workflow)
git add src/components/Auth/ src/hooks/useAuth.ts

# Generate changeset with commit message automatically
COMMIT_MSG=$(git log --format=%B -n 1 | head -1)
npx @changesets/cli add --message "Add user authentication system

$COMMIT_MSG

- Implement login and logout components
- Add JWT token management
- Create authentication context
- Update protected routes"

git commit -m "feat: add user authentication system"
```

### Complete PR Workflow with Changesets
```bash
# 1. Create feature branch and make changes
git checkout -b feat/add-user-auth
git add src/components/Auth/ src/hooks/useAuth.ts

# 2. Generate changeset (non-interactive)
if [ -d ".changeset" ]; then
  COMMIT_MESSAGE=$(git log --format=%B -n 1 | head -1)
  npx @changesets/cli add --message "Add user authentication system

$COMMIT_MESSAGE

- Implement login and logout components
- Add JWT token management
- Create authentication context
- Update protected routes"
fi

# 3. Commit with conventional format
git commit -m "feat: add user authentication system

- Add login form component with validation
- Implement JWT token handling and storage
- Create auth context for global state management
- Add protected route wrapper component

Closes #123"

# 4. Push and create PR
git push -u origin feat/add-user-auth
gh pr create --title "feat: add user authentication system" --body "...
🤖 Generated with <AI NAME>"
```

### Package-Specific Changeset
```bash
# For monorepo with multiple packages
git add src/auth-package/src/ src/ui-package/src/

# Generate changeset for specific packages
npx @changesets/cli add auth-package ui-package --message "Update authentication and UI components

- Add new auth features in auth-package
- Update UI components in ui-package
- Maintain backward compatibility"

git commit -m "feat: update auth and UI packages"
```

### Bug Fix
```bash
# After fixing login validation
git add src/utils/validation.ts
npx @changesets/cli add --type patch --message "Fix login validation error

- Correct email format validation
- Improve password strength checking
- Add proper error messaging"

git commit -m "fix: resolve login validation error"
```

### Breaking Change
```bash
# After API redesign
git add src/api/v2/
npx @changesets/cli add --type major --message "Redesign authentication API

BREAKING CHANGE: The authenticate() method now requires email parameter
instead of username. Update all authentication calls accordingly.

### Migration Guide
- Replace username parameter with email
- Update authentication service calls
- Modify login form components"

git commit -m "feat!: redesign authentication API"
```

## Reference
- Changesets documentation: https://github.com/changesets/changesets
- Conventional commits: https://www.conventionalcommits.org/
- GitHub changelog integration: https://github.com/changesets/changelog-github
