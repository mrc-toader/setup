#!/bin/bash
set -e

cd /opt/vpn
if [ ! -d easy-rsa ]; then
  cp -r /usr/share/easy-rsa ./
fi

cd easy-rsa
source vars
./clean-all
./build-ca --batch
./build-key-server --batch server

if [ ! -f keys/dh2048.pem ]; then
  ./build-dh
fi
