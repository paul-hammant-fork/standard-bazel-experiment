#!/bin/bash

# This allows multiple -C args to make a composite of multiple outputs.

jar cvfM depsOutsideWorkspace/depsOutsideWorkspace.jar -C ../modulea/bazel-out/darwin-fastbuild/bin/_javac/ModuleARunner/ModuleARunner_classes/ .

# An alternate would be to just move the single jar from modulea
# cp ../modulea/bazel-bin/ModuleXRunner.jar depsOutsideWorkspace/depsOutsideWorkspace.jar

# An alternate would be link the single jar from modulea
# ln -s ../modulea/bazel-bin/ModuleXRunner.jar depsOutsideWorkspace/depsOutsideWorkspace.jar