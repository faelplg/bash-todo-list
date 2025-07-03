#!/usr/bin/env bash

# General settings
# Constants
WORKSPACE="$HOME/workspaces"
TODO_DIR="$WORKSPACE/.todo"
TODO_FILE="$TODO_DIR/tasks.txt"
#PROJECT_FOLDER=$(find $HOME/workspaces -type d -mindepth 1 -maxdepth 1 | fzf)
#PROJECT_NAME=$(basename "$PROJECT_FOLDER")
#PROJECT_FILE="$PROJECT_FOLDER/tasks.txt"
# Status
STATUS_PENDING="🟡"
STATUS_DONE="🟢"
# Styles
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#echo -e "${BLUE}Project folder:${NC} ${project_folder}"
#echo -e "${BLUE}Project name:${NC} ${project_name}\n"

init() {
	echo -e "${YELLOW}Initializing...${NC}"
	# Checks if exists .todo folder in the workspace
	if [ ! -d "$TODO_DIR" ]; then
		mkdir -p "$TODO_DIR"
		touch "$TODO_FILE"
		echo -e "${GREEN}TODO directory initialized at ${TODO_DIR}${NC}"
	fi
	# Check if exists tasks.txt in the project folder
	#if [ ! -f "$TODO_FILE" -o ! -s "$TODO_FILE" ]; then
	#	echo "No task found." >&2
	#fi
}

add_task() {
	local project_path=$(find $HOME/workspaces -type d -mindepth 1 -maxdepth 1 | fzf)
	local project=$(basename "$project_path")
	local description="$1"
	local status="${2:-Pending}"

	case "$status" in
		"pending") status_icon="$STATUS_PENDING" ;;
		"done") status_icon="$STATUS_DONE" ;;
		*) status_icon="$STATUS_PENDING" ;;
	esac

	local next_id=1
	if [ -f "$TODO_FILE" ] && [ -s "$TODO_FILE" ]; then
		next_id=$(tail -1 "$TODO_FILE" | cut -d'|' -f1)
		next_id=$((next_id + 1))
	fi

	echo "${next_id}|${status_icon}|${project}|${description}"
}

# Main function
main() {
	init

	case "$1" in
		"add")
			add_task "$2" "$3"
			;;
		*)
			echo -e "${RED}Unknown command: $1${NC}"
			exit 1
			;;
	esac
}

main "$@"

