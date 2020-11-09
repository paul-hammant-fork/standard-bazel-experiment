# General description

This code is wholly based on https://github.com/bazelbuild/bazel/tree/master/examples/java-native.

This repo contains two modules - "Module A" and "Module X". The latter depends on the former to compile and exexute.

## Maven example of intention

Maven should be installed first.  We get to see Module X print to the console and invoke Module A which will do the same. This illustrates the dependency.

```
$ mvn install
$ cd modulex
$ mvn exec:java -Dexec.mainClass="com.example.modulex.cmdline.Runner"
[INFO] --- exec-maven-plugin:1.6.0:java (default-cli) @ bazel-recursuve-build-demo-module-x ---
Hi from module X!
Hi from module one!
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
```

That's the dfinition of success - those two "Hi from" modules.

## Bazel example of need

Bazel should be installed first.

```
./recursive-bazel-build.sh
```

The above script fails in a second compilation step of "module X". There was a dependency to Module A in Module X that is not expressed in Bazel build rules grammer. Module A is outside the workspace of Module X.
