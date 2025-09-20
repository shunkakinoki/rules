# /repo-setup — Local environment bootstrap

This command bootstraps a fresh checkout so tooling and automated hooks run consistently across contributors.

## Prerequisites
- Node.js 18 or newer (matches the version required by Ruler)
- Package manager (bun/pnpm/npm/yarn) - currently configured for `bun@1.2.22`
- Git with commit signing configured if your workflow requires it

## Package Manager Detection

Before running setup commands, detect which package manager is being used:

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

echo "Detected package manager: $PACKAGE_MANAGER"
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

echo "Detected package manager: $PACKAGE_MANAGER"
```

## Installation Steps
```fish
# Install all workspace dependencies (adapt based on detected package manager)
$PACKAGE_MANAGER install

# Install Git hooks managed by lefthook
$PACKAGE_MANAGER run lefthook:install

# Generate and sync agent instructions via Ruler
$PACKAGE_MANAGER run ruler:apply
```

## Verification
- Run `$PACKAGE_MANAGER run check` to ensure Biome and Ruler checks pass without modifying files.
- Inspect `git status` and confirm there are no unexpected changes after the commands complete.
- Optionally run `$PACKAGE_MANAGER run ruler:check` for a non-destructive confirmation that generated files stay in sync.

## Troubleshooting
- If the detected package manager is missing, install it:
  - **bun**: Follow the [bun installation guide](https://bun.sh/docs/installation)
  - **pnpm**: Install with `npm install -g pnpm` or follow [pnpm installation](https://pnpm.io/installation)
  - **yarn**: Install with `npm install -g yarn` or follow [yarn installation](https://yarnpkg.com/getting-started/installation)
  - **npm**: Usually comes with Node.js
- When `$PACKAGE_MANAGER run ruler:apply` updates tracked files, review and commit those changes so teammates stay aligned.
- If lefthook scripts fail, re-run `$PACKAGE_MANAGER run lefthook:install` and verify your Git hooks directory has execute permissions.
