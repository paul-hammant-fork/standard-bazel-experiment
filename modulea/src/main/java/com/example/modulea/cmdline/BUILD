load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "runner",
    srcs = ["Runner.java"],
    main_class = "com.example.modulea.cmdline.Runner",
    deps = ["//:greeter"],
)
