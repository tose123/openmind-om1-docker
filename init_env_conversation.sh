#!/bin/bash
set -e

TIMEOUT=300
START_TIME=$(date +%s)

uv run src/run.py conversation &
CMD_PID=$!
while true; do
    if ! kill -0 $CMD_PID 2>/dev/null; then
        echo "Command completed"
        break
    fi
    
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    
    if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
        echo "Timeout reached - terminating command"
        kill $CMD_PID 2>/dev/null
        break
    fi
    
    sleep 1
done
exit 0
