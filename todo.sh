#!/usr/bin/env bash

# General settings
# Constants
WORKSPACE="$HOME/workspaces"
TODO_DIR="$WORKSPACE/.todo"
TODO_FILE="$TODO_DIR/tasks.txt"
LINE_96="-------------------------------------------------------------------------------------------------"
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

source "$(dirname "$0")/help.sh"

init() {
	# Checks if exists .todo folder in the workspace.
	if [ ! -d "$TODO_DIR" ]; then
		echo -e "${YELLOW}Initializing...${NC}"
		mkdir -p "$TODO_DIR"
		touch "$TODO_FILE"
		echo -e "${GREEN}TODO directory initialized at ${TODO_DIR}${NC}\n"
	fi
}

add_task() {
	local project_path=$(find $HOME/workspaces -type d -mindepth 1 -maxdepth 1 | fzf)
	local project=$(basename "$project_path")
	local description="$1"
	local status="${2:-pending}"	

	local next_id=1
	if [ -f "$TODO_FILE" ] && [ -s "$TODO_FILE" ]; then
		next_id=$(tail -1 "$TODO_FILE" | cut -d'|' -f1)
		next_id=$((next_id + 1))
	fi

	echo "${next_id}|${status}|${project}|${description}" >> "$TODO_FILE"
	echo -e "${GREEN}Task (ID: ${next_id}) added successfully!${NC}"
}

list_tasks() {
	local project_filter="$1"
	local status_filter="$2"

	if [[ "$project_filter" = "select" ]]; then
		local project_path=$(find $HOME/workspaces -type d -mindepth 1 -maxdepth 1 | fzf)
		local project_filter=$(basename "$project_path")
	fi
	local count=0

	if [ ! -f "$TODO_FILE" ] || [ ! -s "$TODO_FILE" ]; then
		echo -e "${YELLOW}No tasks found to be listed.${NC}"
		return
	fi

	echo -e "\n${PURPLE}=== Todo List: [${project_filter}:${status_filter}]${NC}"
	echo ""

	# List header
	printf "${PURPLE}%-5s${NC} | ${PURPLE}%-20s${NC} | ${PURPLE}%-64s${NC}\n" "ID" "PROJECT" "TASK DESCRIPTION"
	echo "${LINE_96}"

	while IFS='|' read -r id status project description; do
		# Skip empty lines.
		[ -z "$id" ] && continue

		# Apply filters.
		# By project.
		if [ "$project_filter" != "all" ] && [ "$project" != "$project_filter" ]; then
			continue
		fi
		# By status.
		if [ "$status_filter" != "any" ] && [ "$status" != "$status_filter" ]; then
			continue
		fi

		# Truncate description if too long.
		if [ ${#description} -gt 60 ]; then
			description="${description:0:57}..."
		fi
		
		# Select the status icon.
		case "$status" in
			"done") status_icon="$STATUS_DONE" ;;
			*) status_icon="$STATUS_PENDING" ;;
		esac

		printf "%-5s | %-20s | %-66s |\n" "$id" "$project" "$status_icon $description"
		count=$((count+1))
	done < "$TODO_FILE"
	if [ "$count" -eq 0 ]; then
		echo -e "${YELLOW}Empty list.${NC}"
	fi
	echo "${LINE_96}"
	echo "$count task(s) found."
}

prepare_list() {
	# Filter variables
	local project_filter="select"
	local status_filter="any"

	# Manipulate arguments
	if [[ -n "$1" ]]; then
		while [[ "$#" -gt 0 ]]; do
			case "$1" in
				--project=*)
					project_filter="${1#*=}" # Extract the value after '='
					;;
				--status=*)
					status_filter="${1#*=}" # Extract the value after '='
					;;
				*)
					echo -e "${RED}Unknown argument: $1${NC}"
					# return 1
					;;
			esac
			shift # Continue to next argument
		done
	fi
	# Debug
	echo -e "${YELLOW}Project filter: ${project_filter}${NC}"
	echo -e "${YELLOW}Status filter: ${status_filter}${NC}"

	list_tasks "$project_filter" "$status_filter"
}

mark_done() {
	local task_id="$1"

	# Check if a Task ID is informed.
	if [ -z "$task_id" ]; then
		echo -e "${RED}Error: Task ID is required.${NC}"
		return 1
	fi

	# Check if the Todo file have tasks.
	if [ -s "$TASK_FILE" ]; then
		echo -e "${RED}Error: No tasks found.${NC}"
		return 1
	fi

	# Check if Task with searched ID exists.
	if ! grep -q "^${task_id}|" "${TODO_FILE}"; then
		echo -e "${RED}Error: Task with ID $task_id not found.${NC}"
		return 1
	fi

	# Update task status.
	local tempf=$(mktemp)
	while IFS='|' read -r id status project description; do
		if [ "$id" = "$task_id" ]; then
			echo "${id}|done|${project}|${description}" >> $tempf
			if [ "$status" = "done" ]; then
				echo -e "${GREEN}Task already marked as completed!${NC}"
			else
				echo -e "${GREEN}Task marked as completed!${NC}"
			fi
		else
			echo "${id}|${status}|${project}|${description}" >> $tempf
		fi
	done < "$TODO_FILE"
	mv "$tempf" "$TODO_FILE"
}

delete_task() {
	local task_id="$1"

	# Check if a Task ID is informed.
	if [ -z "$task_id" ]; then
		echo -e "${RED}Error: Task ID is required.${NC}"
		return 1
	fi

	# Check if the Todo file have tasks.
	if [ -s "$TASK_FILE" ]; then
		echo -e "${RED}Error: No tasks found.${NC}"
		return 1
	fi

	# Check if Task with searched ID exists.
	if ! grep -q "^${task_id}|" "${TODO_FILE}"; then
		echo -e "${RED}Error: Task with ID $task_id not found.${NC}"
		return 1
	fi

	# Confirm deletion
	echo -e "${YELLOW}Are you sure you want to delete task $task_id? (y/N)${NC}"
	read -r confirmation

	if [ "$confirmation" = "y" ] || [ "$confirmaton" = "Y" ]; then
		local tempf=$(mktemp)
		grep -v "^${task_id}|" "$TODO_FILE" > "$tempf"
		mv "$tempf" "$TODO_FILE"
		echo -e "${GREEN}Task $task_id deleted successfully!${NC}"
	else
		echo -e "${YELLOW}Deletion cancelled.${NC}"
	fi
}

normalize_ids() {
	# Check if the Todo file has tasks.
	if [ ! -s "$TODO_FILE" ]; then
		echo -e "${RED}No tasks found.${NC}"
		return 1
	fi

	local tempf=$(mktemp)
	local new_id=1

	# Read the tasks and reassign sequential IDs.
	while IFS='|' read -r id status project description; do
		# Skip  empty lines.
		[ -z "$id" ] && continue

		echo "${new_id}|${status}|${project}|${description}" >> "$tempf"
		new_id=$((new_id + 1))
	done < "$TODO_FILE"

	# Replace the original file.
	mv "$tempf" "$TODO_FILE"
	echo -e "${GREEN}IDs normalized.${NC}"
}

main() {
	init

	case "$1" in
		"add")
			# add "task description" "status"
			add_task "$2" "$3"
			;;
		"list")
			prepare_list "$2" "$3"
			;;
		"done")
			mark_done "$2"
			;;
		"delete")
			delete_task "$2"
			;;
		"normalize")
			normalize_ids
			;;
		"help")
			show_help
			;;
		*)
			echo -e "${RED}Unknown command $1${NC}"
			exit 1
			;;
	esac
}

main "$@"

