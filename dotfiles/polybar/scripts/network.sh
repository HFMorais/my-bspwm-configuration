#!/bin/bash
output=""
if ip link show | grep -q "enp0s31f6.*state UP"; then
    output="%{F#EBCB8B}  "
else
    output="%{F#4C566A}  "
fi

if ip link show | grep -q "wlp4s0.*state UP"; then
    ssid=$(/usr/sbin/iwgetid -r)
    output=${output}"%{F#EBCB8B}  %{F#C5C8C6}"${ssid}
else
    output=${output}"%{F#4C566A} "
fi

if dpkg -l | grep -i "nordvpn"; then
    if nordvpn status | grep -q "Status: Connected"; then
         output=${output}" %{F#81B6C6} "
    fi
fi

printf "%s" "$output"