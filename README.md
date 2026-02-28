# SFSymbolsKit

A Swift Package that provides type-safe access to SF Symbols, grouped into Apple's official categories, with a ready-made SwiftUI picker view.

## Features

- **Type-safe symbols** — per-category enums (e.g. `CommunicationSymbol`, `WeatherSymbol`) generated at build time from the SF Symbols metadata shipped with Xcode
- **31 official categories** — mirrors the groupings in the SF Symbols app (Communication, Weather, Maps, …)
- **`AnySymbol`** — a type-erased wrapper for storing or passing symbols without coupling to a specific category
- **`SymbolPickerView`** — a SwiftUI picker with a search field and toggleable category filter pills
- **Build-time code generation** — an SPM build plugin runs `SFSymbolsGenerator` on every build; re-run after updating the bundled plists to pick up new symbols
- **Swift 6** strict concurrency throughout

## Requirements

| | Minimum |
|---|---|
| iOS | 17.0 |
| macOS | 14.0 |
| tvOS | 17.0 |
| watchOS | 10.0 |
| Swift | 6.0 |

## Installation

Add the package in Xcode via **File → Add Package Dependencies** or in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/SFSymbolsKit", from: "1.0.0"),
],
```

Then add the products you need to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "SFSymbolsKitCore", package: "SFSymbolsKit"),
        .product(name: "SFSymbolsKitUI",   package: "SFSymbolsKit"),
    ]
)
```

Import only `SFSymbolsKitCore` if you don't need the picker UI (e.g. in a framework target with no SwiftUI dependency).

## Usage

### Type-safe symbols

Every official category has its own `CaseIterable` enum conforming to `SFSymbolProtocol`:

```swift
import SFSymbolsKitCore

let symbol = CommunicationSymbol.message
print(symbol.rawValue)   // "message"
print(symbol.symbolName) // "message"
print(symbol.categories) // [.communication]

// Use directly with SwiftUI Image
Image(systemName: symbol.rawValue)
```

### Browsing symbols by category

```swift
// All symbols in a category
let weatherSymbols = SFSymbolCategory.weather.symbols // [AnySymbol]

// All symbols across every category
let all = AnySymbol.allSymbols // [AnySymbol]
```

### Type-erased `AnySymbol`

Use `AnySymbol` when you need to store symbols from mixed categories:

```swift
let symbol = AnySymbol(CommunicationSymbol.message)
// or directly
let symbol = AnySymbol(rawValue: "message", categories: [.communication])
```

### `SymbolPickerView`

```swift
import SwiftUI
import SFSymbolsKitCore
import SFSymbolsKitUI

struct ContentView: View {
    @State private var selectedSymbol: AnySymbol?

    var body: some View {
        // Show symbols from specific categories only
        SymbolPickerView(
            categories: [.communication, .weather, .nature],
            selection: $selectedSymbol
        )

        // Or show all symbols
        SymbolPickerView(selection: $selectedSymbol)
    }
}
```

The picker includes:
- A **search field** that filters by symbol name
- A horizontal strip of **category filter pills** (shown when more than one category is available) — tap to toggle individual categories
- A **lazy grid** of symbol cells; the selected symbol is highlighted with the app's accent color

## Package Structure

```
SFSymbolsKit/
├── GeneratorTool/               # Swift executable — reads plists, emits Swift source
├── Plugins/
│   └── SFSymbolsGeneratorPlugin/# SPM build tool plugin — invokes the generator
├── Resources/
│   ├── categories.plist         # Apple's official category list
│   └── symbol_categories.plist  # Symbol → category mapping
├── Sources/
│   ├── SFSymbolsKitCore/        # SFSymbolProtocol, AnySymbol + generated enums
│   └── SFSymbolsKitUI/          # SymbolPickerView (SwiftUI)
└── Tests/
    └── SFSymbolsKitCoreTests/
```

### Updating symbols

The bundled plists are copied from `/Applications/SF Symbols.app/Contents/Resources/Metadata/`. To update to a newer version of SF Symbols:

1. Replace `Resources/categories.plist` and `Resources/symbol_categories.plist` with the new versions
2. Build — the plugin re-runs `SFSymbolsGenerator` automatically

## License

MIT
