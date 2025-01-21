# cedarpi
I wanted a simple wireless router using Xfinity Wireless.  Its not quite reachable from most of my house
so when my cable modem fails for instance I can't sit downstairs.  This allows me to use a simple
pi as a wireless router over the Xfinity Wifi.  Its also using the enterprise auth so you don't have
to mess with a captive portal.

# My Setup
* Pi3
* [Second Wifi](https://www.amazon.com/dp/B0BTHQNK5S?ref=ppx_yo2ov_dt_b_fed_asin_title).  Note I don't love this,
it claims linux compatability but its not already in kernel.  The [build](https://linux.brostrend.com/) did work out of the box though.

# Getting your Wifi Username/Password
Xfinity has a captive portal based wifi and an enterprise authenticated wifi.  
I wanted to be able to use my emergency AP anytime and portals require me to login through a web browser
all of the time which is far less useful.  Unfortunatly Xfinity is lame and doesn't provide a linux config
for the enterprise networks.  The good news is that networkmanager/wpa_suplicant *can* connect to them.
You need to grab your random user & password from the mac wifi profile bundle.  Either just use a mac *or*
set your user agent to a mac UA then 
* go [here](https://www.xfinity.com/support/articles/wifi-for-mac)
* Find the download mac wifi profile link
* Login
* Download the actual profile (should be a .mobileconfig file extension)
* Open it up in a text editor and find the 'key' UserName and UserPassword, copy the string values
* Download and fill in the user/password in [here](xfinity-mobile.sh)
* Might want to edit the wifi device name to whatever wifi device you need
* Run this script to create the profile in network manager

# Setup an AP on the internal Wifi (seems not too buggy)
 * Download [here](wifi-ap.sh)
 * Edit the connection name, SSID and password
 * Maybe edit the IP range for your preferences

# Reverse SSH
Xfinity wifi uses NAT and I wanted to be able to manage this device even if I wasn't present (say my wifi was at home when
our cable crapped out).  I added a reverse ssh tunnel to the router so I can always get to it.
## Systemd Service Template
/etc/systemd/system/secure-tunnel@.service
```
[Unit]
Description=Setup a secure tunnel to %I
After=network.target

[Service]
Environment="LOCAL_ADDR=localhost"
EnvironmentFile=/etc/default/secure-tunnel@%i
ExecStart=/usr/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R ${REMOTE_PORT}:127.0.0.1:${LOCAL_PORT} ${TARGET}

RestartSec=5
Restart=always

[Install]
WantedBy=mutli-user.target
```

## Host config 
/etc/default/secure-tunnel@<host>
```
TARGET=<user>@<host>
LOCAL_PORT=22
REMOTE_PORT=2022
```

I added an ssh key in roots homedir and ssh-copy-id'd it to the user on my remote host.  Once this was setup I enable the systemd job
sudo systemctl enable secure-tunnel@<host>.service

## libvirt
Install libvert

Add the bridge you created above
```
sudo virsh net-define br0.xml 
sudo virsh net-autostart br0
sudo virsh net-start br0
```

Setup Home Assistant (on the bridge so it can see wireless things (see virt-install [here](https://www.home-assistant.io/installation/linux/) virt-install option for image, below is slightly modified)
```
apt install virtinst
virt-install --name haos --description "Home Assistant" --os-variant=generic --ram 2048 --vcpus=2 --disk=/media/haos/haos_ova-14.1.qcow2,bus=scsi --controller type=scsi,model=virtio-scsi --import --graphics none --boot uefi  --network network=br0
```
