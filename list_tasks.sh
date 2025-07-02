#!/usr/bin/env bash

# Define constants
TASK_FILE="tasks.txt"

# Define main variables
mode="--all"
line_div="-----------------------------------------------------------------------------------------------"

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensures that the script only proceeds if the $TASK_FILE exists
# and contains data. If the file is missing or empty, it gracefully
# exits after notifying the user.
if [[ ! -f "$TASK_FILE" || ! -s "$TASK_FILE" ]]; then
	echo "No task found."
	exit 0
fi

# Get listing mode
if [[ $# -gt 0 ]]; then
	mode=$1
fi

# Displays the tasks in a table format
echo "TASK BOARD"
echo "${line_div}"
printf "%-5s | %-50s | %-20s | %-15s\n" "Pos" "Task" "Project" "Status"
echo "${line_div}"

while IFS="|" read -r pos task_name project_name task_status; do
	# Truncate task_name to a max 50 length
	if [[ ${#task_name} -gt 50 ]]; then
		task_name="${task_name:0:47}..."
	fi
	
	case $mode in
		"--all")
			printf "%-5s | ${YELLOW}%-50s${NC} | %-20s | %-15s\n" "$pos" "$task_name" "$project_name" "$task_status"
			;;
		"--pending")
			if [[ ${task_status} == "Pending" ]]; then
				printf "%-5s | ${YELLOW}%-50s${NC} | %-20s | %-15s\n" "$pos" "$task_name" "$project_name" "$task_status"
			fi
			;;
		*)
			echo -e "${RED}Invalid parameter.${NC}"
			echo "${line_div}"
			exit 1
        		;;
	esac
done < "$TASK_FILE"

echo "${line_div}"
