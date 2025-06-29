#!/usr/bin/env bash

TASK_FILE="tasks.txt"

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

# Displays the tasks in a table format
echo "TASK BOARD"
echo "------------------------------------------------------------------------------------------"
printf "%-5s | %-40s | %-20s | %-10s\n" "Pos" "Task" "Project" "Status"
echo "------------------------------------------------------------------------------------------"
while IFS="|" read -r pos task_name project_name task_status; do
	# Trunca o nome da tarefa se for maior que 30 caracteres
	if [[ ${#task_name} -gt 40 ]]; then
		task_name="${task_name:0:37}..."
	fi
	printf "%-5s | ${YELLOW}%-40s${NC} | %-20s | %-10s\n" "$pos" "$task_name" "$project_name" "$task_status"
done < "$TASK_FILE"

echo "------------------------------------------------------------------------------------------"
