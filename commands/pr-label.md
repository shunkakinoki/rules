# /pr-label - Comprehensive PR Labeling Guide

This document outlines the rules and best practices for automatically labeling GitHub Pull Requests (PRs) based on Conventional Commit types and other criteria.

## GitHub PR Labeling Rules

This rule defines how PR labels are applied automatically. It uses the default labels and maps Conventional Commit types to GitHub labels.

## Default Labels (source of truth)

Names are defined as:

- bug
- documentation
- duplicate
- enhancement
- good first issue
- help wanted
- invalid
- question
- wontfix
- dependabot
- renovate
- dependencies
- automerge

## Label Mapping Rules

- feat → enhancement
- fix → bug
- docs → documentation
- chore(deps), build(deps) → dependencies
- PR authored by dependabot → dependabot
- PR authored by renovate → renovate
- If title contains "[automerge]" or label "automerge" is requested in the description, also add automerge

Notes:
- Only apply one of enhancement/bug/documentation based on the primary Conventional Commit type at the start of the PR title.
- Do not add unrelated labels automatically.

## Usage

- Run the snippet after creating the PR, or integrate it into your local automation.
- Ensure the label names exist in the repository (they are provisioned via Pulumi from `labels.ts`).
