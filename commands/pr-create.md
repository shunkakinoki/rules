# /pr-create — Kintex PR creation checklist

Use this command when preparing a pull request for the Kintex project. Follow each section before running `gh pr create`.

## Prerequisites
- Install and auth GitHub CLI: `which gh` and `gh auth status` (token needs `repo`).
- Work from a feature branch named for the change (e.g. `fix-build-dependencies`).

## Workflow
1. Review `git status` and stage intentional changes with `git add`.
2. Commit using Conventional Commits (`feat:`, `fix:`, `docs:`, etc.) under 72 chars.
3. Push with upstream tracking: `git push -u origin <branch>`.
4. Create the PR via CLI:
   ```bash
   gh pr create \
     --title "<type>: <concise summary>" \
     --body "## Changes Made\n- ...\n\n## Technical Details\n- ...\n\n## Testing\n- ...\n\n🤖 Generated with <AI Name>" \
     --base main \
     --head <branch>
   ```

## PR Content Standards
- **Title**: Conventional commit style, no more than 72 characters.
- **Body**: Provide three sections—Changes Made, Technical Details, Testing.
- **Testing**: Explicitly describe checks run (tests, lint, pre-commit hooks).
- **Attribution**: Update the AI name + email to the assistant that generated the PR text.

## Labeling & Reviewers
- After creation, run `gh pr edit <number> --add-label ...` as needed (feat→enhancement, fix→bug, docs→documentation).
- Request reviewers with `gh pr edit <number> --add-reviewer username`.

## Best Practices
- Keep commits atomic and solo-authored (no co-author footers in commits).
- Ensure Biome formatting, lint, and checks pass before requesting review.
- Split large efforts into multiple PRs; use draft PRs for WIP.
- Follow up on CI failures promptly and document any known limitations.

## Reference
Full policy: `.ruler/pr-creation.md` in this repository.
