#!/bin/bash
tmux list-panes -s -F '#{pane_id}' | while read pane_id; do
  tmux send-keys -t "$pane_id" "source ~/.bashrc" Enter
done

