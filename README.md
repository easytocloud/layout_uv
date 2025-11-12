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
```

That's it! The `layout_uv` function is **automatically installed** to `~/.config/direnv/lib/layout_uv.sh` during installation. You can start using it immediately.

If you ever need to reinstall the direnv function:

```bash
install-layout-uv
```

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
2. Activate the virtual environment
3. Set appropriate environment variables

## How it works

The `layout_uv` function:
- Checks if uv is installed
- Creates a virtual environment using `uv venv` with the specified Python version
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

- **Faster**: uv is significantly faster than pip and traditional virtualenv tools
- **Modern**: Built with Rust for performance and reliability
- **Compatible**: Works seamlessly with existing Python tooling
- **Simple**: Same familiar direnv workflow

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
