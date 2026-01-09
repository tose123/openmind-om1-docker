#!/bin/bash
set -e

TIMEOUT=300
START_TIME=$(date +%s)

if [ -n "$OM1_DEMO_API_KEY" ]; then
    find config -type f -name "*.json5" -exec sed -i "s/openmind_free/${OM1_DEMO_API_KEY}/g" {} +
fi

uv run src/run.py spot &
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

if [ -n "$OM1_DEMO_API_KEY" ]; then
    find config -type f -name "*.json5" -exec sed -i "s/${OM1_DEMO_API_KEY}/openmind_free/g" {} +
fi

exit 0
