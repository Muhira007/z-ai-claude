# Contributing to zcl

Terima kasih atas minatmu untuk berkontribusi!

## Development Setup

```bash
# Clone repo
git clone https://github.com/Muhira007/z-ai-claude.git
cd z-ai-claude

# Make changes to zcl script
# ...

# Run linting
make lint

# Run tests
make test

# Install locally for testing
make install
```

## Project Structure

```
zcl/
├── zcl                # Main Bash script (Linux/macOS)
├── zcl.ps1            # PowerShell script (Windows)
├── install.sh         # Bash installer
├── install.ps1        # PowerShell installer
├── completions/       # Shell completions (bash/zsh/fish)
├── tests/             # BATS test suite
├── .github/workflows/ # CI/CD pipeline
├── Makefile           # Development commands
└── README.md          # Documentation
```

## Before Submitting

1. Run `make check` — ensure linting and tests pass
2. Update `VERSION` in both `zcl` and `zcl.ps1`
3. Follow existing code style (shellcheck-clean Bash)

## Code Style

- Bash: ShellCheck-clean, `set -euo pipefail`
- PowerShell: `Set-StrictMode`, camelCase functions
- Comments in English or Indonesian
- No external dependencies beyond `curl`/`wget`
