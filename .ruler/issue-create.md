# /issue-create — Standard Linear issue checklist

Follow this command to create Linear issues that align with the project's default assignment and labeling rules.

## Default Assignment
- Assign every new issue to `shunkakinoki` immediately after creation.
- Mention additional collaborators in the description instead of reassigning unless ownership genuinely changes.

## Labeling Rules
Apply capitalised labels sourced from `devops/infra/github/src/labels.ts`:
- Bug
- Documentation
- Duplicate
- Enhancement
- Good First Issue
- Help Wanted
- Invalid
- Question
- Wontfix
- Dependabot
- Renovate
- Dependencies
- Automerge

Add the most relevant primary label (e.g., `Enhancement` for features, `Bug` for fixes) and append `Dependencies`, `Automerge`, or automation labels only when they truly apply.

## Issue Body Guidelines
1. **Problem statement** — Describe the user-facing impact or goal.
2. **Acceptance criteria** — Bullet list of conditions that must be met.
3. **Technical notes** — Implementation hints, links to specs, or affected services.
4. **Testing plan** — Outline manual or automated validation steps.

## Tips
- Use templates where available, but still confirm assignment and labels afterwards.
- Cross-link related GitHub issues or PRs inline to give downstream automation the right context.
- Close the issue (or move to Done) only after verifying acceptance criteria and closing PRs that reference it.
