#!/bin/bash

APP_PATH=$1
cd $APP_PATH

# Check if client-app.zip exists
if [ -f "dist/client-app.zip" ]
then
  # If it does, remove it from the file system
  rm dist/client-app.zip
fi

# Set the ENV_CONFIGURATION environment variable based on the current environment
if [ "$NODE_ENV" = "production" ]
then
  ENV_CONFIGURATION="production"
else
  ENV_CONFIGURATION=""
fi

# Install npm dependencies
npm install

# Build the configuration flag base on env config
npm run build -- --configuration="$ENV_CONFIGURATION"

# Compress all built content/files in one ZIP archive
cd dist
zip -r client-app.zip *