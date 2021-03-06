#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure the free sbb wlan access
SETUPDIR=$(dirname $(readlink -f $0))/freesbb

echo "$(date) Starting Setup freesbb..."

echo "$(date) Creating the /opt/cimon dir if required..."
bash $SETUPDIR/create_cimon_dir.sh
CheckReturncode
echo "$(date) Cimon dir created"

# free sbb wlan auto connect (use wpa supplicant in order to allow reconnect)
echo "$(date) Installing network config files..."
sudo cp $SETUPDIR/network/interfaces /etc/network/interfaces
sudo cp $SETUPDIR/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
echo "$(date) Network config files installed"

echo "$(date) Restarting wlan0 and service networking..."
# restart wlan
sudo ifdown wlan0 > /dev/null 2>&1
sudo ifup wlan0 > /dev/null 2>&1
# and restart networking just to be sure
sudo service networking restart
echo "$(date) Wlan0 and service networking restarted"

# install the script and cronjob
bash $SETUPDIR/update_freesbb.sh

echo "$(date) Running the freesbb script after 10 seconds rest..."
sleep 10
# try connect to freesbb
python3 /opt/cimon/freesbb/freesbb.py > /dev/null
echo "$(date) Freesbb script run, result is $?"

echo "$(date) Setup freesbb terminated OK."
# check it was installed
ls /opt/cimon/freesbb > /dev/null