#!/bin/bash

# Check if NordVPN is connected
nordvpn status | grep "Connected" > /dev/null
if [[ $? -eq 0 ]]; then
  # Disconnect NordVPN
  nordvpn disconnect
else
  # Connect to NordVPN
  nordvpn connect
fi
