#!/bin/bash
NODE_DIR="com.github.harisvsulaiman.pushy.node"

if [ -d ${NODE_DIR} ]
then
    rm -rf ${NODE_DIR}
fi

# Install and build app.
if [ ! -d "./node_modules" ]
then
    echo "Installing npm dependencies"
    npm install
fi

echo "Copying binaries"
mkdir ${NODE_DIR}

# Build app using package
echo "Building binary using pkg"
npm run build

cp ./node_modules/keytar/build/Release/keytar.node ${NODE_DIR}
cp ./node_modules/abstract-socket/build/Release/abstract_socket.node ${NODE_DIR}
cp ./node_modules/websocket/build/Release/bufferutil.node ${NODE_DIR}
cp ./node_modules/websocket/build/Release/validation.node ${NODE_DIR}
cp ./node_modules/opn/xdg-open ${NODE_DIR}
