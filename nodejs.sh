#!/bin/bash

echo "Installing nodejs"
echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
. ~/.bashrc
mkdir ~/local
mkdir ~/node-latest-install
cd ~/node-latest-install
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
./configure --prefix=$HOME/local
make install
curl -L https://www.npmjs.com/install.sh | sh
