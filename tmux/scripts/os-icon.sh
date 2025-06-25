#!/bin/bash

uname_output=$(uname | tr '[:upper:]' '[:lower:]')

case "$uname_output" in
linux)
    # Try to get distribution info
    if command -v lsb_release >/dev/null 2>&1; then
        distro=$(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]')
    elif [ -f /etc/os-release ]; then
        distro=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
    else
        distro=""
    fi

    case "$distro" in
    *rocky* | *rhel* | *"red hat"*)
        echo "󱄛"
        ;;
    *ubuntu*)
        echo "󰕈"
        ;;
    *)
        echo "󰌽"
        ;;
    esac
    ;;
darwin)
    echo "󰀵"
    ;;
mingw* | cygwin* | *windows*)
    echo "󰖳"
    ;;
*)
    echo "󰌽"
    ;;
esac
