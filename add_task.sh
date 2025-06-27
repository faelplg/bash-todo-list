#!/usr/bin/env bash

TASK_FILE="tasks.txt"

# Requests new task data
echo "Enter task name: "
read task_name

echo "Enter project name: "
read project_name

echo "Enter task status: "
read task_status

# Add task in the file
echo "$task_name|$project_name|$task_status" >> "$TASK_FILE"

echo "Task added successfully."
