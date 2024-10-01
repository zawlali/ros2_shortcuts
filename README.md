# ROS2 Utility Scripts

This README provides instructions on how to use a set of ROS2 utility scripts designed to enhance your ROS2 development workflow. These scripts offer convenient shortcuts for managing workspaces, topics, and packages, aligning closely with ROS2's command-line conventions.

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
  - [Switching to a Workspace](#switching-to-a-workspace)
  - [Managing Workspace Shortcuts](#managing-workspace-shortcuts)
    - [Add a Shortcut](#add-a-shortcut)
    - [Remove a Shortcut](#remove-a-shortcut)
    - [List Shortcuts](#list-shortcuts)
  - [Topic Utilities](#topic-utilities)
    - [`ros2 topic ps`](#ros2-topic-ps)
    - [`ros2 topic publishers`](#ros2-topic-publishers)
    - [`ros2 topic subscribers`](#ros2-topic-subscribers)
  - [Package Utilities](#package-utilities)
    - [`ros2 pkg list_prefixes`](#ros2-pkg-list_prefixes)
- [Autocomplete](#autocomplete)
- [Examples](#examples)
- [Shortcut Commands Summary](#shortcut-commands-summary)

## Introduction

These ROS2 utility scripts provide the following features:

- Quickly switch between ROS2 workspaces using shortcuts.
- Manage workspace shortcuts (add, remove, list).
- List all topics with their publishers and subscribers.
- Retrieve publishers or subscribers for a specific topic.
- List all ROS2 packages with their installation prefixes.
- Autocomplete support for enhanced user experience.

## Installation

1. **Download the Script**: Save the script provided into a file, for example, `ros2_utilities.sh`.

2. **Make the Script Executable** (optional):

   ```bash
   chmod +x ros2_utilities.sh
   ```

3. **Source the Script**: Add the following line to your shell configuration file (e.g., `.bashrc`, `.zshrc`):

   ```bash
   source /path/to/ros2_utilities.sh
   ```

   Replace `/path/to/ros2_utilities.sh` with the actual path to the script.

4. **Reload Your Shell Configuration**:

   ```bash
   source ~/.bashrc   # For bash users
   # or
   source ~/.zshrc    # For zsh users
   ```

   This step ensures that the functions and aliases are available in your current shell session.

## Usage

### Switching to a Workspace

You can switch to a ROS2 workspace in two ways:

#### Using the Shortcut Name Directly

Simply type the shortcut name assigned to your workspace:

```bash
my_workspace
```

This command switches to the workspace associated with `my_workspace` and sources its environment.

#### Using the ROS2 Command Structure

Alternatively, use the following command:

```bash
ros2 ws use <shortcut>
```

Example:

```bash
ros2 ws use my_workspace
```

### Managing Workspace Shortcuts

Before switching to a workspace using a shortcut, you need to add it to your shortcuts list.

#### Add a Shortcut

```bash
ros2 ws shortcut add <workspace_path> <shortcut>
```

- `<workspace_path>`: The absolute or relative path to your ROS2 workspace.
- `<shortcut>`: The name you want to assign as a shortcut.

**Example:**

```bash
ros2 ws shortcut add ~/ros2_my_workspace my_workspace
```

#### Remove a Shortcut

```bash
ros2 ws shortcut remove <shortcut>
```

**Example:**

```bash
ros2 ws shortcut remove my_workspace
```

#### List Shortcuts

```bash
ros2 ws shortcut list
```

This command displays all the workspace shortcuts you have defined.

### Topic Utilities

#### `ros2 topic ps`

Lists all topics along with their publishers and subscribers.

```bash
ros2 topic ps
```

**Output Example:**

```
Topic: /example_topic
  Publishers:
    /publisher_node
  Subscribers:
    /subscriber_node
```

#### `ros2 topic publishers`

Displays all publishers for a specific topic.

```bash
ros2 topic publishers <topic_name>
```

**Example:**

```bash
ros2 topic publishers /example_topic
```

**Output:**

```
Publishers for /example_topic:
    /publisher_node
```

#### `ros2 topic subscribers`

Displays all subscribers for a specific topic.

```bash
ros2 topic subscribers <topic_name>
```

**Example:**

```bash
ros2 topic subscribers /example_topic
```

**Output:**

```
Subscribers for /example_topic:
    /subscriber_node
```

### Package Utilities

#### `ros2 pkg list_prefixes`

Lists all ROS2 packages along with their installation prefixes.

```bash
ros2 pkg list_prefixes
```

**Output Example:**

```
package_1: /opt/ros/foxy
package_2: /home/user/ros2_ws/install/package_2
```

## Autocomplete

The scripts include autocomplete functionality for:

- Workspace shortcuts when using `ros2 ws use` and when typing the shortcut names directly.
- Actions (`add`, `remove`, `list`) when using `ros2 ws shortcut`.
- Topic names when using `ros2 topic publishers` and `ros2 topic subscribers`.

**Note:** Autocomplete will be available after sourcing the script and may require restarting your terminal.

## Examples

1. **Adding a Workspace Shortcut:**

   ```bash
   ros2 ws shortcut add ~/ros2_projects/my_ws my_workspace
   ```

2. **Switching to a Workspace Using Shortcut Name:**

   ```bash
   my_workspace
   ```

3. **Switching to a Workspace Using ROS2 Command:**

   ```bash
   ros2 ws use my_workspace
   ```

4. **Listing All Workspace Shortcuts:**

   ```bash
   ros2 ws shortcut list
   ```

5. **Listing Topics with Publishers and Subscribers:**

   ```bash
   ros2 topic ps
   ```

6. **Listing Publishers for a Topic:**

   ```bash
   ros2 topic publishers /example_topic
   ```

7. **Listing Subscribers for a Topic:**

   ```bash
   ros2 topic subscribers /example_topic
   ```

8. **Listing Packages with Prefixes:**

   ```bash
   ros2 pkg list_prefixes
   ```

## Shortcut Commands Summary

| Command                                   | Description                                                      |
|-------------------------------------------|------------------------------------------------------------------|
| `ros2 ws use <shortcut>`                  | Switch to the workspace associated with `<shortcut>`.            |
| `<shortcut>`                              | Type the shortcut name directly to switch to its workspace.      |
| `ros2 ws shortcut add <path> <shortcut>`  | Add a new workspace shortcut.                                    |
| `ros2 ws shortcut remove <shortcut>`      | Remove an existing workspace shortcut.                           |
| `ros2 ws shortcut list`                   | List all defined workspace shortcuts.                            |
| `ros2 topic ps`                           | List all topics with their publishers and subscribers.           |
| `ros2 topic publishers <topic_name>`      | Show all publishers for the specified topic.                     |
| `ros2 topic subscribers <topic_name>`     | Show all subscribers for the specified topic.                    |
| `ros2 pkg list_prefixes`                  | List all ROS2 packages with their installation prefixes.         |

## Conclusion

These utility scripts are designed to streamline your ROS2 development tasks by providing quick access to common operations. By integrating closely with ROS2's command-line structure and adding convenient features like workspace shortcuts and autocomplete, they aim to enhance productivity and ease of use.

Feel free to customize and extend these scripts to suit your specific workflow needs. Happy coding!

# Shortcuts Summary Table

| Shortcut Command                         | Description                                                 |
|------------------------------------------|-------------------------------------------------------------|
| `ros2 ws use <shortcut>`                 | Switches to the workspace associated with `<shortcut>`.     |
| `<shortcut>`                             | Directly switches to the workspace when typing the shortcut name. |
| `ros2 ws shortcut add <path> <shortcut>` | Adds a new shortcut for a workspace located at `<path>`.    |
| `ros2 ws shortcut remove <shortcut>`     | Removes the shortcut `<shortcut>` from your shortcuts list. |
| `ros2 ws shortcut list`                  | Displays all your current workspace shortcuts.              |
| `ros2 topic ps`                          | Lists all topics along with their publishers and subscribers. |
| `ros2 topic publishers <topic_name>`     | Lists all publishers for the topic `<topic_name>`.          |
| `ros2 topic subscribers <topic_name>`    | Lists all subscribers for the topic `<topic_name>`.         |
| `ros2 pkg list_prefixes`                 | Lists all ROS2 packages with their installation prefixes.   |

---

**Note:** Replace `<shortcut>`, `<workspace_path>`, and `<topic_name>` with your actual shortcut names, workspace paths, and topic names, respectively.

If you have any questions or need further assistance, feel free to reach out!
