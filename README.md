![release workflow](https://github.com/easytocloud/layout_uv/actions/workflows/release.yml/badge.svg)

# layout_uv

A Homebrew package that adds `layout_uv` functionality to direnv, enabling seamless Python environment management using [uv](https://docs.astral.sh/uv/).

## What is layout_uv?

`layout_uv` is a direnv layout function that works similar to `layout python`, but uses the modern and fast [uv](https://docs.astral.sh/uv/) tool for Python environment management. It automatically creates and activates a Python virtual environment when you enter a directory.

## Prerequisites

- [Homebrew](https://brew.sh/) installed
- [direnv](https://direnv.net/) installed and configured
- [uv](https://docs.astral.sh/uv/) installed

To install uv:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Installation

```bash
brew install easytocloud/tap/layout_uv
install-layout-uv
```

The first command installs the package, and the second command installs the direnv function to `~/.config/direnv/lib/layout_uv.sh`.

## Usage

In your project directory, create or edit `.envrc`:

```bash
# Use default Python version (python3.12)
layout uv

# Or specify a Python version
layout uv python3.11
```

Then allow direnv to load the configuration:

```bash
direnv allow
```

When you enter the directory, direnv will:
1. Create a `.venv` directory if it doesn't exist (using uv)
2. Automatically sync dependencies from `pyproject.toml` or `requirements.txt`
3. Activate the virtual environment
4. Set appropriate environment variables

## How it works

The `layout_uv` function:
- Checks if uv is installed
- Creates a virtual environment using `uv venv` with the specified Python version
- Automatically syncs dependencies:
  - For `pyproject.toml` projects: runs `uv sync --frozen` (or `uv sync` if lockfile needs updating)
  - For `requirements.txt` projects: runs `uv pip install -r requirements.txt`
  - Uses `watch_file` to only re-sync when dependency files change
- Activates the environment by setting `VIRTUAL_ENV` and updating `PATH`
- Sets `UV_PROJECT_ENVIRONMENT` for uv integration

## Example

```bash
$ cd myproject
$ echo "layout uv python3.12" > .envrc
$ direnv allow
direnv: loading ~/myproject/.envrc
Creating virtual environment with uv using python3.12
uv environment activated: /Users/username/myproject/.venv

$ which python
/Users/username/myproject/.venv/bin/python

$ python --version
Python 3.12.0
```

## Benefits over traditional virtualenv

- **Faster**: uv is significantly faster than pip and traditional virtualenv tools (10-100x for large projects)
- **Modern**: Built with Rust for performance and reliability
- **Automatic dependency management**: Dependencies stay in sync automatically when switching branches or pulling changes
- **Smart syncing**: Only re-syncs when dependency files change (using direnv's `watch_file`)
- **Lockfile support**: Works with both modern `pyproject.toml` + `uv.lock` and legacy `requirements.txt`
- **Compatible**: Works seamlessly with existing Python tooling
- **Simple**: Same familiar direnv workflow with zero manual dependency management

## Dependency Management

### Using pyproject.toml (Recommended)

For new projects, use `pyproject.toml` for dependency management:

```bash
# Initialize a new uv project
uv init

# Add dependencies
uv add requests pandas

# Dependencies will auto-sync when you cd into the directory
```

The `layout_uv` function automatically:
- Runs `uv sync --frozen` for fast installs using the lockfile
- Falls back to `uv sync` if the lockfile needs updating
- Only re-syncs when `pyproject.toml` or `uv.lock` changes

### Using requirements.txt (Legacy)

For existing projects with `requirements.txt`:

```bash
# Dependencies will auto-install when you cd into the directory
# The function runs: uv pip install -r requirements.txt
```

### Migration from requirements.txt to pyproject.toml

```bash
# Convert requirements.txt to pyproject.toml
uv init
uv add -r requirements.txt
```

## Uninstallation

To uninstall the Homebrew package:

```bash
brew uninstall layout_uv
```

Note: The direnv function file (`~/.config/direnv/lib/layout_uv.sh`) will remain after uninstallation. To remove it manually:

```bash
rm ~/.config/direnv/lib/layout_uv.sh
```

## License

See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
