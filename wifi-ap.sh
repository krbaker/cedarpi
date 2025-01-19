#!/bin/bash

nmcli con add type wifi ifname wlan0 mode ap con-name <CONNAME> ssid <MY SSID>
nmcli con modify <CONNAME> 802-11-wireless.band bg
nmcli con modify <CONNAME> 802-11-wireless.channel 7
nmcli con modify <CONNAME> ipv4.method manual ipv4.address 192.168.129.1/24
nmcli con modify <CONNAME> ipv6.method disabled
nmcli con modify <CONNAME> wifi-sec.key-mgmt wpa-psk
nmcli con modify <CONNAME> wifi-sec.psk "<MY WIFI PASSWORD>"
nmcli con modify <CONNAME> ipv4.method shared
nmcli con up CedarPi
