#!/bin/bash

NODE_DIR="com.github.harisvsulaiman.pushy.node"

# Add node related directories to path
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.npm-packages/bin"
export PATH="$PATH:$HOME/.npm/.bin"
export PATH="$PATH:$HOME/node_modules/.bin"

# Remove any already built code
echo "Deleting Node directory"
rm -r ${NODE_DIR}

# Install node dependencies.
echo "Installing npm dependencies in $(pwd)"
npm install
npm install -g zeit/pkg#aa6e7a490c0f6c9e21abad93a384014db3331806

# Setup workspace
mkdir ${NODE_DIR}

# Build app using pkg
echo "Building binary using pkg"
npm run build &> npm_log.txt

echo "Copying .node files from $(pwd)"
cp ./node_modules/keytar/build/Release/keytar.node ${NODE_DIR}
cp ./node_modules/abstract-socket/build/Release/abstract_socket.node ${NODE_DIR}
cp ./node_modules/websocket/build/Release/bufferutil.node ${NODE_DIR}
cp ./node_modules/websocket/build/Release/validation.node ${NODE_DIR}
cp ./node_modules/opn/xdg-open ${NODE_DIR}

exit 0;
