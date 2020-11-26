#!/bin/bash

set -e

# Depth-first recursive build of two modules

cd modulea
bazel build :all

# switch modules, and build that

cd ../modulex
bazel build :all
