#!/bin/bash

# Check if node ID file provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 node_ids.txt"
    exit 1
fi

NODE_ID_FILE=$1

if [ ! -f "$NODE_ID_FILE" ]; then
    echo "File not found: $NODE_ID_FILE"
    exit 1
fi

# Install tmux if not installed
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    sudo apt update && sudo apt install -y tmux
fi

# Loop through each node ID and create tmux session
count=1
while IFS= read -r NODE_ID; do
    SESSION="nex${count}"

    # Check if session already exists, kill if yes (optional)
    if tmux has-session -t "$SESSION" 2>/dev/null; then
        echo "Session $SESSION exists. Killing it..."
        tmux kill-session -t "$SESSION"
    fi

    echo "Starting tmux session '$SESSION' with NODE ID: $NODE_ID"

    # Create new detached tmux session and run commands
    tmux new-session -d -s "$SESSION"
    tmux send-keys -t "$SESSION" "source ~/.bashrc" C-m
    tmux send-keys -t "$SESSION" "nexus-network start --node-id $NODE_ID" C-m

    ((count++))
done < "$NODE_ID_FILE"

echo "✅ All nodes started in tmux sessions nex1 to nex$((count-1))"
echo "You can attach to any session using: tmux attach -t <session_name>"
