#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="todo"

# Styles
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing Todo List application...${NC}"

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Copy the script and system files
cp "$SCRIPT_DIR/todo.sh" "$INSTALL_DIR/$SCRIPT_NAME"
cp "$SCRIPT_DIR/help.sh" "$INSTALL_DIR/"

# Make it executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo -e "${GREEN}Todo List installed!${NC}"
echo ""
echo "Make sure $INSTALL_DIR is in your PATH."
echo -e "You can add this to your ${CYAN}~/.zshrc${NC} or ${CYAN}~/.bashrc${NC}:"
echo -e 'export PATH="$HOME/.local/bin:$PATH"'
echo ""
echo "Usage: $SCRIPT_NAME [command] [options]"
echo "Example: $SCRIPT_NAME add \"Fix authentication bug\" high neovim"
echo ""
echo "Run '$SCRIPT_NAME help' for more information."
