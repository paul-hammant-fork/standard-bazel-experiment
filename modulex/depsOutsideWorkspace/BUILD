package(default_visibility = ["//visibility:public"])

java_import(
    name = "depsOutsideWorkspaceJar",
    jars = ["depsOutsideWorkspace.jar"],
)

java_library(
    name = "all",
    exports = [
        ":depsOutsideWorkspaceJar"
    ]
)

