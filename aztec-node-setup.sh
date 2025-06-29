#!/bin/bash

# Step 1: Auto install necessary packages
echo "🔧 Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen curl build-essential pkg-config libssl-dev git-all protobuf-compiler

# Step 2: Install Rust silently
echo "🔧 Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Step 3: Add Rust target
rustup target add riscv32i-unknown-none-elf

# Step 4: Loop for creating tmux sessions with node ID
while true; do
    echo ""
    read -p "📛 Enter tmux session name: " SESSION
    read -p "🔑 Enter your NODE ID: " NODE_ID

    # Create tmux session and run commands
    tmux new-session -d -s "$SESSION"
    tmux send-keys -t "$SESSION" "source ~/.bashrc" C-m
    tmux send-keys -t "$SESSION" "nexus-network start --node-id $NODE_ID" C-m

    echo "✅ Session '$SESSION' started with NODE ID '$NODE_ID'"

    # Ask if user wants to create another session
    read -p "➕ Do you want to create another node session? (Y/N): " AGAIN
    if [[ "$AGAIN" != "Y" && "$AGAIN" != "y" ]]; then
        break
    fi
done

echo "🏁 All done. Use 'tmux attach -t SESSION_NAME' to view any session."
