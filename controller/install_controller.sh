#!/usr/bin/env bash
## Cimon controller scripts installieren
setupdir=$(dirname $(readlink -f $0))
# Vorrausetzung: Python module
#PyYaml: https://pypi.python.org/pypi/PyYAML
sudo apt-get install python3-yaml
sudo pip3 install pyaes
# Cimon controller scripts
# verwenden Python3 (vorinstalliert)
# start-stopscript installieren
sudo mkdir -p /var/log/cimon
sudo chmod a+rwx /var/log/cimon
sudo cp $setupdir/init.d/cimon.sh /etc/init.d
sudo chmod a+x /etc/init.d/cimon.sh
sudo update-rc.d cimon.sh defaults
sudo systemctl daemon-reload
# cronjob for start/restart in case there is an issue
sudo cp $setupdir/cron.d/cimon /etc/cron.d/cimon
sudo chmod g-x,o-x /etc/cron.d/cimon
# install the scripts
bash $setupdir/update_controller.sh
# Edit ~/cimon.yaml as required