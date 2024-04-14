#!/bin/bash
function is_debug() {
    while getopts ":d" opt; do
        if [ $opt = "d" ]; then
            echo "debug"
        fi
    done
}