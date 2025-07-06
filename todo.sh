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
	local filtered_all=${1}
	if [ -z "$filtered_all" ]; then
		local project_path=$(find $HOME/workspaces -type d -mindepth 1 -maxdepth 1 | fzf)
		local filtered_project=$(basename "$project_path")
	fi
	local filtered_status=${2:-any}
	local count=0

	if [ ! -f "$TODO_FILE" ] || [ ! -s "$TODO_FILE" ]; then
		echo -e "${YELLOW}No tasks found to be listed.${NC}"
		return
	fi

	echo -e "\n${PURPLE}=== Todo List: [${filtered_project}:${filtered_status}]${NC}"
	echo ""

	# List header
	printf "${PURPLE}%-5s${NC} | ${PURPLE}%-20s${NC} | ${PURPLE}%-64s${NC}\n" "ID" "PROJECT" "TASK DESCRIPTION"
	echo "${LINE_96}"

	while IFS='|' read -r id status project description; do
		# Skip empty lines.
		[ -z "$id" ] && continue

		# Apply filters.
		# By project.
		if [ -n "$filtered_project" ] && [ "$project" != "$filtered_project" ]; then
			continue
		fi
		# By status.
		if [ "$filtered_status" != "any" ] && [ "$status" != "$filtered_status" ]; then
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


main() {
	init

	case "$1" in
		"add")
			# add "task description" "status"
			add_task "$2" "$3"
			;;
		"list")
			list_tasks "$2" "$3"
			;;
		"done")
			mark_done "$2"
			;;
		"delete")
			delete_task "$2"
			;;
		*)
			echo -e "${RED}Unknown command: $1${NC}"
			exit 1
			;;
	esac
}

main "$@"

