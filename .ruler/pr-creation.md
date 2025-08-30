# Pull Request Creation Guidelines

When creating pull requests for the Kintex project, follow these automated guidelines to ensure consistency and quality.

## Prerequisites

### GitHub CLI Setup
- Ensure GitHub CLI (`gh`) is installed: `which gh`
- Verify authentication: `gh auth status`
- Token must have `repo` scope for PR creation

### Branch Requirements
- Work on feature branches (not `main`)
- Keep branches focused on single features/fixes
- Use descriptive branch names (e.g., `fix-build-dependencies`, `feat-user-auth`)

## Automated PR Creation Process

### Step 1: Prepare Changes
```bash
# Check current status
git status

# Stage changes
git add <files>

# Commit with descriptive message
git commit -m "feat/fix/refactor: Description of changes"
```

### Step 2: Create Feature Branch
```bash
# Create and switch to new branch
git checkout -b feature-branch-name

# Or switch if branch already exists
git checkout feature-branch-name
```

### Step 3: Push Branch
```bash
# Push branch to remote
git push -u origin feature-branch-name
```

### Step 4: Create PR via CLI
```bash
gh pr create \
  --title "Clear, descriptive title" \
  --body "Detailed description with:
  ## Changes Made
  - Bullet points of what was changed

  ## Technical Details
  - Implementation details
  - Dependencies affected

  ## Testing
  - How changes were tested
  - Pre-commit hooks status

  🤖 Generated with Grok
  Co-Authored-By: Grok <noreply@x.ai>" \
  --base main \
  --head feature-branch-name
```

## PR Content Standards

### Title Format
- Use conventional commit format: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- Keep under 72 characters
- Be specific and actionable

### Description Requirements
- **Changes Made**: Bullet list of modifications
- **Technical Details**: Implementation specifics and rationale
- **Testing**: Verification steps and pre-commit status
- **Co-authorship**: Include AI attribution footer

### AI Attribution Guidelines
- **Always use current AI assistant**: Update attribution to match the AI assistant actually used
- **Update when switching assistants**: Modify both the generation notice and co-authorship email
- **Standard format**: `🤖 Generated with [AI Name]` followed by `Co-Authored-By: [AI Name] <email>`

#### How to Update AI Attribution:
```bash
# 1. Identify current AI assistant and its company
# Examples:
# - Grok → xAI → noreply@x.ai
# - Claude → Anthropic → noreply@anthropic.com
# - GitHub Copilot → GitHub → noreply@github.com

# 2. Update all instances in PR templates:
# - 🤖 Generated with [AI Assistant Name]
# - Co-Authored-By: [AI Assistant Name] <noreply@company-domain>

# 3. Update in these files:
# - .ruler/pr-creation.md (this file)
# - Any other PR template files
# - Documentation examples

# 4. Test the changes:
# - Run a test PR creation to verify attribution appears correctly
# - Ensure the email domain is valid and appropriate
```

### Labels and Reviewers
```bash
# Add labels after creation
gh pr edit <number> --add-label "enhancement,documentation"

# Request reviewers
gh pr edit <number> --add-reviewer username1,username2
```

## Error Handling

### Common Issues
- **Authentication failed**: Run `gh auth login`
- **Branch not found**: Ensure branch is pushed to remote
- **Permission denied**: Check repository access and token scopes

### Troubleshooting Commands
```bash
# Check PR status
gh pr list

# View PR details
gh pr view <number>

# Update PR description
gh pr edit <number> --body "Updated description"
```

## Best Practices

### Commit Guidelines
- **Solo-authored commits only** - DO NOT include co-authorship in commit messages
- Use present tense in commit messages
- Keep commits atomic and focused
- Reference issues when applicable

### PR Size Management
- Keep PRs focused on single concerns
- Split large changes into multiple PRs
- Use draft PRs for work-in-progress
- Request reviews early for complex changes

### Quality Checks
- Ensure all pre-commit hooks pass
- Run tests before creating PR
- Verify code formatting
- Check for breaking changes

## Automated Workflows

### CI/CD Integration
- PRs automatically trigger CI pipelines
- Ensure all checks pass before merging
- Address any failing tests or linting issues

### Merge Strategy
- Use squash merge for clean history
- Delete branches after merge
- Update documentation as needed

## Example PR Creation

```bash
# Complete workflow example
git checkout -b fix-build-dependencies
git add Makefile apps/desktop/turbo.json
git commit -m "fix: Resolve build dependency issues

- Fix shell escaping in Makefile
- Add widget build dependency in turbo.json
- Add combined build target"
git push -u origin fix-build-dependencies

gh pr create \
  --title "Fix build dependencies and shell escaping" \
  --body "This PR fixes build pipeline issues:

## Changes Made:
- Fixed shell escaping in Makefile desktop-prebuild target
- Added turbo.json dependency to ensure widget builds before desktop
- Added combined build target for convenience

## Technical Details:
- Resolves shell variable escaping issue that could cause CI failures
- Ensures proper dependency ordering between components
- Provides unified build command

## Testing:
- Verified build pipeline works correctly
- All pre-commit hooks pass
- Code formatting applied automatically

🤖 Generated with Grok
Co-Authored-By: Grok <noreply@x.ai>" \
  --base main \
  --head fix-build-dependencies
```

This process ensures consistent, high-quality PR creation across the Kintex project while maintaining proper attribution and documentation standards.
