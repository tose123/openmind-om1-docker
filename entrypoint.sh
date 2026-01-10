#!/bin/bash
set -e

pulseaudio -D --exit-idle-time=-1
pactl load-module module-null-sink sink_name=virtual_output
pactl load-module module-virtual-source source_name=virtual_input

if [ -n "$HERTZ" ]; then
    find config -type f -name "*.json5" -exec sed -i "s/hertz: [0-9]\+\(\.[0-9]\+\)\?,/hertz: ${HERTZ},/g" {} \;
fi

find config -type f -name "*.json5" -exec sed -i "s/openmind_free/${OM_API_KEY}/g" {} +

if [ -n "$PROXYCHAINS_CONFIG" ]; then
    sed -i "s/# localnet 10/localnet 10/g" /etc/proxychains4.conf
    sed -i "s/# localnet 172/localnet 172/g" /etc/proxychains4.conf
    sed -i "s/# localnet 192/localnet 192/g" /etc/proxychains4.conf
    sed -i "s/socks4 	127.0.0.1 9050/${PROXYCHAINS_CONFIG}/g" /etc/proxychains4.conf
    exec proxychains4 uv run src/run.py "$@"
else
    exec uv run src/run.py "$@"
fi
