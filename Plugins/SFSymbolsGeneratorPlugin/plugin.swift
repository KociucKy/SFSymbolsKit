import PackagePlugin
import Foundation

@main
struct SFSymbolsGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let generatorTool = try context.tool(named: "SFSymbolsGenerator")

        // Locate the plist resources bundled in the package's Resources/ directory.
        // The plugin receives the package directory via context.package.directoryURL.
        let resourcesDir = context.package.directoryURL.appending(path: "Resources")
        let categoriesPlist = resourcesDir.appending(path: "categories.plist")
        let symbolCategoriesPlist = resourcesDir.appending(path: "symbol_categories.plist")

        // Output directory managed by SPM (inside DerivedData).
        let outputDir = context.pluginWorkDirectoryURL.appending(path: "GeneratedSources")

        return [
            .buildCommand(
                displayName: "Generate SFSymbols Swift sources",
                executable: generatorTool.url,
                arguments: [
                    categoriesPlist.path(percentEncoded: false),
                    symbolCategoriesPlist.path(percentEncoded: false),
                    outputDir.path(percentEncoded: false),
                ],
                inputFiles: [
                    categoriesPlist,
                    symbolCategoriesPlist,
                ],
                outputFiles: [
                    outputDir.appending(path: "SFSymbolCategory.swift"),
                    outputDir.appending(path: "GeneratedSymbols.swift"),
                ]
            )
        ]
    }
}
