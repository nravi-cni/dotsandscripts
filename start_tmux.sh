#!/bin/bash

# Define a unique name for your tmux session
SESSION_NAME="my_custom_layout"

# Check if a tmux session with this name is already running
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    # Create a new named tmux session and the first window, in detached mode.
    # This implicitly creates the very first pane (which will become your Top pane).
    tmux new-session -s "$SESSION_NAME" -d -n "Main"

    # Set mouse mode on for easier navigation
    tmux set-option -w -g mouse on

    # Set copy mode to vi for familiar keybindings
    tmux set-window-option -g mode-keys vi

    # --- Step 1: Split the initial pane horizontally ---
    # The `-h` (horizontal split) creates a horizontal dividing line.
    # The original pane (Pane 0.0) becomes the Top pane.
    # A new pane (Pane 0.1) is created directly below it.
    tmux split-window -h -t "$SESSION_NAME:0.0"

    # At this point, the layout looks like:
    # +-----------------+
    # |    Pane 0.0 (Top)   |
    # +-----------------+
    # |    Pane 0.1 (Bottom)|
    # +-----------------+

    # --- Step 2: Select the Bottom pane (Pane 0.1) to split it vertically ---
    # We select Pane 0.1 because it's the newly created bottom pane.
    tmux select-pane -t "$SESSION_NAME:0.1"

    # --- Step 3: Split the selected Bottom pane (Pane 0.1) vertically ---
    # The `-v` (vertical split) creates a vertical dividing line *within* the selected pane (0.1).
    # Pane 0.1 becomes the Bottom-Left pane.
    # A new pane (Pane 0.2) is created to its right, becoming the Bottom-Right pane.
    tmux split-window -v -t "$SESSION_NAME:0.1"

    # After this step, the layout is:
    # +-----------------+
    # |    Pane 0.0 (Top)   |
    # +-----------------+-----------------+
    # | Pane 0.1 (Bottom Left) | Pane 0.2 (Bottom Right) |
    # +-----------------+-----------------+

    # --- Step 4: Select the Bottom-Right pane (Pane 0.2) to split it horizontally ---
    # We select Pane 0.2 to perform the next split.
    tmux select-pane -t "$SESSION_NAME:0.2"

    # --- Step 5: Split the selected Bottom-Right pane (Pane 0.2) horizontally with 50% height ---
    # The `-h` (horizontal split) creates a horizontal dividing line *within* the selected pane (0.2).
    # The `-p 50` ensures the new pane takes 50% of the height, making both resulting panes equal.
    # Pane 0.2 becomes the Bottom-Right-Top pane (occupying 50% of the original 0.2 height).
    # A new pane (Pane 0.3) is created directly below it, becoming the Bottom-Right-Bottom pane
    # (also occupying 50% of the original 0.2 height).
    tmux split-window -h -p 85 -t "$SESSION_NAME:0.2"

    # After this step, the final layout should be:
    # +-----------------+
    # |    Pane 0.0 (Top)   |
    # +-----------------+--------------------------+
    # | Pane 0.1 (Bottom Left) | Pane 0.2 (Bottom Right Top) |
    # |                 |     (50% height)         |
    # |                 |--------------------------|
    # |                 | Pane 0.3 (Bottom Right Bottom) |
    # |                 |     (50% height)         |
    # +-----------------+--------------------------+

    # --- Step 6: Run 'cd ~desk' in the Bottom-Right-Top pane (Pane 0.2) ---
    # This pane was originally 0.2 and now occupies the top part of the split.
    tmux send-keys -t "$SESSION_NAME:0.2"

    # --- Step 7: Run 'htop' in the Bottom-Right-Bottom pane (Pane 0.3) ---
    # This is the newly created pane at the bottom of the split.
    tmux send-keys -t "$SESSION_NAME:0.3" 'htop' C-m

    # --- Step 8 (Optional): Set Initial Focus ---
    # Select the Top pane (Pane 0.0) for your cursor to start in.
    # You can change '0.0' to '0.1' (Bottom-Left), '0.2' (Bottom-Right-Top),
    # or '0.3' (Bottom-Right-Bottom) if you prefer.
    tmux select-pane -t "$SESSION_NAME:0.0"

fi

# Attach to the tmux session, bringing it to the foreground.
# If the session already exists from a previous run, this will simply attach to it.
tmux attach-session -t "$SESSION_NAME"
