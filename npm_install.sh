#!/bin/bash

NODE_DIR="com.github.harisvsulaiman.pushy.node"

if [ -d ${NODE_DIR} ]
then
    echo "Deleting Node directory"
    rm -rf ${NODE_DIR}
fi

# Install and build app.
if [ ! -d "./node_modules" ]
then
    echo "Installing npm dependencies"
    npm install
    npm install -g zeit/pkg#aa6e7a490c0f6c9e21abad93a384014db3331806
fi

mkdir ${NODE_DIR}

# Build app using package
echo "Building binary using pkg"
npm run build &> npm_log.txt

cp ./node_modules/keytar/build/Release/keytar.node ${NODE_DIR}
cp ./node_modules/abstract-socket/build/Release/abstract_socket.node ${NODE_DIR}
cp ./node_modules/websocket/build/Release/bufferutil.node ${NODE_DIR}
cp ./node_modules/websocket/build/Release/validation.node ${NODE_DIR}
cp ./node_modules/opn/xdg-open ${NODE_DIR}

exit 0;