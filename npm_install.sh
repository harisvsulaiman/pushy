#!/bin/bash

# Install and build app.
if [ ! -d "./node_modules" ]
then
    echo "Installing npm dependencies"
    npm install
fi

# Build app using package
echo "Building binary using pkg"
npm run build