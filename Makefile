.DEFAULT_GOAL := help

# ====================================================================================
# VARIABLES
# ====================================================================================

COMMANDS_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))commands
COMMANDS_TARGET_DIRS := $(HOME)/.cursor/commands $(HOME)/.claude/commands $(HOME)/.codex/prompts $(HOME)/.config/opencode/command $(HOME)/.config/amp/commands $(HOME)/.kilocode/workflows $(HOME)/Documents/Cline/Rules

# ====================================================================================
# COMMANDS
# ====================================================================================

.PHONY: sync-commands
sync-commands: ## Sync project commands to assistant-specific directories.
	@for target in $(COMMANDS_TARGET_DIRS); do \
		if mkdir -p $$target && rsync -a --delete $(COMMANDS_SRC_DIR)/ $$target/; then \
			echo "Synced $(COMMANDS_SRC_DIR) → $$target"; \
		else \
			echo "Failed syncing $(COMMANDS_SRC_DIR) → $$target"; \
			exit 1; \
		fi; \
	done

.PHONY: commands-copy
commands-copy: ## Copy commands to .ruler directory.
	@cp $(COMMANDS_SRC_DIR)/*.md .ruler/

# ====================================================================================
# HELP
# ====================================================================================

.PHONY: help
help: ## Show this help message.
	@echo "Usage: make <target>"
	@echo
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
