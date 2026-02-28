// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SFSymbolsKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "SFSymbolsKitCore",
            targets: ["SFSymbolsKitCore"]
        ),
        .library(
            name: "SFSymbolsKitUI",
            targets: ["SFSymbolsKitUI"]
        ),
    ],
    targets: [
        // MARK: - Generator executable (invoked by the build plugin)
        .executableTarget(
            name: "SFSymbolsGenerator",
            path: "GeneratorTool",
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),

        // MARK: - Build tool plugin
        .plugin(
            name: "SFSymbolsGeneratorPlugin",
            capability: .buildTool(),
            dependencies: ["SFSymbolsGenerator"]
        ),

        // MARK: - Core library (no SwiftUI dependency)
        .target(
            name: "SFSymbolsKitCore",
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ],
            plugins: ["SFSymbolsGeneratorPlugin"]
        ),

        // MARK: - UI library (SwiftUI, depends on Core)
        .target(
            name: "SFSymbolsKitUI",
            dependencies: ["SFSymbolsKitCore"],
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),

        // MARK: - Tests
        .testTarget(
            name: "SFSymbolsKitCoreTests",
            dependencies: ["SFSymbolsKitCore"],
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
    ]
)
