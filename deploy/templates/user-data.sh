#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl zip
sudo apt install -y gettext-base moreutils
sudo apt-get update
sudo apt-get install cron
chmod +x /home/ubuntu/ec2-caller.sh

crontab<<EOF
* * * * * /home/ubuntu/ec2-caller.sh
EOF



