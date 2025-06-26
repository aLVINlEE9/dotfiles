#!/bin/bash

if [ -n "$SSH_CONNECTION" ]; then
    SERVER_IP=$(echo "$SSH_CONNECTION" | awk '{print $3}')
    printf "%-15s" "$USER@$SERVER_IP"
elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    printf "%-15s" "$USER@ssh"
else
    printf "%-15s" "$USER@local"
fi
