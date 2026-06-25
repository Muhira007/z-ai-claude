#!/usr/bin/env bash
#
# zcl installer.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Muhira007/z-ai-claude/main/install.sh | bash
#
# Options:
#   VERSION=v1.0.0  curl ... | VERSION=v1.0.0 bash     # Pin a version
#   DEST=/usr/local  curl ... | DEST=/usr/local bash    # Custom install dir
#
set -euo pipefail

REPO="https://raw.githubusercontent.com/Muhira007/z-ai-claude"
VERSION="${VERSION:-main}"
CMD_NAME="zcl"
BIN_DIR="${DEST:-$HOME/.local/bin}"
REPO_URL="${REPO}/${VERSION}"

# --- helpers -----------------------------------------------------------------
say()   { printf '%s\n' "$*" >&2; }
die()   { say "ERROR: $*"; exit 1; }

# --- pre-flight checks -------------------------------------------------------
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
  die "Need curl or wget to download zcl."
fi

# --- download function -------------------------------------------------------
download() {
  local url="$1" dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest" || die "Download failed: $url"
  else
    wget -qO "$dest" "$url" || die "Download failed: $url"
  fi
}

# --- install -----------------------------------------------------------------
mkdir -p "$BIN_DIR"

say "Installing $CMD_NAME ($VERSION) to $BIN_DIR ..."
download "$REPO_URL/$CMD_NAME" "$BIN_DIR/$CMD_NAME"
chmod +x "$BIN_DIR/$CMD_NAME"

# --- checksum (informational) ------------------------------------------------
CHECKSUM_URL="${REPO}/${VERSION}/checksums.txt"
if command -v sha256sum >/dev/null 2>&1; then
  if command -v curl >/dev/null 2>&1; then
    if curl -fsSL --head "$CHECKSUM_URL" 2>/dev/null | grep -q '200 OK'; then
      say "Checksums available at: $CHECKSUM_URL"
      say "Verify with: curl -fsSL $CHECKSUM_URL | sha256sum -c --ignore-missing"
    fi
  fi
fi

# --- post-install ------------------------------------------------------------
say "Installed: $BIN_DIR/$CMD_NAME"

case ":$PATH:" in
  *":$BIN_DIR:"*)
    say "Ready. Run: $CMD_NAME"
    ;;
  *)
    say ""
    say "NOTE: $BIN_DIR is not on your PATH."
    say "Add this to your shell profile (~/.bashrc or ~/.zshrc):"
    say "  export PATH=\"$BIN_DIR:\$PATH\""
    say "Then open a new terminal and run: $CMD_NAME"
    ;;
esac
