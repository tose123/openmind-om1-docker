#!/bin/bash
set -e
sed -i "s/openmind_free/${OM_API_KEY}/g" config/spot.json5
exec uv run src/run.py "$@"
