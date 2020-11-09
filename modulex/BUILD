load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "ModuleXRunner",
    srcs = glob(["src/main/java/com/example/modulex/*.java"]),
	deps = ["//depsOutsideWorkspace:all"]
)
