# General description

This code here is wholly based on https://github.com/bazelbuild/bazel/tree/master/examples/java-native which compiles Java into a native solution using Bazel. Indeed that sub-directory of that repo is represented twice here:  "Module A" and "Module X" (modulea/ and modulex/). The latter depends on the former to compile and execute, even though that's been added as a feature by me, and gratuitous.

How to build both though, with two separate Bazel WORKSPACEs in one repo?

## Depth-first recursive vs directed graph

What's needed is a **depth-first recursive build** here, but using Bazel somehow. Maven does **depth-first recursive builds** out of the box, but we want Bazel not Maven.  Bazel is a ordinarily a **directed graph build system** and does not do a recursive builds the Maven way without additional configuration. What this repo contains is some shell script shenanigans to be a middle ground between Bazel and the **depth-first recursive build** way of Maven.

## Maven example of intention

Maven should be installed first. We get to see `Module X` print to the console and invoke `Module A` which will do the same. This illustrates the dependency and proves that Maven too can work with this repo's two source trees. A corporate migrating from Maven (etc) to Bazel would not have `pom.xml` files as I do here.

```
$ mvn install | sed '/\[INFO\]/d' 
$ cd modulex
$ mvn exec:java -Dexec.mainClass="com.example.modulex.cmdline.Runner" | sed '/\[INFO\]/d' 
Hi from module X!
Hi from module A!
```

That's the definition of success - those two "Hi from" both modules. Maven builds the right thing, after calculating deps. It also sorts out a classpath for an invocation of modulex (the depending module) in the last step.

## Bazel mirroring Maven's depth-first recursive behavior

Note: Bazel should be installed first.

Note2: Bazel is NOT  **depth-first recursive** build technology without additional configuration, it is based on acyclic directed graphs. We have a top-level shell script to make Bazel behave like a depth-first recursive build technology.


```
$ ./recursive-bazel-build.sh 
INFO: Analyzed target //:ModuleARunner (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:ModuleARunner up-to-date:
  bazel-bin/ModuleARunner.jar
  bazel-bin/ModuleARunner
INFO: Elapsed time: 0.209s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
adding: com/(in = 0) (out= 0)(stored 0%)
adding: com/example/(in = 0) (out= 0)(stored 0%)
adding: com/example/modulea/(in = 0) (out= 0)(stored 0%)
adding: com/example/modulea/ModuleARunner.class(in = 512) (out= 321)(deflated 37%)
adding: com/example/modulea/GreetingA.class(in = 507) (out= 335)(deflated 33%)
INFO: Analyzed target //:ModuleXRunner (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:ModuleXRunner up-to-date:
  bazel-bin/ModuleXRunner.jar
  bazel-bin/ModuleXRunner
INFO: Elapsed time: 0.179s, Critical Path: 0.01s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action

$ modulex/bazel-bin/ModuleXRunner
Hi from module X!
Hi from module A!
```

Those last two lines of output show Java classes from `modulea` and `modulex` doing their thing together.

This Bazel build behaves as Maven's depth-first recursive build does. 

Key file:

1. [recursive-bazel-build.sh](https://github.com/paul-hammant-fork/standard-bazel-experiment/blob/trunk/recursive-bazel-build.sh) - builds `module a` with Bazel then builds `module x` wih Bazel

Monorepo life, with hundreds of different buildable-deployables all together in one dir structure and trunk, has other well documented nuances though :)