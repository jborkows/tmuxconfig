#!/bin/bash
script_dir="$(dirname "$0")"
chmod u+x "$script_dir"/*.sh
cp -r "$script_dir"/* ~/.config/tmux/plugins/tmux/scripts/
