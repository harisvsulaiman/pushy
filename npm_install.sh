#!/bin/bash

# Exit on error to prevent a build
set -e

# Variable setup
BUILD_DIR="$(pwd)"
DEB_BUILD=false
if [[ $BUILD_DIR == *debian/build ]]
then
  BUILD_DIR="$(pwd)/../.."
  DEB_BUILD=true
fi

BUILD_NAME="com.github.harisvsulaiman.pushy.node"
NODE_DIR="$BUILD_DIR/$BUILD_NAME"

# Add node related directories to path
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.npm-packages/bin"
export PATH="$PATH:$HOME/.npm/.bin"
export PATH="$PATH:$BUILD_DIR/node_modules/.bin"
export PATH="$PATH:$BUILD_DIR/../../node_modules/.bin"

# Setup global npm root
mkdir -p /tmp/npm
npm config set prefix /tmp/npm
export PATH="$PATH:/tmp/npm"

# Remove any already built code
echo "Deleting files already built"
rm -rf ${NODE_DIR}
rm -rf ${BUILD_DIR}/node_modules

# Install node dependencies.
echo "Installing npm dependencies in $BUILD_DIR"
npm install
npm install -g pkg

# Setup workspace
mkdir ${NODE_DIR}

# Build app using pkg
echo "Building binary using pkg"
npm run build

echo "Copying .node files from ${BUILD_DIR}"
cp $BUILD_DIR/node_modules/keytar/build/Release/keytar.node ${NODE_DIR}
cp $BUILD_DIR/node_modules/abstract-socket/build/Release/abstract_socket.node ${NODE_DIR}
cp $BUILD_DIR/node_modules/websocket/build/Release/bufferutil.node ${NODE_DIR}
cp $BUILD_DIR/node_modules/websocket/build/Release/validation.node ${NODE_DIR}
cp $BUILD_DIR/node_modules/opn/xdg-open ${NODE_DIR}

if [ "$BUILD_DEB" = true ]
then
  echo "Copying built directory from ${BUILD_DIR}"
  mkdir -p $BUILD_DIR/debian/build/$BUILD_NAME
  cp $NODE_DIR/* $BUILD_DIR/debian/build/$BUILD_NAME/
fi
