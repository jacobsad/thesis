#!/bin/bash

# ==========================================
# Environment Setup Script (tmux/sublime)
# ==========================================
#
# Sets up a working environment similar to 
# Rstudio... but without the soul-crushing 
# memory leaks.
# 
# 1) cd into the project directory.
# 2) run script
# 
# ==========================================

# Grab R version
r_version=$(R --version | sed -n 's/^R version \(.*\) (\(.*\)/\1/p')

# New tmux window setup
tmux new-window -n thesis -d "figlet -f slant R WORKSPACE && echo 'R v. $r_version -- Console Session #1' && R --no-save --quiet";
tmux split-window -v -t main:thesis "echo 'R v. $r_version -- Console Session #2' && R --no-save --quiet";
tmux split-window -v -t main:thesis;
tmux select-layout -t thesis f5cb,124x75,0,0[124x22,0,0,19,124x22,0,23,20,124x29,0,46,21];
tmux select-pane -t 2;

# Open sublime project
subl --project ./thesis.sublime-project
