![release workflow](https://github.com/easytocloud/brewable/actions/workflows/release.yml/badge.svg)

# brewable

Template for brewable product

# CHANGE

## Product

- Add your product distribution/bin and distribution/completions

## README

- Change brewable in badge into repo-name (top line in README)
- Write instructions and sample usecases

## Workflow

In .github/workflow/release.yml

- Change branchname
- Change description
- Modify installables

## GitHub

- Write a short 'About'
- Add repo to Fine Grained Access token github-easytocloud-brew [Account]
- Add OP_SERVICE_ACCOUNT_TOKEN to Secrets & Variables -> Actions when not in Organization Secrets already [Repo]

The OP (1Password) token gives access to my 1password account's CICD vault that has the actual secret to use the Fine Grained Access token,
giving the necessary permissions on the source repo as well as the Homebrew Tap repo.
