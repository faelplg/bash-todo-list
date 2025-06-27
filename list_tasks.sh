#!/usr/bin/env bash

TASK_FILE="tasks.txt"

# Ensures that the script only proceeds if the $TASK_FILE exists
# and contains data. If the file is missing or empty, it gracefully
# exits after notifying the user.
if [[ ! -f "$TASK_FILE" || ! -s "$TASK_FILE" ]]; then
	echo "No task found."
	exit 0
fi

# Displays the tasks in a table format
echo "Tasks list:"
echo "------------------------------"
while IFS="|" read -r task_name project_name task_status; do
	echo "Tarefa: $task_name"
	echo "Projeto: $project_name"
	echo "Status: $task_status"
	echo "------------------------------"
done < "$TASK_FILE"

