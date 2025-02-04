#!/bin/bash
#Install files
install -D -o root dyndns.sh /usr/local/bin/dyndns.sh
install -D -o root systemd/dyndns.service /etc/systemd/system/dyndns.service
install -D -o root systemd/dyndns.timer /etc/systemd/system/dyndns.timer
#Enable and Start Services
systemctl daemon-reload
systemctl enable --now dyndns.service
systemctl enable --now dyndns.timer