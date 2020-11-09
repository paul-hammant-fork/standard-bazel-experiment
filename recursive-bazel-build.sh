#!/bin/bash

# Non-standard depth-first recursive build of two modules

cd modulea
bazel clean
bazel build :all

cd modulex
bazel clean
bazel build :all
