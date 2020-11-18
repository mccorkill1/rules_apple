# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""ios_dynamic_framework Starlark tests."""

load(
    ":rules/common_verification_tests.bzl",
    "archive_contents_test",
)
load(
    ":rules/infoplist_contents_test.bzl",
    "infoplist_contents_test",
)

def ios_dynamic_framework_test_suite(name = "ios_dynamic_framework"):
    """Test suite for ios_dynamic_framework.

    Args:
        name: The name prefix for all the nested tests
    """

    archive_contents_test(
        name = "{}_archive_contents_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:basic_framework",
        binary_test_file = "$BUNDLE_ROOT/BasicFramework",
        binary_test_architecture = "x86_64",
        macho_load_commands_contain = ["name @rpath/BasicFramework.framework/BasicFramework (offset 24)"],
        contains = [
            "$BUNDLE_ROOT/BasicFramework",
            "$BUNDLE_ROOT/Headers/BasicFramework.h",
            "$BUNDLE_ROOT/Info.plist",
            "$BUNDLE_ROOT/Modules/module.modulemap",
            "$BUNDLE_ROOT/Modules/BasicFramework.swiftmodule/x86_64.swiftdoc",
            "$BUNDLE_ROOT/Modules/BasicFramework.swiftmodule/x86_64.swiftmodule"
        ],
        tags = [name],
    )
    
    infoplist_contents_test(
        name = "{}_plist_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:basic_framework",
        expected_values = {
            "BuildMachineOSBuild": "*",
            "CFBundleExecutable": "BasicFramework",
            "CFBundleIdentifier": "com.google.example.framework",
            "CFBundleName": "BasicFramework",
            "CFBundleSupportedPlatforms:0": "iPhone*",
            "DTCompiler": "com.apple.compilers.llvm.clang.1_0",
            "DTPlatformBuild": "*",
            "DTPlatformName": "iphone*",
            "DTPlatformVersion": "*",
            "DTSDKBuild": "*",
            "DTSDKName": "iphone*",
            "DTXcode": "*",
            "DTXcodeBuild": "*",
            "MinimumOSVersion": "8.0",
            "UIDeviceFamily:0": "1",
        },
        tags = [name],
    )

    archive_contents_test(
        name = "{}_direct_dependency_archive_contents_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:basic_framework_with_direct_dependency",
        binary_test_file = "$BUNDLE_ROOT/DirectDependencyTest",
        binary_test_architecture = "x86_64",
        macho_load_commands_contain = ["name @rpath/DirectDependencyTest.framework/DirectDependencyTest (offset 24)"],
        contains = [
            "$BUNDLE_ROOT/DirectDependencyTest",
            "$BUNDLE_ROOT/Headers/DirectDependencyTest.h",
            "$BUNDLE_ROOT/Info.plist",
            "$BUNDLE_ROOT/Modules/module.modulemap",
            "$BUNDLE_ROOT/Modules/DirectDependencyTest.swiftmodule/x86_64.swiftdoc",
            "$BUNDLE_ROOT/Modules/DirectDependencyTest.swiftmodule/x86_64.swiftmodule"
        ],
        tags = [name],
    )

    archive_contents_test(
        name = "{}_transitive_dependency_archive_contents_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:basic_framework_with_transitive_dependency",
        binary_test_file = "$BUNDLE_ROOT/TransitiveDependencyTest",
        binary_test_architecture = "x86_64",
        macho_load_commands_contain = ["name @rpath/TransitiveDependencyTest.framework/TransitiveDependencyTest (offset 24)"],
        contains = [
            "$BUNDLE_ROOT/TransitiveDependencyTest",
            "$BUNDLE_ROOT/Headers/TransitiveDependencyTest.h",
            "$BUNDLE_ROOT/Info.plist",
            "$BUNDLE_ROOT/Modules/module.modulemap",
            "$BUNDLE_ROOT/Modules/TransitiveDependencyTest.swiftmodule/x86_64.swiftdoc",
            "$BUNDLE_ROOT/Modules/TransitiveDependencyTest.swiftmodule/x86_64.swiftmodule"
        ],
        tags = [name],
    )

    # Tests that libraries that both apps and frameworks depend only have symbols
    # present in the framework.
    archive_contents_test(
        name = "{}_symbols_from_shared_library_in_framework".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_dynamic_framework_and_resources",
        binary_test_architecture = "x86_64",
        binary_test_file = "$BUNDLE_ROOT/Frameworks/swift_lib_with_resources.framework/swift_lib_with_resources",
        binary_contains_symbols = ["_$s24swift_lib_with_resources16dontCallMeSharedyyF"],
        tags = [name],
    )

    archive_contents_test(
        name = "{}_symbols_from_shared_library_not_in_application".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_dynamic_framework_and_resources",
        binary_test_file = "$BUNDLE_ROOT/app_with_dynamic_framework_and_resources",
        binary_test_architecture = "x86_64",
        binary_not_contains_symbols = ["_$s24swift_lib_with_resources16dontCallMeSharedyyF"],
        tags = [name],
    )

    archive_contents_test(
        name = "{}_app_includes_transitive_framework_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_dynamic_framework_with_dynamic_framework",
        binary_test_file = "$BUNDLE_ROOT/Frameworks/swift_transitive_lib.framework/swift_transitive_lib",
        binary_test_architecture = "x86_64",
        contains = [
            "$BUNDLE_ROOT/Frameworks/swift_transitive_lib.framework/swift_transitive_lib",
            "$BUNDLE_ROOT/Frameworks/swift_transitive_lib.framework/Info.plist",
            "$BUNDLE_ROOT/Frameworks/swift_shared_lib.framework/swift_shared_lib",
            "$BUNDLE_ROOT/Frameworks/swift_shared_lib.framework/Info.plist",
        ],
        not_contains = [
            "$BUNDLE_ROOT/Frameworks/swift_transitive_lib.framework/Frameworks/",
            "$BUNDLE_ROOT/Frameworks/swift_transitive_lib.framework/nonlocalized.plist",
            "$BUNDLE_ROOT/framework_resources/nonlocalized.plist",
        ],
        binary_contains_symbols = ["_$s20swift_transitive_lib21anotherFunctionSharedyyF"],
        tags = [name],
    )

    archive_contents_test(
        name = "{}_app_includes_transitive_framework_symbols_not_in_app".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_dynamic_framework_with_dynamic_framework",
        binary_test_file = "$BUNDLE_ROOT/app_with_dynamic_framework_with_dynamic_framework",
        binary_test_architecture = "x86_64",
        binary_not_contains_symbols = ["_$s20swift_transitive_lib21anotherFunctionSharedyyF"],
        tags = [name],
    )

    native.test_suite(
        name = name,
        tags = [name],
    )
