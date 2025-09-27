# /pr-create — Comprehensive PR creation workflow

## OBJECTIVE

This command provides a standardized, comprehensive workflow for creating GitHub Pull Requests with proper formatting, labeling, and quality assurance. The workflow ensures:

- Consistent PR structure and content standards
- Automated quality checks and validation
- Proper conventional commit practices
- Strategic labeling and reviewer assignment
- Comprehensive testing and documentation requirements
- Automatic changeset generation for version management

**CRITICAL RULE**: This command is STRICTLY for creating GitHub Pull Requests only. Creating new script files, executables, or automation tools that replicate or extend this functionality is EXPLICITLY PROHIBITED. All PR creation must go through the established `gh pr create` workflow documented here.

Use this command when preparing a pull request. Follow each section before running `gh pr create`.

## Prerequisites

### GitHub CLI Setup
- **Install GitHub CLI**: `which gh` (install if not found)
- **Verify authentication**: `gh auth status`
- **Required token scope**: Token must have `repo` scope for PR creation
- **Authentication**: Run `gh auth login` if not authenticated

### Branch Requirements
- **Work on feature branches** (never commit directly to `main`)
- **Keep branches focused** on single features/fixes
- **Use descriptive names** (e.g., `fix-build-dependencies`, `feat-user-auth`)
- **Current branch check**: `git branch --show-current`

## Complete Workflow

### Step 1: Prepare Changes
```bash
# Check current status and see what files changed
git status

# Stage specific files or all changes
git add <files>          # Stage specific files
git add .               # Stage all changes in current directory

# Or use interactive staging for complex changes
git add -p              # Interactive patch staging
```

### Step 2: Create Feature Branch (if needed)
```bash
# Create and switch to new feature branch
git checkout -b feature/new-feature-name

# Or switch to existing feature branch
git checkout existing-feature-branch

# Verify you're on the correct branch
git branch --show-current
```

### Step 3: Generate Changeset (if applicable)
```bash
# Check if repository uses changesets and generate changeset automatically
if [ -d ".changeset" ] || grep -q "@changesets/cli" package.json 2>/dev/null || [ -f ".changeset/config.json" ]; then
  echo "🔄 Changesets detected - generating changeset entry..."

  # Generate changeset based on current changes
  npx @changesets/cli add

  echo "✅ Changeset generated successfully"
else
  echo "ℹ️  No changesets setup detected - skipping changeset generation"
fi
```

### Step 4: Commit Changes
```bash
# Commit with conventional commit format
git commit -m "feat: add user authentication system

- Add login form component
- Implement JWT token handling
- Add user session management

Closes #123"

# Or use /commit-and-push command for guided workflow
# Reference: /commit-and-push
```

### Step 5: Push Branch
```bash
# Push and set upstream (first time only)
git push -u origin feature-branch-name

# Subsequent pushes (no -u needed)
git push
```

### Step 6: Create PR via CLI
```bash
gh pr create \
  --title "feat: add user authentication system" \
  --body "## Changes Made
- Added login form component with validation
- Implemented JWT token handling and storage
- Added user session management utilities
- Updated routing to protect authenticated routes

## Technical Details
- Uses React hooks for state management
- Implements secure token storage in localStorage
- Adds middleware for route protection
- Follows existing component patterns and styling

## Testing
- Verified login/logout flow works correctly
- All pre-commit hooks pass (Biome formatting, linting)
- Component tests added for auth utilities
- Manual testing completed on all major browsers
- No breaking changes to existing functionality

🤖 Generated with <AI NAME>" \
  --base main \
  --head feature-branch-name
```

### Step 7: Reviews and (Optional) Auto-merge
Do not merge immediately after creating a PR. First request reviews and wait for required checks to pass. If your repository policy allows it, you may enable auto-merge so GitHub merges the PR once approvals and checks are satisfied.

Variant: `/pr-create auto` — This variant configures the created PR to auto-merge using squash. It never merges immediately; it will merge only after all required approvals and checks pass according to repository rules.

```bash
# (Optional) Enable auto-merge with squash; merges later when ready
gh pr merge <pr-number> --squash --auto
```

**Note**: Auto-squashing should only be used when:
- The PR contains multiple small commits that would benefit from consolidation
- All commits in the PR are related to the same feature/fix
- The commit history doesn't contain important intermediate states that need preservation
- Team policy allows squashing (consult repository guidelines)

## Auto-Merge Variant Workflow

### When to Use `/pr-create auto`
Use this variant when:
- **Repository policy allows auto-merge** with required approvals
- **PR contains multiple related commits** that should be squashed
- **All required checks pass** and approvals are expected
- **You want to reduce manual merge operations**

### Auto-Merge Prerequisites
- **Branch protection rules** must allow auto-merge
- **Required status checks** must be configured
- **Minimum approval requirements** must be met
- **Repository settings** must enable auto-merge

### Step 7 (Auto Variant): Create PR with Auto-Merge
```bash
gh pr create \
  --title "feat: add user authentication system" \
  --body "## Changes Made
- Added login form component with validation
- Implemented JWT token handling and storage
- Added user session management utilities
- Updated routing to protect authenticated routes

## Technical Details
- Uses React hooks for state management
- Implements secure token storage in localStorage
- Adds middleware for route protection
- Follows existing component patterns and styling

## Testing
- Verified login/logout flow works correctly
- All pre-commit hooks pass (Biome formatting, linting)
- Component tests added for auth utilities
- Manual testing completed on all major browsers
- No breaking changes to existing functionality

🤖 Generated with <AI NAME>" \
  --base main \
  --head feature-branch-name
```

### Step 8 (Auto Variant): Enable Auto-Merge
```bash
# Enable auto-merge with squash for the created PR
PR_NUMBER=$(gh pr view --json number --jq '.number')
gh pr merge $PR_NUMBER --squash --auto

echo "✅ Auto-merge enabled for PR #$PR_NUMBER"
echo "🔄 PR will merge automatically when:"
echo "   - All required approvals are received"
echo "   - All status checks pass"
echo "   - Branch protection rules are satisfied"
```

### Auto-Merge Status Monitoring
```bash
# Check auto-merge status
gh pr view <pr-number> --json isInMergeQueue,mergeable,mergeStateStatus

# Monitor merge queue (if using merge queues)
gh pr view <pr-number> --json mergeQueueEntry
```

### Auto-Merge Troubleshooting
```bash
# Check why auto-merge is blocked
gh pr view <pr-number> --json reviewDecision,mergeStateStatus

# View detailed merge requirements
gh pr view <pr-number> --json mergeRequirements

# Manually disable auto-merge if needed
gh pr merge <pr-number> --auto-merge disable
```

### Auto-Merge Best Practices
- **Monitor auto-merge status** regularly until merged
- **Review merge requirements** before enabling auto-merge
- **Test the workflow** on non-critical PRs first
- **Have rollback plan** if auto-merge causes issues
- **Document auto-merge usage** in team guidelines

## PR Content Standards

### Title Format
- **Use conventional commit format**: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- **Keep under 72 characters** for optimal display
- **Be specific and actionable**: "Add user auth" vs "Update stuff"
- **Include scope if relevant**: `fix(auth): resolve login issue`

### Description Requirements
- **Changes Made**: Bullet list of what was modified
- **Technical Details**: Implementation specifics and rationale
- **Testing**: Verification steps and pre-commit status
- **AI Attribution**: `🤖 Generated with <AI NAME>` (current assistant)

### AI Attribution Guidelines
- **Current assistant**: Replace `<AI NAME>` with your AI assistant name
- **Format**: `🤖 Generated with <AI NAME>` (no co-authorship)
- **Placement**: At the end of PR description
- **Consistency**: Use same attribution across all generated content

## Step 9: Labeling & Reviewers

### Automatic Labeling
After PR creation, add appropriate labels:
```bash
# Feature PR
gh pr edit <number> --add-label enhancement

# Bug fix PR
gh pr edit <number> --add-label bug

# Documentation PR
gh pr edit <number> --add-label documentation

# Dependencies PR
gh pr edit <number> --add-label dependencies
```

### Request Reviewers
```bash
# Add specific reviewers
gh pr edit <number> --add-reviewer username1,username2

# Add team reviewers
gh pr edit <number> --add-reviewer "@org/team-name"
```

## Error Handling

### Common Issues & Solutions
- **Authentication failed**: Run `gh auth login`
- **Branch not found**: Ensure branch is pushed to remote first
- **Permission denied**: Check repository access and token scopes
- **PR already exists**: Use `gh pr edit` to modify existing PR

### Troubleshooting Commands
```bash
# Check PR status
gh pr list

# View PR details
gh pr view <number>

# Update PR description
gh pr edit <number> --body "Updated description"

# Change PR title
gh pr edit <number> --title "Updated title"

# Close PR
gh pr close <number>
```

## Step 10: Best Practices

### Commit Guidelines
- **Solo-authored commits only** - DO NOT include co-authorship in commit messages
- **NO co-authorship** - Never add "Co-Authored-By: Claude" or similar co-authorship attribution in commits
- **AI name belongs in PR description only** - Use `🤖 Generated with <AI NAME>` format in PR body, not commit messages
- **Use present tense** in commit messages ("Add feature" not "Added feature")
- **Keep commits atomic** and focused on single changes
- **Reference issues** when applicable (`Closes #123`, `Fixes #456`)

### PR Size Management
- **Keep PRs focused** on single concerns or related changes
- **Split large changes** into multiple smaller PRs
- **Use draft PRs** for work-in-progress or incomplete features
- **Request reviews early** for complex changes to get feedback

### Quality Assurance
- **Ensure all pre-commit hooks pass** before creating PR
- **Run tests** before creating PR (adapt commands based on detected package manager)
- **Verify code formatting** (Biome handles this automatically)
- **Check for breaking changes** and document them clearly
- **Test manually** for UI/UX changes

#### Package Manager Detection for Testing

Before running tests, detect which package manager is being used:

```bash
# Check for package manager
if [ -f "bun.lockb" ] || [ -f "bun.lock" ]; then
  PACKAGE_MANAGER="bun"
elif [ -f "pnpm-lock.yaml" ]; then
  PACKAGE_MANAGER="pnpm"
elif [ -f "yarn.lock" ]; then
  PACKAGE_MANAGER="yarn"
elif [ -f "package-lock.json" ]; then
  PACKAGE_MANAGER="npm"
else
  PACKAGE_MANAGER="npm"  # fallback to npm
fi

# Run tests with detected package manager
$PACKAGE_MANAGER run test
```

### CI/CD Integration
- **PRs automatically trigger** CI pipelines
- **Address failing checks** promptly (tests, linting, formatting)
- **Monitor CI status** and fix issues before requesting review
- **Document known limitations** if any checks are expected to fail

## Complete Example

```bash
# 1. Create feature branch
git checkout -b feat-add-user-auth

# 2. Make changes and stage
git add src/components/Auth/ src/utils/auth.ts
git status

# 3. Generate changeset (if changesets is configured)
if [ -d ".changeset" ] || grep -q "@changesets/cli" package.json 2>/dev/null || [ -f ".changeset/config.json" ]; then
  echo "🔄 Generating changeset..."
  npx @changesets/cli add
fi

# 4. Commit with conventional format with no co-authorship
git commit -m "feat: implement user authentication system

- Add login/logout components with form validation
- Implement JWT token management and secure storage
- Create auth context for global state management
- Add protected route wrapper component

Closes #123"

# 5. Push to remote
git push -u origin feat-add-user-auth

# 6. Create PR with comprehensive description
gh pr create \
  --title "feat: implement user authentication system" \
  --body "## Changes Made
- Added complete user authentication flow with login/logout
- Implemented secure JWT token handling and storage
- Created React context for global auth state management
- Added protected route components for authenticated pages

## Technical Details
- Uses React hooks and context for state management
- Implements secure token storage with expiration handling
- Follows existing component architecture and styling patterns
- Includes proper error handling and loading states

## Testing
- All pre-commit hooks pass (Biome formatting, linting, TypeScript checks)
- Component tests added for auth utilities and context
- Manual testing completed for login/logout flows
- Verified compatibility with existing user management

🤖 Generated with <AI NAME>" \
  --base main \
  --head feat-add-user-auth

# 7. Enable auto-squashing (if using /pr-create auto)
gh pr merge <pr-number> --squash --auto

# 8. Add labels and reviewers
gh pr edit <pr-number> --add-label enhancement
gh pr edit <pr-number> --add-reviewer "@org/frontend-team"
```

## Integration with Other Commands

- **Changeset management**: Use `/changesets` for automatic changeset generation and management
- **Commit workflow**: Use `/commit-and-push` for guided conventional commits
- **Code quality**: Reference `.ruler/commit-lint.md` for detailed standards
- **PR labeling**: Use `/pr-labeling` for automated label management

## Reference
- Full policy: `.ruler/pr-creation.md` in this repository
- Changeset management: `/changesets`
- Commit standards: `/commit-and-push`
- Labeling automation: `/pr-labeling`
