#!/bin/bash
set -e

pulseaudio -D --exit-idle-time=-1
pactl load-module module-null-sink sink_name=virtual_output
pactl load-module module-virtual-source source_name=virtual_input

find config -type f -name "*.json5" -exec sed -i "s/openmind_free/${OM_API_KEY}/g" {} +
exec uv run src/run.py "$@"
