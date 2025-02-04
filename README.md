# Mail-in-A-Box Dynamic DNS
This is a very simple script based service that uses Mail-in-A-Boxs' API to create a dynamic DNS service.
Someone told me that IPv6 was so great because it just works. I replied with have you tried typing in one of random string they call IP addresses?
So I thought dynamic dns would be the perfect way to solve this. In a local network there are better options like mDNS, but over the onternet you need another layer.
I don't like the idea of relying on other people or services more than you have to and I already had Mail-in-A-Box setup and running. Turns out they have API and that API allows you to check, create, and update custom dns entries. Perfect!

A little tinkering and now I have this script and service.
You can also take those same DNS entries and use them in a firewall address list.
For example to allow access to your service from where ever you are with have to jump through hoops to whitelist your new IP.

# How to Install
Download and unpack and configure a few variable at the start of the `dyndns.sh` script.
```
MAILINABOX_HOST="box.example.invalid"
MAILINABOX_EMAIL="admin@example.invalid"
MAILINABOX_PASSWORD="CHANGE_ME"
RECORDS_TO_UPDATE=("box2.example.invalid" "sub.box2.example.invalid") 
```
Then run the install script:
```
chmod +x install.sh
sudo ./install.sh
```
After Install delete the downloaded files.
The installed script with your user and password in it is only readable by root.
So should be mostly secure. As secure as your computer anyway.

# How it works
The script `dyndns.sh` first obtains your current public IPv4 and IPv6 address.
Then it compares your public address to the current values of the records set in `RECORDS_TO_UPDATE`
If the two values are different, then a api request is sent to update the record.

The systemd service simply runs the script when called.
Then the timer runs the script 5 Minutes after boot and every 15 minutes after.