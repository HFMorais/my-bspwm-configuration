#!/bin/bash
output=""
if ip link show | grep -q "enp6s0.*state UP"; then
    output="%{T4}%{F#3B4252} %{T5}enp6s0"
else
    output="%{T4}%{F#4C566A} %{T5}Offline"
fi

if dpkg -l | grep -q "nordvpn"; then
    if nordvpn status | grep -q "Status: Connected"; then
         output=${output}" %{F#3B4252}"
    fi
fi

printf "%s" "$output"