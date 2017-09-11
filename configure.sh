#!/bin/bash

echo "Installing nodejs"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs && sudo apt-get install -y build-essential
npm install
npm install -g pkg
npm run build