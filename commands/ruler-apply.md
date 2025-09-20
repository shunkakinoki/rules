# /ruler-apply — Regenerate agent instructions with Ruler

Use this command whenever `.ruler/` files or command documentation changes, or after pulling updates that touch repository rules.

## When to Run
- After editing any file under `.ruler/` (including `commands/` docs referenced from there)
- Before committing changes that rely on regenerated instruction files such as `AGENTS.md`
- After rebasing or pulling main when rules may have changed

## Package Manager Detection

Before running ruler commands, detect which package manager is being used:

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
```

### Fish Detection Logic

```fish
# Check for package manager (Fish)
set PACKAGE_MANAGER npm
if test -f bun.lockb -o -f bun.lock
  set PACKAGE_MANAGER bun
else if test -f pnpm-lock.yaml
  set PACKAGE_MANAGER pnpm
else if test -f yarn.lock
  set PACKAGE_MANAGER yarn
else if test -f package-lock.json
  set PACKAGE_MANAGER npm
end
```

## Command Sequence
```fish
# Regenerate agent instruction files (adapt based on detected package manager)
$PACKAGE_MANAGER run ruler:apply

# Double-check that regeneration left the tree clean
$PACKAGE_MANAGER run ruler:check
```

## What to Inspect
- Review `git status` for modified instruction outputs (e.g., `AGENTS.md`, `.cursor/...`).
- If files changed, skim the diff to ensure new content reflects your rule updates.
- Commit regenerated files together with the rule change so other contributors stay in sync.

## Troubleshooting
- If `$PACKAGE_MANAGER run ruler:check` reports a dirty tree, run `git status --short` to see which files still differ.
- For merge conflicts in generated files, resolve them in the source `.ruler/` Markdown first, re-run `$PACKAGE_MANAGER run ruler:apply`, then commit the regenerated outputs.
- When `.gitignore` changes unexpectedly, confirm `[gitignore].enabled` in `.ruler/ruler.toml` matches the desired setting before re-running the command.
