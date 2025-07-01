#!/usr/bin/env bash

TASK_FILE="tasks.txt"

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Use fzf to select a project folder
echo -e "\n${BLUE}Select a project folder:${NC}"
project_name=$(find $HOME/workspaces -type d -mindepth 1 -maxdepth 1 | fzf)

if [[ -z "$project_name" ]]; then
	echo -e "${RED}No project selected. Exiting.${NC}"
	exit 1
fi

# Extract the folder name from the full path
project_name=$(basename "$project_name")

# Requests new task data
echo -e "\n${BLUE}Enter task name: ${NC}"
read task_name

task_status="Pending"

# Calculate the position for the new task
if [[ -f "$TASK_FILE" && -s "$TASK_FILE" ]]; then
	pos=$(tail -n 1 "$TASK_FILE" | cut -d '|' -f 1)
	pos=$((pos + 1))
else
	pos=1
fi

# Add task in the file
echo "$pos|$task_name|$project_name|$task_status" >> "$TASK_FILE"

echo -e "\n${GREEN}Task added successfully.${NC}"
