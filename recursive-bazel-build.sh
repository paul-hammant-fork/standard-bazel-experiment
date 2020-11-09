#!/bin/bash

set -e

# Non-standard depth-first recursive build of two modules

cd modulea
bazel clean
bazel build :all
./bazel-out/darwin-fastbuild/bin/ModuleARunner

cd ../modulex
bazel clean
bazel build :all
./bazel-out/darwin-fastbuild/bin/ModuleXRunner
