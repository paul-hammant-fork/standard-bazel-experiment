# General description

This code here is wholly based on https://github.com/bazelbuild/bazel/tree/master/examples/java-native which compiles Java into a native solution using Bazel. Indeed that sub-directory of that repo is represented twice here:  "Module A" and "Module X" (modulea/ and modulex/). The latter depends on the former to compile and execute, even though that's beed added as a feature by me, and gratuitous.

How to build both though, with two separate Bazel WORKSPACEs in one repo?

What's needed is a **depth-first recursive build** here, but using Bazel somehow. Maven does **depth-first recursive builds** out of the box, but we want Bazel not Maven.  Bazel is a **directed graph buld system** and can't do a recursive build the Maven way. What this repo contains is some shell script schenigans to be a middle ground between Bazel and the **depth-first recursive build** way of Maven.

## Maven example of intention

Maven should be installed first.  We get to see Module X print to the console and invoke Module A which will do the same. This illustrates the dependency and proves that Maven too can work with this repo's two source trees. A corporate migrating from Maven (etc) to Bazel would not have `pom.xml` files as I do here.

```
$ mvn install | sed '/\[INFO\]/d' 
$ cd modulex
$ mvn exec:java -Dexec.mainClass="com.example.modulex.cmdline.Runner" | sed '/\[INFO\]/d' 
Hi from module X!
Hi from module one!
```

That's the definition of success - those two "Hi from" both modules. Maven builds the right thing, after calculating deps. It also sorts out a classpath for an invocation of modulex (the depending module) in the last step.

## Bazel mirroring Maven's depth-first recursive behavior

Bazel should be installed first.

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
Hi from module one!
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
Hi from module one!
```

Those last two lines of output show Java classes from `modulea` and `modulex` doing their thing together.

This Bazel build behaves as Maven's recursive depth-first build does. There's a cheat - a tactical build of a jar of the output of `module a` and then dropping that into a `depsOutsideWorkspace` directory for use within the `module X` build. The jar in `depsOutsideWorkspace` is excluded from source control (it is mentioned in the `.gitignore` file).

The magic is in these files though.

* [recursive-bazel-build.sh](https://github.com/paul-hammant/non-standard-bazel-experiment/blob/trunk/recursive-bazel-build.sh)
* [modulex/.prebuild.sh](https://github.com/paul-hammant/non-standard-bazel-experiment/blob/trunk/modulex/.prebuild.sh)
* [modulex/depsOutsideWorkspace/BUILD](https://github.com/paul-hammant/non-standard-bazel-experiment/blob/trunk/modulex/depsOutsideWorkspace/BUILD)

Monorepo life with hundreds of different buildable-deployables all together in one dir structure and trunk, has other well documented nances though :)