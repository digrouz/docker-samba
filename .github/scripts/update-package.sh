#!/usr/bin/env bash

. root/usr/local/bin/docker-entrypoint-function.sh

local OS=$(DetectOS)
local NEW_VERSION=""
PACKAGE_NAME=$1; 

if "${OS}" == "alpine" then
  NEW_VERSION=$(apk list ${PACKAGE_NAME} | awk '{print $1}' | sed  -E "s|${PACKAGE_NAME}-||")
  sed -i -e "s|ARG ${PACKAGE_NAME^^}_VERSION:.*|ARG ${PACKAGE_NAME^^}_VERSION=${NEW_VERSION}|" Dockerfile_alpine
fi

if output=$(git status --porcelain) && [ -z "$output" ]; then
  # Working directory clean
  echo "No new version available!"
else
  # Uncommitted changes
  git commit -a -m "Updated Package ${PACKAGE_NAME} to version: ${NEW_VERSION}"
  git push
fi
