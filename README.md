'' Mail-in-A-Box Dynamic DNS
This is a very simple script based service that uses Mail-in-A-Boxs' API to create a dynamic DNS service.
Someone told me that IPv6 was so great because it just works. I replied with have you tried typing in one of random string they call IP addresses?
So I thought dynamic dns would be the perfect way to solve this. In a local network there are better options like mDNS, but over the onternet you need another layer.
I don't like the idea of reying on other people or services more than you have to and I already had Mail-in-A-Box setup and running. Turns out they have API and that API allows you to check, create, and update custom dns entries. Perfect!

A little tinkering and now I have this script and service.
You can also take those same DNS entries and us them in a firewall address list.
For example to allow access to your service from where ever you are with have to jump through hoops to whitelist your new IP.