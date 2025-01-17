#! /usr/bin/env bash

set -eu -o pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils.sh"

: "${RTX_NODEJS_NODEBUILD_HOME=$RTX_NODEJS_PLUGIN_DIR/.node-build}"
: "${RTX_NODEJS_NODEBUILD_REPOSITORY=https://github.com/nodenv/node-build.git}"

ensure_updated_project() {
  local pull_exit_code=0 output=

  if ! [ -d "$RTX_NODEJS_NODEBUILD_HOME" ]; then
    printf "Cloning node-build...\n"
    git clone "$RTX_NODEJS_NODEBUILD_REPOSITORY" "$RTX_NODEJS_NODEBUILD_HOME"
  else
    printf "Trying to update node-build..."
    output=$(git -C "$RTX_NODEJS_NODEBUILD_HOME" pull origin master 2>&1) || pull_exit_code=$?

    if [ "$pull_exit_code" != 0 ]; then
      printf "\n%s\n\n" "$output" >&2
      printf "$(colored $RED ERROR): Pulling the node-build repository exited with code %s\n" "$pull_exit_code" >&2
      printf "Please check if the git repository at %s doesn't have any changes or anything\nthat might not allow a git pull\n" "$RTX_NODEJS_NODEBUILD_HOME" >&2
      exit $pull_exit_code
    fi

    printf " ok\n"
  fi
}

ensure_updated_project
