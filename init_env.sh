#!/bin/bash
set -e

pulseaudio -D --exit-idle-time=-1
pactl load-module module-null-sink sink_name=virtual_output
pactl load-module module-virtual-source source_name=virtual_input
