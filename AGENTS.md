# AGENTS

## Repository overview
This repository is primarily a HashiCorp Packer project for building AWS EBS-backed Ubuntu AMIs.
The main implementation lives in `ami-Creation/` and the repo also contains learning lab notes (`Lab*.md`).

## Key areas
- `ami-Creation/aws-ubuntu.pkr.hcl`: main Packer template
- `ami-Creation/variables.pkr.hcl`: variable declarations and validation rules
- `ami-Creation/variables.pkrvars.hcl`: development values
- `ami-Creation/qavariables.pkrvars.hcl`: QA values
- `.github/workflows/packer.yml`: GitHub Actions validation workflow
- `README.md`: primary repository documentation and commands

## What agents should do first
1. Treat `ami-Creation/` as the primary working directory for builds and validation.
2. Preserve the repository's existing Packer conventions and variable-file structure.
3. Keep changes minimal and update documentation links in `README.md` only when necessary.

## Build and validation commands
Use these commands from the repo root or from within `ami-Creation/`:

- `cd ami-Creation && packer init .`
- `cd ami-Creation && packer fmt -check .`
- `cd ami-Creation && packer validate -var-file=variables.pkrvars.hcl .`
- `cd ami-Creation && packer validate -var-file=qavariables.pkrvars.hcl .`

Build commands (not run in CI by default):
- `cd ami-Creation && packer build -var-file=variables.pkrvars.hcl .`
- `cd ami-Creation && packer build -var-file=qavariables.pkrvars.hcl .`

## CI behavior
- The GitHub Actions workflow validates formatting and both variable files only.
- Do not assume `packer build` is safe to run in CI, because it can create AWS resources and incur costs.

## Notes for AI code agents
- Link to `README.md` for details rather than duplicating long explanatory text.
- `Lab*.md` files are training/learning notes, not the production implementation.
- `healthcare-microservices/` exists in the repo but has no explicit build manifest in the root README; treat it as secondary unless the task explicitly targets it.
