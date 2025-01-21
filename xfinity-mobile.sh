#!/bin/bash -x

nmcli con add type wifi ifname wlan1 con-name XfinityMobile ssid "Xfinity Mobile"

nmcli con mod XfinityMobile ipv4.method auto
nmcli con mod XfinityMobile 802-1x.eap ttls 802-1x.identity "<Base64 String From MAC Config>" 802-1x.password "<Base64 String from MAC Config>" 802-1x.anonymous-identity "xanonymous-ttls@xfinity.com" 802-1x.phase2-domain-suffix-match "*.aaa.wifi.comcast.com;*.aaa.wifi.xfinity.com" wifi-sec.key-mgmt wpa-eap 802-1x.phase1-auth-flags 6 802-1x.phase2-auth pap connection.autoconnect yes
#Valid values: none (0x0), tls-1-0-disable (0x1), tls-1-1-disable (0x2), tls-1-2-disable (0x4), tls-disable-time-checks (0x8), tls-1-3-disable (0x10), tls-1-0-enable (0x20), tls-1-1-enable (0x40), tls-1-2-enable (0x80), tls-1-3-enable (0x100), all (0x1ff)
