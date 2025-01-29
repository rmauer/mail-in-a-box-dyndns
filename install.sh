#!/bin/bash
#This is not tested yet.
install -D -o root dyndns.sh /usr/local/bin/dyndns.sh
install -D -o root systemd/dyndns.service /etc/systemd/system/dyndns.service
install -D -o root systemd/dyndns.timer /etc/systemd/system/dyndns.timer
