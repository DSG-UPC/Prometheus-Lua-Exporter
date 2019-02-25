#!/bin/sh



cd /Prometheus-Lua-Exporter/src
OWNER_ADDRES="$(nospaces "$OWNER_ADDRESS")"
echo "$OWNER_ADDRESS" > static/owner
lapis server
