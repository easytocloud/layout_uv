# layout_uv - direnv layout for uv Python environments
# This function sets up a Python environment using uv similar to layout python

layout_uv() {
    local uv_python_version="${1:-python3.12}"

    # Check if uv is installed
    if ! command -v uv &> /dev/null; then
        log_error "uv is not installed. Please install it first: https://docs.astral.sh/uv/"
        return 1
    fi

    # Create .venv if it doesn't exist
    if [[ ! -d .venv ]]; then
        log_status "Creating virtual environment with uv using $uv_python_version"
        uv venv --python "$uv_python_version"
    fi

    # Activate the virtual environment
    export VIRTUAL_ENV="$PWD/.venv"
    PATH_add "$VIRTUAL_ENV/bin"

    # Set Python-related environment variables
    export UV_PROJECT_ENVIRONMENT="$VIRTUAL_ENV"

    log_status "your uv environment is activated: $VIRTUAL_ENV"
}
