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
            cSettings: [
                .define("NO_XPC", .when(platforms: [.iOS, .macCatalyst])),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .macCatalyst])),
                .linkedFramework("AppKit", .when(platforms: [.macOS]))
            ]
        )
    ]
)
