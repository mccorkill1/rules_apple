load("@rules_cc//cc:defs.bzl", "objc_library")
load(
    "//apple:ios.bzl",
    "ios_application",
)
load(
    "//apple:watchos.bzl",
    "watchos_application",
    "watchos_dynamic_framework",
    "watchos_extension",
    "watchos_static_framework",
)
load(
    "//apple:apple.bzl",
    "apple_dynamic_framework_import",
)
load("//test/starlark_tests:common.bzl", "FIXTURE_TAGS")
load(
    "//test/testdata/fmwk:generate_framework.bzl",
    "generate_import_framework",
)
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

licenses(["notice"])

package(
    default_testonly = 1,
    default_visibility = ["//test/starlark_tests:__subpackages__"],
)

watchos_application(
    name = "app",
    app_icons = ["//test/starlark_tests/resources:WatchAppIcon.xcassets"],
    bundle_id = "com.google.example",
    extension = ":ext",
    infoplists = [
        "//test/starlark_tests/resources:WatchosAppInfo.plist",
    ],
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
)

watchos_application(
    name = "app_with_ext_with_imported_fmwk",
    app_icons = ["//test/starlark_tests/resources:WatchAppIcon.xcassets"],
    bundle_id = "com.google.example",
    extension = ":ext_with_imported_fmwk",
    infoplists = [
        "//test/starlark_tests/resources:WatchosAppInfo.plist",
    ],
    minimum_os_version = "4.0",
    tags = FIXTURE_TAGS,
)

watchos_extension(
    name = "ext",
    bundle_id = "com.google.example.ext",
    entitlements = "//test/starlark_tests/resources:entitlements.plist",
    infoplists = [
        "//test/starlark_tests/resources:WatchosExtensionInfo.plist",
    ],
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    resources = [
        "//test/starlark_tests/resources:example_filegroup",
        "//test/starlark_tests/resources:localization",
        "//test/starlark_tests/resources:resource_bundle",
    ],
    tags = FIXTURE_TAGS,
    deps = [
        "//test/starlark_tests/resources:watchkit_ext_main_lib",
    ],
)

watchos_extension(
    name = "ext_with_imported_fmwk",
    bundle_id = "com.google.example.ext",
    entitlements = "//test/starlark_tests/resources:entitlements.plist",
    infoplists = [
        "//test/starlark_tests/resources:WatchosExtensionInfo.plist",
    ],
    ipa_post_processor = "//test/starlark_tests/targets_under_test/apple:ipa_post_processor_verify_codesigning",
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    deps = [
        ":dynamic_fmwk_depending_lib",
        "//test/starlark_tests/resources:watchkit_ext_main_lib",
    ],
)

watchos_extension(
    name = "ext_multiple_infoplists",
    bundle_id = "com.google.example.ext",
    infoplists = [
        "//test/starlark_tests/resources:Another.plist",
        "//test/starlark_tests/resources:WatchosExtensionInfo.plist",
    ],
    minimum_os_version = "4.0",
    tags = FIXTURE_TAGS,
)

ios_application(
    name = "app_companion",
    bundle_id = "com.google",
    families = ["iphone"],
    infoplists = [
        "//test/starlark_tests/resources:Info.plist",
    ],
    minimum_os_version = "8.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    watch_application = ":app",
    deps = [
        "//test/starlark_tests/resources:objc_main_lib",
    ],
)

# ---------------------------------------------------------------------------------------

watchos_static_framework(
    name = "static_fmwk",
    hdrs = [
        "//test/starlark_tests/resources:shared.h",
    ],
    minimum_os_version = "4.0",
    tags = FIXTURE_TAGS,
    deps = [
        "//test/starlark_tests/resources:objc_shared_lib",
    ],
)

# ---------------------------------------------------------------------------------------

objc_library(
    name = "dynamic_fmwk_depending_lib",
    srcs = ["@bazel_tools//tools/objc:dummy.c"],
    tags = FIXTURE_TAGS,
    deps = [":imported_watchos_dynamic_fmwk"],
)

apple_dynamic_framework_import(
    name = "imported_watchos_dynamic_fmwk",
    framework_imports = [":generated_watchos_dynamic_fmwk"],
    tags = FIXTURE_TAGS,
)

generate_import_framework(
    name = "generated_watchos_dynamic_fmwk",
    archs = ["i386"],
    libtype = "dynamic",
    minimum_os_version = "4.0",
    sdk = "watchsimulator",
    tags = FIXTURE_TAGS,
)

# ---------------------------------------------------------------------------------------

ios_application(
    name = "ios_with_swift_watchos_no_swift",
    bundle_id = "com.google",
    bundle_name = "companion",
    families = ["iphone"],
    infoplists = [
        "//test/starlark_tests/resources:Info.plist",
    ],
    minimum_os_version = "8.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    watch_application = ":watchos_app_no_swift",
    deps = [
        ":swift_lib",
    ],
)

ios_application(
    name = "ios_no_swift_watchos_with_swift",
    bundle_id = "com.google",
    bundle_name = "companion",
    families = ["iphone"],
    infoplists = [
        "//test/starlark_tests/resources:Info.plist",
    ],
    minimum_os_version = "8.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    watch_application = ":watchos_app_swift",
    deps = [
        "//test/starlark_tests/resources:objc_main_lib",
    ],
)

ios_application(
    name = "ios_with_swift_watchos_with_swift",
    bundle_id = "com.google",
    bundle_name = "companion",
    families = ["iphone"],
    infoplists = [
        "//test/starlark_tests/resources:Info.plist",
    ],
    minimum_os_version = "8.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    watch_application = ":watchos_app_swift",
    deps = [
        ":swift_lib",
    ],
)

ios_application(
    name = "ios_with_swift_watchos_with_swift_stable_abi",
    bundle_id = "com.google",
    bundle_name = "companion",
    families = ["iphone"],
    infoplists = [
        "//test/starlark_tests/resources:Info.plist",
    ],
    minimum_os_version = "12.2",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    watch_application = ":watchos_app_swift_stable_abi",
    deps = [
        ":swift_lib",
    ],
)

watchos_application(
    name = "watchos_app_no_swift",
    app_icons = ["//test/starlark_tests/resources:WatchAppIcon.xcassets"],
    bundle_id = "com.google.example",
    bundle_name = "app",
    extension = ":watchos_ext_no_swift",
    infoplists = [
        "//test/starlark_tests/resources:WatchosAppInfo.plist",
    ],
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
)

watchos_extension(
    name = "watchos_ext_no_swift",
    bundle_id = "com.google.example.ext",
    bundle_name = "ext",
    entitlements = "//test/starlark_tests/resources:entitlements.plist",
    infoplists = [
        "//test/starlark_tests/resources:WatchosExtensionInfo.plist",
    ],
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    deps = [
        "//test/starlark_tests/resources:objc_main_lib",
    ],
)

watchos_application(
    name = "watchos_app_swift",
    app_icons = ["//test/starlark_tests/resources:WatchAppIcon.xcassets"],
    bundle_id = "com.google.example",
    bundle_name = "app",
    extension = ":watchos_ext_swift",
    infoplists = [
        "//test/starlark_tests/resources:WatchosAppInfo.plist",
    ],
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
)

watchos_extension(
    name = "watchos_ext_swift",
    bundle_id = "com.google.example.ext",
    bundle_name = "ext",
    entitlements = "//test/starlark_tests/resources:entitlements.plist",
    infoplists = [
        "//test/starlark_tests/resources:WatchosExtensionInfo.plist",
    ],
    minimum_os_version = "4.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    deps = [
        "//test/starlark_tests/resources:watchkit_ext_main_lib",
    ],
)

watchos_application(
    name = "watchos_app_swift_stable_abi",
    app_icons = ["//test/starlark_tests/resources:WatchAppIcon.xcassets"],
    bundle_id = "com.google.example",
    bundle_name = "app",
    extension = ":watchos_ext_swift_stable_abi",
    infoplists = [
        "//test/starlark_tests/resources:WatchosAppInfo.plist",
    ],
    minimum_os_version = "6.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
)

watchos_extension(
    name = "watchos_ext_swift_stable_abi",
    bundle_id = "com.google.example.ext",
    bundle_name = "ext",
    entitlements = "//test/starlark_tests/resources:entitlements.plist",
    infoplists = [
        "//test/starlark_tests/resources:WatchosExtensionInfo.plist",
    ],
    minimum_os_version = "6.0",
    provisioning_profile = "//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    tags = FIXTURE_TAGS,
    deps = [
        "//test/starlark_tests/resources:watchkit_ext_main_lib",
    ],
)

swift_library(
    name = "swift_lib",
    srcs = ["//test/testdata/sources:main.swift"],
    tags = FIXTURE_TAGS,
)

# ---------------------------------------------------------------------------------------

swift_library(
    name = "basic_framework_lib",
    module_name = "BasicFramework",
    srcs = [
        "//test/starlark_tests/resources:BasicFramework.swift",
        "//test/starlark_tests/resources:main.swift",
    ],
    visibility = ["//visibility:public"],
    features = ["swift.no_generated_module_map"],
    tags = FIXTURE_TAGS,
)

watchos_dynamic_framework(
    name = "basic_framework",
    bundle_name = "BasicFramework",
    bundle_id = "com.google.example.framework",
    infoplists = [
        "//test/starlark_tests/resources:Info-watchos.plist",
    ],
    minimum_os_version = "6.0",
    tags = FIXTURE_TAGS,
    deps = [
        ":basic_framework_lib",
    ],
)

swift_library(
    name = "basic_framework_with_direct_dependency_lib",
    module_name = "DirectDependencyTest",
    srcs = [
        "//test/starlark_tests/resources:DirectDependencyTest.swift",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":basic_framework_lib",
    ],
    features = ["swift.no_generated_module_map"],
    tags = FIXTURE_TAGS,
)

watchos_dynamic_framework(
    name = "basic_framework_with_direct_dependency",
    bundle_name = "DirectDependencyTest",
    bundle_id = "com.google.example.framework",
    infoplists = [
        "//test/starlark_tests/resources:Info-watchos.plist",
    ],
    minimum_os_version = "6.0",
    tags = FIXTURE_TAGS,
    deps = [
        ":basic_framework_with_direct_dependency_lib",
    ],
)

swift_library(
    name = "basic_framework_with_transitive_dependency_lib",
    module_name = "TransitiveDependencyTest",
    srcs = [
        "//test/starlark_tests/resources:TransitiveDependencyTest.swift",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":basic_framework_lib",
        ":basic_framework_with_direct_dependency_lib",
    ],
    features = ["swift.no_generated_module_map"],
    tags = FIXTURE_TAGS,
)

watchos_dynamic_framework(
    name = "basic_framework_with_transitive_dependency",
    bundle_name = "TransitiveDependencyTest",
    bundle_id = "com.google.example.framework",
    infoplists = [
        "//test/starlark_tests/resources:Info-watchos.plist",
    ],
    minimum_os_version = "6.0",
    tags = FIXTURE_TAGS,
    deps = [
        ":basic_framework_with_transitive_dependency_lib",
    ],
)
