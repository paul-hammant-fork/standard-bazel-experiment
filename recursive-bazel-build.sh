#!/bin/bash

set -e

# Non-standard depth-first recursive build of two modules

cd modulea
bazel build :all

# switch modules, and build that

cd ../modulex
.prebuild.sh
bazel build :all
