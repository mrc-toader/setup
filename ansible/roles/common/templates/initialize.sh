#!/bin/bash
set -e


sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='liquid'" | grep -q 1 || sudo -u postgres createuser --superuser liquid


for file in /opt/common/initialize.d/*
do
  "$file"
done
