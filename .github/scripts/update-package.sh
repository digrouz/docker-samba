#!/usr/bin/env bash

PACKAGE_NAME=$1; 
ALPINE_VERSION=$(grep "FROM alpine:" ../../Dockerfile_alpine | awk '{print $2}'| sed  -E "s|alpine:||" | awk -F '.' '{print $1"."$2}')

NEW_VERSION=$(https://pkgs.alpinelinux.org/package/v${ALPINE_VERSION}/main/x86_64/samba | sed  -E "s|${PACKAGE_NAME}-||")
sed -i -e "s|ARG ${PACKAGE_NAME^^}_VERSION:.*|ARG ${PACKAGE_NAME^^}_VERSION=${NEW_VERSION}|" Dockerfile_alpine

if output=$(git status --porcelain) && [ -z "$output" ]; then
  # Working directory clean
  echo "No new version available!"
else
  # Uncommitted changes
  git commit -a -m "Updated Package ${PACKAGE_NAME} to version: ${NEW_VERSION}"
  git push
fi
