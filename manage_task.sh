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

# Update task status to done
mark_task_done() {
        sed -i '' "s/^$task_pos|.*$/$task_pos|$task_name|$project_name|Done/" "$TASK_FILE"
	echo -e "\n${GREEN}Task marked as done.${NC}"
}

# Prompt user to select a task by position
echo -e "\n${BLUE}Enter the position of the task you want to manage: ${NC}"
read task_pos

# Find the task by position
task_line=$(grep "^$task_pos|" "$TASK_FILE")
echo -e "$task_line"

if [[ -z "$task_line" ]]; then
    echo -e "${RED}Task not found.${NC}"
    exit 1
fi

# Display task details
IFS="|" read -r pos task_name project_name task_status <<< "$task_line"
echo -e "\n${BLUE}Task Details:${NC}"
echo -e "Position: $pos"
echo -e "Task Name: ${YELLOW}${task_name}${NC}"
echo -e "Project: $project_name"
echo -e "Status: $task_status"

# Prompt user for action
echo -e "\n${BLUE}What would you like to do?${NC}"
echo "1. Edit Task"
echo "2. Delete Task"
echo "3. Mark as Done"
echo "4. Exit"
read action

case $action in
    1)
        # Edit task
        echo -e "\n${BLUE}Enter new task name (leave blank to keep current): ${NC}"
        read new_task_name
        echo -e "\n${BLUE}Enter new project name (leave blank to keep current): ${NC}"
        read new_project_name
        echo -e "\n${BLUE}Enter new task status (leave blank to keep current): ${NC}"
        read new_task_status

        # Update fields if new values are provided
        new_task_name=${new_task_name:-$task_name}
        new_project_name=${new_project_name:-$project_name}
        new_task_status=${new_task_status:-$task_status}

        # Replace the task in the file
        sed -i '' "s/^$task_pos|.*$/$task_pos|$new_task_name|$new_project_name|$new_task_status/" "$TASK_FILE"
        echo -e "\n${GREEN}Task updated successfully.${NC}"
        ;;
    2)
        # Delete task
        sed -i '' "/^$task_pos|/d" "$TASK_FILE"
        echo -e "\n${GREEN}Task deleted successfully.${NC}"
        ;;
    3)
	# Mark task as done
	
	mark_task_done
	;;

    4)
        echo -e "\n${GREEN}Exiting.${NC}"
        ;;
    *)
        echo -e "${RED}Invalid option.${NC}"
        ;;
esac
