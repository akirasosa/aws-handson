#!/usr/bin/env bash

sysctl -w net.ipv4.ip_forward=1
/etc/init.d/procps restart
