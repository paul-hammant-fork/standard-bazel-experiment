You can go into either of `moduleone` or `moduletwo` and run a bazel build:

```
$ bazel build --experimental_convenience_symlinks=ignore :all
INFO: Analyzed target //:ProjectRunner (20 packages loaded, 349 targets configured).
INFO: Found 1 target...
Target //:ProjectRunner up-to-date:
  bazel-bin/ProjectRunner.jar
  bazel-bin/ProjectRunner
INFO: Elapsed time: 50.416s, Critical Path: 7.61s
INFO: 7 processes: 4 internal, 2 darwin-sandbox, 1 worker.
INFO: Build completed successfully, 7 total actions
```

Those two are identical for now, but watch this space!