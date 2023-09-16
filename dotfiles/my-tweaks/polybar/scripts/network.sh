#!/bin/bash
output=""
if ip link show | grep -q "enp6s0.*state UP"; then
    output="%{F#3B4252} enp6s0"
else
    output="%{F#4C566A} Offline"
fi

if dpkg -l | grep -q "nordvpn"; then
    if nordvpn status | grep -q "Status: Connected"; then
         output=${output}" %{F#3B4252}"
    fi
fi

printf "%s" "$output"