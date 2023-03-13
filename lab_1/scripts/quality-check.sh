#!/bin/bash

APP_PATH=$1
cd $APP_PATH

# Lint the app
npm run lint

# Audit npm dependencies
npm audit

# Run unit tests
npm run test -- --browsers=ChromeHeadless --no-watch

# Check if any issues were found
if [ $? -eq 0 ]
then
  echo "Code quality check passed!"
else
  echo "Code quality check failed!"
  exit 1
fi