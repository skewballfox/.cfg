#!/usr/bin/env bash

# Open a new terminal in the current working directory of a focused terminal
terminal="kitty"

cwd="$( swaymsg -t get_tree |
  jq '.. | (.nodes? // empty)[] | select(.focused == true).pid? // empty' |
  xargs pstree -p | rg 'tmux|fish|bash|zsh|sh' |
  rg -o '[0-9]*' | xargs pwdx 2> /dev/null | cut -f2- -d' ' |
  sort | tail -n 1 | tr -d '\n' )"

if [ -d "$cwd" ]; then
   $terminal -d "$cwd" &
   disown
else
   $terminal &
   disown
fi
