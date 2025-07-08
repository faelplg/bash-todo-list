#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_help() {
    echo -e "${CYAN}Todo List - Workspaces Projects Manager${NC}"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo -e "  ${GREEN}add${NC}        Add a new todo item"
    echo -e "  ${GREEN}list${NC}       List all todos (default)"
    echo -e "  ${GREEN}done${NC}       Mark todo as completed"
    echo -e "  ${GREEN}delete${NC}     Delete a todo item"
    #echo -e "  ${GREEN}edit${NC}       Edit a todo item"
    #echo -e "  ${GREEN}project${NC}    Manage projects"
    #echo -e "  ${GREEN}search${NC}     Search todos"
    #echo -e "  ${GREEN}stats${NC}      Show statistics"
    echo -e "  ${GREEN}help${NC}       Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 add \"Fix authentication bug\" done"
    echo "  $0 list --project=all --status=pending"
    echo "  $0 done 1"
}
