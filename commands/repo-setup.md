# /repo-setup — Local environment bootstrap

This command bootstraps a fresh checkout so tooling and automated hooks run consistently across contributors.

## Prerequisites
- Node.js 18 or newer (matches the version required by Ruler)
- pnpm 9.15.4 (matches the `packageManager` field)
- Git with commit signing configured if your workflow requires it

## Installation Steps
```fish
# Install all workspace dependencies
pnpm install

# Install Git hooks managed by lefthook
pnpm run lefthook:install

# Generate and sync agent instructions via Ruler
pnpm run ruler:apply
```

## Verification
- Run `pnpm run check` to ensure Biome and Ruler checks pass without modifying files.
- Inspect `git status` and confirm there are no unexpected changes after the commands complete.
- Optionally run `pnpm run ruler:check` for a non-destructive confirmation that generated files stay in sync.

## Troubleshooting
- If pnpm is missing, install it with `corepack enable pnpm` or follow the [pnpm installation guide](https://pnpm.io/installation).
- When `pnpm run ruler:apply` updates tracked files, review and commit those changes so teammates stay aligned.
- If lefthook scripts fail, re-run `pnpm run lefthook:install` and verify your Git hooks directory has execute permissions.
