.PHONY: lint test check clean install

# --- Linting -----------------------------------------------------------------
SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)

lint:
ifndef SHELLCHECK
	$(error "shellcheck not found. Install: https://github.com/koalaman/shellcheck")
endif
	$(SHELLCHECK) zcl install.sh

# --- Tests -------------------------------------------------------------------
BATS := $(shell command -v bats 2>/dev/null)

test:
ifndef BATS
	$(error "bats not found. Install: https://github.com/bats-core/bats-core")
endif
	$(BATS) tests/

# --- Combined check ----------------------------------------------------------
check: lint test
	@echo "All checks passed."

# --- Clean -------------------------------------------------------------------
clean:
	rm -f tests/*.log

# --- Install (local dev) -----------------------------------------------------
install:
	cp zcl ~/.local/bin/zcl
	chmod +x ~/.local/bin/zcl
	@echo "Installed to ~/.local/bin/zcl"

# --- Shell completions (local dev) -------------------------------------------
completions: completions/zcl.bash completions/zcl.zsh completions/zcl.fish
	@echo "Completions generated."

# --- Version bump ------------------------------------------------------------
bump:
	@read -p "New version (e.g. 1.1.0): " v; \
	sed -i "s/^VERSION=.*/VERSION=\"$$v\"/" zcl; \
	sed -i "s/Version\s*=\s*'.*'/Version      = '$$v'/" zcl.ps1; \
	echo "Version bumped to $$v"
