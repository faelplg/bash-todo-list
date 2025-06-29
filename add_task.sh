#!/usr/bin/env bash

TASK_FILE="tasks.txt"

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Requests new task data
echo -e "\n${BLUE}Enter task name: ${NC}"
read task_name

echo  -e "\n${BLUE}Enter project name: ${NC}"
read project_name

echo  -e "\n${BLUE}Enter task status: ${NC}"
read task_status

# Add task in the file
echo "$task_name|$project_name|$task_status" >> "$TASK_FILE"

echo -e "\n${GREEN}Task added successfully.${NC}"
