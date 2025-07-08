# Bash Todo List

A lightweight and efficient command-line todo list manager written in Bash. This tool is designed to help you organize and manage tasks across multiple projects in your workspace.

## Features

- **Task Management**:

  - Add, list, edit, and delete tasks.
  - Mark tasks as completed.
  - Normalize task IDs for consistency.
  - Filter tasks by project or status.

- **Project Integration**:

  - Automatically integrates with your workspace projects.
  - Interactive project selection using `fzf`.

- **Task Storage**:
  - Tasks are stored in a simple `tasks.txt` file for easy management and portability.

## Task Structure

Each task consists of the following fields:

- **ID**: A unique identifier for the task.
- **Status**: Current status of the task (`🟡 pending` or `🟢 done`).
- **Project**: The associated project folder.
- **Description**: A brief description of the task.

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd bash-todo-list
```

2. Run the installation script:

`./install.sh`

3. Add the installation directory to your `PATH` (if not already added):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Usage

### Add Task

Add new task to the Todo List:

`todo add "Task description" <task_status>`

- Task description: A brief description of the task.
- Task status: Optional. Defaults to `pending`.

### Mark Task as Done

Mark a task as completed:

`todo done <task_id>`

- `task_id`: The ID of the task to mark as done.

### Delete a Task

Delete a task from the list:

`todo delete <task_id>`

- `task_id`: The ID of the task to delete.

### Normalize Task IDs

Reassign sequential IDs to tasks for consistency:

`todo normalize`

### Help

Display the help menu:

`todo help`

## Examples

Add a new task:

`todo add "Fix authentication bug" pending`

List all pending tasks for a specific project:

`todo list --project=my_project --status=pending`

Mark a task as done:

`todo done 3`

Delete a task:

`todo delete 5`

## Task Storage Format

Tasks are stored in a `tasks.txt` file located in the `.todo` directory within your workspace. Each task is represented as a single line with the following format:

`<ID>|<STATUS>|<PROJECT>|<DESCRIPTION>`

Example:

```
1|pending|my_project|Fix authentication bug
2|done|my_project|Write unit tests
```

## Dependencies

- `fzf`: For interactive project selection. Install it using: `brew install fzf`

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve the project.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
