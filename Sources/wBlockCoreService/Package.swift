// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "wBlockCoreService",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .macCatalyst(.v15)
    ],
    products: [
        .library(
            name: "wBlockCoreService",
            type: .dynamic,
            targets: ["wBlockCoreService"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/AdguardTeam/SafariConverterLib.git",
            revision: "9e431a2"
        ),
        .package(
            url: "https://github.com/weichsel/ZIPFoundation.git",
            exact: "0.9.19"
        )
    ],
    targets: [
        .target(
            name: "wBlockCoreService",
            dependencies: [
                .product(name: "ContentBlockerConverter", package: "SafariConverterLib"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
            ],
            path: ".",
            exclude: [
                "create_xcframework.sh",
                "create_static_xcframework.sh",
                "verify_environment.sh",
                "build",
                "output",
                "build_simple",
                "output_simple",
                "build_final",
                "output_final",
                "build_xcode",
                "output_xcode",
                "module",
                "Package.swift",
                "wBlockCoreService.docc",
                "flutter_plugin_ios.swift",
                "flutter_plugin_macos.swift",
                "flutter_plugin_multiplatform.dart",
                "flutter_plugin_complete.podspec",
                "flutter_plugin_example.swift",
                "flutter_plugin_example.dart",
                "README_XCFRAMEWORK.md",
                "SETUP_COMPLETE.md",
                "MULTIPLATFORM_COMPLETE.md",
                "*.sh",
                "TempProject",
                "MODULE_INTERFACE_SOLUTIONS.md"
            ],
            sources: [
                "Constants.swift",
                "ContentBlockerExtensionRequestHandler.swift",
                "ContentBlockerMappingService.swift",
                "ContentBlockerTargets.swift",
                "FilterListCategory.swift",
                "GroupIdentifier.swift",
                "UserScript.swift",
                "UserScriptManager.swift",
                "Utils.swift",
                "WebExtensionRequestHandler.swift",
                "wBlockCoreService.swift"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("NO_XPC", .when(platforms: [.iOS, .macCatalyst])),
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-library-evolution"
                ])
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .macCatalyst])),
                .linkedFramework("AppKit", .when(platforms: [.macOS]))
            ]
        )
    ]
)
