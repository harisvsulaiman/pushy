#!/bin/bash

echo "Installing nodejs"
apt-get install curl
curl -sL https://deb.nodesource.com/setup_8.x | -E bash -
apt-get install -y nodejs && apt-get install -y build-essential
npm install
npm install -g pkg
npm run build