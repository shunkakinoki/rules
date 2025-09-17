# /commit-push — Conventional commit and push workflow

Use this command when committing changes to follow Conventional Commits standards and push with upstream tracking.

## Prerequisites
- Ensure all changes are staged or ready to be staged
- Work from a feature branch (not main)
- Run pre-commit checks before staging files
- Review and apply any auto-fixes

## Quick Workflow
```bash
# Stage all changes
git add .

# Or stage specific files
git add <file1> <file2>

# Commit with conventional format
git commit -m "feat: add new feature description"

# Push with upstream tracking (first push only)
git push -u origin <branch-name>

# Subsequent pushes (no -u needed)
git push
```

## Pre-commit Quality Checks

Before committing, ensure code quality by running:

```bash
# Run formatting with Biome
pnpm run format

# Run linting and checks
pnpm run lint

# Run all quality checks
pnpm run check
```

### Auto-fix Capabilities
The system includes auto-fix commands:

- **Biome Format**: `pnpm run biome:format` - Automatically formats code
- **Biome Check**: `pnpm run biome:check --write` - Auto-fixes linting violations

### Quality Verification
- **Review auto-fixes** for correctness before committing
- **Test changes** to ensure formatting doesn't break functionality
- **Verify all checks pass** before finalizing the commit

## Conventional Commit Types

- `feat:` - A new feature
- `fix:` - A bug fix
- `docs:` - Documentation only changes
- `style:` - Changes that do not affect the meaning of the code
- `refactor:` - A code change that neither fixes a bug nor adds a feature
- `test:` - Adding missing tests or correcting existing tests
- `chore:` - Changes to the build process or auxiliary tools
- `perf:` - A code change that improves performance
- `ci:` - Changes to CI configuration files and scripts
- `build:` - Changes that affect the build system or external dependencies
- `revert:` - Reverts a previous commit

## Commit Message Format

```bash
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

### Examples

```bash
# Feature commit
feat: add user authentication system

# Bug fix with scope
fix(auth): resolve login validation error

# Documentation update
docs: update API documentation for v2.0

# Breaking change
feat!: change authentication API interface

BREAKING CHANGE: The authenticate() method now requires email parameter
```

## Interactive Commit Helper

For complex changes, use interactive staging:

```bash
# Interactive staging
git add -p

# Or use git gui for visual staging
git gui

# Then commit
git commit -m "feat: implement user dashboard"
```

## Branch Management

```bash
# Create and switch to new feature branch
git checkout -b feature/new-feature

# Push and set upstream (first time)
git push -u origin feature/new-feature

# Check branch status
git status
git branch -v
```

## Best Practices

- **Keep commits atomic**: Each commit should represent one logical change
- **Write clear descriptions**: Explain what changed and why
- **Stay under 72 characters**: For both title and body lines
- **Use present tense**: "Add feature" not "Added feature"
- **Reference issues**: Use `Closes #123` or `Fixes #456` in commit body
- **No co-authors in commits**: Keep commits solo-authored (per project policy)

## Troubleshooting

### Amend last commit
```bash
# Amend commit message
git commit --amend -m "feat: updated commit message"

# Amend and add more changes
git add <new-files>
git commit --amend --no-edit
```

### Undo last commit (keep changes)
```bash
git reset --soft HEAD~1
```

### Undo last commit (discard changes)
```bash
git reset --hard HEAD~1
```

### Fix commit message issues
```bash
# If commit message fails validation
git commit --amend
# Edit the message in your editor
# Save and exit

# Or amend with new message directly
git commit --amend -m "fix: correct validation logic"
```

## Integration with PR Workflow

After committing and pushing:
1. Use `/pr-create` command to create pull request
2. Follow PR creation checklist
3. Request reviewers as needed

## Reference
- Full commit linting rules: `/commit-lint`
- Pre-commit hook detection: `.ruler/commit-lint.md`
- PR creation workflow: `/pr-create`
