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

## Features descriptions

1. **Task Storage**

   - Use a `tasks.txt` file where each line represents a task, with fields separated by delimiters such as `|`.

2. **Script for Adding Tasks**

   - Create a Bash script to add new tasks. The script should prompt the user for the required fields and save the task in the `tasks.txt` file.

3. **List Tasks**
   - Read the `tasks.txt` file and show a formatted tasks list to the user.
