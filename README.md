# bash-todo-list

My personal todo-list app implemented in bash.

## What it can do

- List all tasks.
- List pending tasks.
- Add a new task.
- Edit an existing task.
- Delete a task.
- Change position of a task.

### Task fields

- Task name;
- Project (workspaces folder);
- Status

## Features Descriptions

### Task Storage

Tasks are stored in a `tasks.txt` file, where each line represents a task. Fields within a task are separated by delimiters such as `|`.

### Script for Adding Tasks

A Bash script is used to add new tasks. The script prompts the user for the required fields and saves the task in the `tasks.txt` file.

### Listing Tasks

The script reads the `tasks.txt` file and displays a formatted list of tasks to the user.
