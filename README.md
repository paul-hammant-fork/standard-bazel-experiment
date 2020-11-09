# General description

This code here is wholly based on https://github.com/bazelbuild/bazel/tree/master/examples/java-native which compiles Java into a native solution.

This repo contains two modules - "Module A" and "Module X". The latter depends on the former to compile and exexute. What's needed is a depth-first recursive build here. Maven does that out of the box.

## Maven example of intention

Maven should be installed first.  We get to see Module X print to the console and invoke Module A which will do the same. This illustrates the dependency.

```
$ mvn install
 ** snip build output **
$ cd modulex
$ mvn exec:java -Dexec.mainClass="com.example.modulex.cmdline.Runner"| sed  '/[INFO]/d'
Hi from module X!
Hi from module one!
```

That's the definition of success - those two "Hi from" both modules. Maven builds the right thing, after calculating deps. It also sorts out a classpath for an invocation of modulex (the depending module).

## Bazel mirroring Maven's bahavior

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

Those last two lines use Java classes from modulea and modulex.

This Bazel build behaves as Maven's recursive depth-first build does.  There's a cheat - a tactical build of a jar of the output of `module a` and then dropping that into a `depsOutsideWorkspace` directory for use within the `module X` build. The jar in `depsOutsideWorkspace` is excluded from source control (it is mentioned in the `.gitignore` file).
