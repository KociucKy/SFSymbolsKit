import Observation
import SFSymbolsKitCore

// MARK: - SymbolPickerViewModel

@Observable
@MainActor
final class SymbolPickerViewModel {
    // The full list of categories available in this picker instance.
    let availableCategories: [SFSymbolCategory]

    // Currently active category filters. Empty means "show all available".
    var activeCategories: Set<SFSymbolCategory> = []

    // Search text entered by the user.
    var searchText: String = ""

    init(categories: [SFSymbolCategory]) {
        self.availableCategories = categories
    }

    /// The symbols to display given current filters and search text.
    var filteredSymbols: [AnySymbol] {
        let pool: [AnySymbol]
        if activeCategories.isEmpty {
            // No filter active — pool is the union of all available categories,
            // or all symbols if the caller passed no restrictions.
            if availableCategories.isEmpty {
                pool = AnySymbol.allSymbols
            } else {
                let keys = Set(availableCategories)
                pool = AnySymbol.allSymbols.filter { symbol in
                    symbol.categories.contains(where: { keys.contains($0) })
                }
            }
        } else {
            pool = AnySymbol.allSymbols.filter { symbol in
                symbol.categories.contains(where: { activeCategories.contains($0) })
            }
        }

        guard !searchText.isEmpty else { return pool }
        let query = searchText.lowercased()
        return pool.filter { $0.rawValue.contains(query) }
    }
}
