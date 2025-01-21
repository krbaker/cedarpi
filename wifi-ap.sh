#!/bin/bash

# The internet will say you can't bridge to Wifi, that seems to only be true of client mode
# AP mode is just hard to find a document of how to do it

nmcli con add ifname br0 type bridge con-name Bridge
nmcli con modify Bridge ipv4.method manual ipv4.address 192.168.129.1/24
nmcli con modify Bridge ipv6.method disabled
nmcli con modify Bridge ipv4.method shared

nmcli con add type ethernet slave-type bridge master br0 ifname enp6s0 con-name Wired
nmcli con add type wifi slave-type bridge master br0 ifname wlp3s0 mode ap con-name AP ssid <MY SSID>

nmcli con modify AP 802-11-wireless.band bg
nmcli con modify AP 802-11-wireless.channel 7
nmcli con modify AP ipv4.method manual ipv4.address 192.168.129.1/24
nmcli con modify AP ipv6.method disabled
nmcli con modify AP wifi-sec.key-mgmt wpa-psk
nmcli con modify AP wifi-sec.psk "<MY WIFI PASSWORD>"
nmcli con modify AP ipv4.method shared
nmcli con up Bridge
nmcli con up Wired #is this really needed?
nmcli con up AP #is this really needed?
