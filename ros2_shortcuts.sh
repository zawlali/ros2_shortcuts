#!/bin/bash

# File to store ROS2 workspace shortcuts
ROS2_SHORTCUTS_FILE="$HOME/.ros2_shortcuts"

# Function to find the root of a ROS2 workspace
_find_ros2_workspace_root() {
    local dir="$1"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/install/setup.bash" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Function to create alias for each shortcut
_create_ros2_aliases() {
    if [[ -f "$ROS2_SHORTCUTS_FILE" ]]; then
        while IFS=':' read -r shortcut workspace; do
            alias "$shortcut"="ros2_ws_use $shortcut"
        done < "$ROS2_SHORTCUTS_FILE"
    fi
}

# Function to use a ROS2 workspace shortcut
ros2_ws_use() {
    local shortcut=$1
    if [[ -z $shortcut ]]; then
        echo "Usage: ros2 ws use <shortcut>"
        return 1
    fi

    local workspace=$(grep "^$shortcut:" "$ROS2_SHORTCUTS_FILE" | cut -d':' -f2)
    if [[ -z $workspace ]]; then
        echo "Shortcut '$shortcut' not found"
        return 1
    fi

    local workspace_root=$(_find_ros2_workspace_root "$workspace")
    if [[ -z $workspace_root ]]; then
        echo "Error: Could not find a valid ROS2 workspace root for '$workspace'"
        return 1
    fi

    cd "$workspace_root" && source install/setup.bash
    echo "Switched to workspace: $workspace_root"
}

# Function to manage ROS2 workspace shortcuts
ros2_ws_shortcut() {
    local action=$1
    local workspace=$2
    local shortcut=$3

    case $action in
        add)
            if [[ -z $workspace || -z $shortcut ]]; then
                echo "Usage: ros2 ws shortcut add <workspace_path> <shortcut>"
                return 1
            fi
            workspace=$(realpath "$workspace")
            local workspace_root=$(_find_ros2_workspace_root "$workspace")
            if [[ -z $workspace_root ]]; then
                echo "Error: $workspace does not appear to be a valid ROS2 workspace"
                return 1
            fi
            echo "$shortcut:$workspace_root" >> "$ROS2_SHORTCUTS_FILE"
            echo "Shortcut '$shortcut' added for workspace '$workspace_root'"
            _create_ros2_aliases
            ;;
        remove)
            if [[ -z $shortcut ]]; then
                echo "Usage: ros2 ws shortcut remove <shortcut>"
                return 1
            fi
            if grep -q "^$shortcut:" "$ROS2_SHORTCUTS_FILE"; then
                sed -i "/^$shortcut:/d" "$ROS2_SHORTCUTS_FILE"
                echo "Shortcut '$shortcut' removed"
                unalias "$shortcut" 2>/dev/null
            else
                echo "Error: Shortcut '$shortcut' not found"
            fi
            ;;
        list)
            if [[ ! -f "$ROS2_SHORTCUTS_FILE" ]]; then
                echo "No shortcuts defined"
            else
                echo "ROS2 Workspace Shortcuts:"
                cat "$ROS2_SHORTCUTS_FILE"
            fi
            ;;
        *)
            echo "Usage: ros2 ws shortcut <add|remove|list> [workspace_path] [shortcut]"
            return 1
            ;;
    esac
}

# Function to extract publisher/subscriber info
_ros2_extract_info() {
    local topic=$1
    local info_type=$2

    ros2 topic info "$topic" -v | awk -v type="$info_type" '
    $1 == type && $2 == "count:" { count = $3 }
    count > 0 && $1 == "Node" && $2 == "name:" {
        print "    " $3
        count--
    }'
}

# Function to list all topics with publishers and subscribers
ros2_topic_ps() {
    local topics=$(ros2 topic list)

    for topic in $topics; do
        echo "Topic: $topic"

        # Get publishers
        local publishers=$(_ros2_extract_info "$topic" "Publisher")
        if [ -n "$publishers" ]; then
            echo "  Publishers:"
            echo "$publishers"
        fi

        # Get subscribers
        local subscribers=$(_ros2_extract_info "$topic" "Subscription")
        if [ -n "$subscribers" ]; then
            echo "  Subscribers:"
            echo "$subscribers"
        fi

        echo ""
    done
}

# Function to get publishers for a specific topic
ros2_topic_publishers() {
    local topic=$1
    if [ -z "$topic" ]; then
        echo "Usage: ros2 topic publishers <topic_name>"
        return 1
    fi
    echo "Publishers for $topic:"
    _ros2_extract_info "$topic" "Publisher"
}

# Function to get subscribers for a specific topic
ros2_topic_subscribers() {
    local topic=$1
    if [ -z "$topic" ]; then
        echo "Usage: ros2 topic subscribers <topic_name>"
        return 1
    fi
    echo "Subscribers for $topic:"
    _ros2_extract_info "$topic" "Subscription"
}

# Function to list all ROS2 packages and their prefixes
ros2_pkg_list_prefixes() {
    echo "Listing all ROS2 packages and their prefixes:"
    ros2 pkg list | while read -r package; do
        prefix=$(ros2 pkg prefix "$package")
        echo "$package: $prefix"
    done
}

# Autocomplete function for ros2_ws_shortcut
_ros2_ws_shortcut_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local actions="add remove list"
    if [[ $COMP_CWORD -eq 3 && ${COMP_WORDS[2]} == "remove" ]]; then
        local shortcuts=$(cut -d':' -f1 "$ROS2_SHORTCUTS_FILE" 2>/dev/null)
        COMPREPLY=( $(compgen -W "$shortcuts" -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "$actions" -- "$cur") )
    fi
}

# Autocomplete function for ros2_ws_use and workspace shortcuts
_ros2_ws_use_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local shortcuts=$(cut -d':' -f1 "$ROS2_SHORTCUTS_FILE" 2>/dev/null)
    COMPREPLY=( $(compgen -W "$shortcuts" -- "$cur") )
}

# Autocomplete function for ros2_topic_publishers and ros2_topic_subscribers
_ros2_topic_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ros2 topic list)" -- "$cur") )
}

# Register autocomplete for ros2_ws_shortcut
complete -F _ros2_ws_shortcut_autocomplete ros2_ws_shortcut

# Register autocomplete for ros2_ws_use and workspace shortcuts
complete -F _ros2_ws_use_autocomplete ros2_ws_use
complete -F _ros2_ws_use_autocomplete $(cut -d':' -f1 "$ROS2_SHORTCUTS_FILE" 2>/dev/null)

# Register autocomplete for ros2_topic_publishers and ros2_topic_subscribers
complete -F _ros2_topic_autocomplete ros2_topic_publishers
complete -F _ros2_topic_autocomplete ros2_topic_subscribers

# Create aliases when the script is sourced
_create_ros2_aliases

# Aliases for convenience
alias ros2_ws='ros2_ws_use'
alias ros2 ws='ros2_ws_use'
alias ros2 ws shortcut='ros2_ws_shortcut'
alias ros2 topic ps='ros2_topic_ps'
alias ros2 topic publishers='ros2_topic_publishers'
alias ros2 topic subscribers='ros2_topic_subscribers'
alias ros2 pkg list_prefixes='ros2_pkg_list_prefixes'

echo "ROS2 utility functions loaded. Available commands:"
echo "  ros2 ws use <shortcut>"
echo "  ros2 ws shortcut <add|remove|list> [workspace_path] [shortcut]"
echo "  ros2 topic ps"
echo "  ros2 topic publishers <topic_name>"
echo "  ros2 topic subscribers <topic_name>"
echo "  ros2 pkg list_prefixes"
echo "You can also switch workspaces by typing the shortcut name directly."
