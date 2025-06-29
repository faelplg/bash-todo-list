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
echo "--------------------------------------------------------------------------------"
printf "%-40s | %-20s | %-10s\n" "Tarefa" "Projeto" "Status"
echo "--------------------------------------------------------------------------------"
while IFS="|" read -r task_name project_name task_status; do
	# Trunca o nome da tarefa se for maior que 30 caracteres
	if [[ ${#task_name} -gt 40 ]]; then
		task_name="${task_name:0:37}..."
	fi
	printf "%-40s | %-20s | %-10s\n" "$task_name" "$project_name" "$task_status"
done < "$TASK_FILE"

echo "--------------------------------------------------------------------------------"
