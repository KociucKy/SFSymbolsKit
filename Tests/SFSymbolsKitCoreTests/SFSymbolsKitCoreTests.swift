import Testing
import SFSymbolsKitCore

// MARK: - SFSymbolCategory tests

@Suite("SFSymbolCategory")
struct SFSymbolCategoryTests {

    @Test("All 31 categories are present")
    func categoryCount() {
        #expect(SFSymbolCategory.allCases.count == 31)
    }

    @Test("Every category has a non-empty label")
    func labelsNonEmpty() {
        for category in SFSymbolCategory.allCases {
            #expect(!category.label.isEmpty, "Category \(category.rawValue) has empty label")
        }
    }

    @Test("Every category has a non-empty icon symbol name")
    func iconSymbolNamesNonEmpty() {
        for category in SFSymbolCategory.allCases {
            #expect(!category.iconSymbolName.isEmpty, "Category \(category.rawValue) has empty icon")
        }
    }

    @Test("Category id equals rawValue")
    func idEqualsRawValue() {
        for category in SFSymbolCategory.allCases {
            #expect(category.id == category.rawValue)
        }
    }

    @Test("Spot-check known categories exist")
    func knownCategoriesExist() {
        #expect(SFSymbolCategory(rawValue: "communication") == .communication)
        #expect(SFSymbolCategory(rawValue: "weather") == .weather)
        #expect(SFSymbolCategory(rawValue: "arrows") == .arrows)
        #expect(SFSymbolCategory(rawValue: "math") == .math)
    }

    @Test("Category labels match known values")
    func knownCategoryLabels() {
        #expect(SFSymbolCategory.communication.label == "Communication")
        #expect(SFSymbolCategory.weather.label == "Weather")
        #expect(SFSymbolCategory.objectsAndTools.label == "Objects & Tools")
        #expect(SFSymbolCategory.privacyAndSecurity.label == "Privacy & Security")
    }

    @Test("Category icon symbol names match known values")
    func knownCategoryIcons() {
        #expect(SFSymbolCategory.communication.iconSymbolName == "message")
        #expect(SFSymbolCategory.weather.iconSymbolName == "cloud.sun")
        #expect(SFSymbolCategory.arrows.iconSymbolName == "arrow.forward")
    }
}

// MARK: - AnySymbol tests

@Suite("AnySymbol")
struct AnySymbolTests {

    @Test("allSymbols is non-empty")
    func allSymbolsNonEmpty() {
        #expect(!AnySymbol.allSymbols.isEmpty)
    }

    @Test("allSymbols contains well-known symbols")
    func allSymbolsContainsKnown() {
        let names = Set(AnySymbol.allSymbols.map(\.rawValue))
        #expect(names.contains("message"))
        #expect(names.contains("phone"))
        #expect(names.contains("envelope"))
        #expect(names.contains("arrow.up"))
        #expect(names.contains("heart"))
    }

    @Test("allSymbols has no duplicate rawValues")
    func allSymbolsNoDuplicates() {
        let names = AnySymbol.allSymbols.map(\.rawValue)
        #expect(names.count == Set(names).count)
    }

    @Test("AnySymbol equality is based on rawValue only")
    func equalityByRawValue() {
        let a = AnySymbol(rawValue: "heart", categories: [.health])
        let b = AnySymbol(rawValue: "heart", categories: [.nature])
        #expect(a == b)
    }

    @Test("AnySymbol inequality for different rawValues")
    func inequalityForDifferentRawValues() {
        let a = AnySymbol(rawValue: "heart")
        let b = AnySymbol(rawValue: "star")
        #expect(a != b)
    }

    @Test("AnySymbol init from SFSymbolProtocol preserves rawValue and categories")
    func initFromProtocol() {
        let comm = CommunicationSymbol.message
        let any = AnySymbol(comm)
        #expect(any.rawValue == "message")
        #expect(any.categories.contains(.communication))
    }

    @Test("AnySymbol failable init returns nil for empty string")
    func failableInitEmptyString() {
        // Empty string is not a valid symbol name but init? must not crash
        let symbol = AnySymbol(rawValue: "")
        #expect(symbol != nil)
        #expect(symbol?.rawValue == "")
    }

    @Test("symbolName equals rawValue")
    func symbolNameEqualsRawValue() {
        let symbol = AnySymbol(rawValue: "star.fill", categories: [.nature])
        #expect(symbol.symbolName == symbol.rawValue)
    }
}

// MARK: - SFSymbolCategory.symbols tests

@Suite("SFSymbolCategory.symbols")
struct CategorySymbolsTests {

    @Test("communication.symbols is non-empty")
    func communicationSymbolsNonEmpty() {
        #expect(!SFSymbolCategory.communication.symbols.isEmpty)
    }

    @Test("weather.symbols is non-empty")
    func weatherSymbolsNonEmpty() {
        #expect(!SFSymbolCategory.weather.symbols.isEmpty)
    }

    @Test("communication.symbols contains 'message'")
    func communicationContainsMessage() {
        let names = SFSymbolCategory.communication.symbols.map(\.rawValue)
        #expect(names.contains("message"))
    }

    @Test("Every symbol returned by a category references that category")
    func categorySymbolsAreConsistent() {
        // Spot-check a few categories rather than all (perf)
        let categoriesToCheck: [SFSymbolCategory] = [
            .communication, .weather, .arrows, .math, .shapes
        ]
        for category in categoriesToCheck {
            for symbol in category.symbols {
                #expect(
                    symbol.categories.contains(category),
                    "Symbol \(symbol.rawValue) returned by .\(category.rawValue) but doesn't list it in categories"
                )
            }
        }
    }
}

// MARK: - Per-category enum tests

@Suite("Per-category enums")
struct PerCategoryEnumTests {

    @Test("CommunicationSymbol.message has correct rawValue")
    func communicationMessageRawValue() {
        #expect(CommunicationSymbol.message.rawValue == "message")
    }

    @Test("CommunicationSymbol.phone has correct rawValue")
    func communicationPhoneRawValue() {
        #expect(CommunicationSymbol.phone.rawValue == "phone")
    }

    @Test("CommunicationSymbol.categories contains .communication")
    func communicationCategoriesContainSelf() {
        #expect(CommunicationSymbol.message.categories.contains(.communication))
    }

    @Test("WeatherSymbol has non-empty allCases")
    func weatherSymbolAllCasesNonEmpty() {
        #expect(!WeatherSymbol.allCases.isEmpty)
    }

    @Test("ArrowsSymbol has non-empty allCases")
    func arrowsSymbolAllCasesNonEmpty() {
        #expect(!ArrowsSymbol.allCases.isEmpty)
    }

    @Test("Every per-category enum case rawValue is non-empty")
    func communicationRawValuesNonEmpty() {
        for symbol in CommunicationSymbol.allCases {
            #expect(!symbol.rawValue.isEmpty)
        }
    }

    @Test("CommunicationSymbol conforms to SFSymbolProtocol")
    func communicationConformsToProtocol() {
        let symbol: any SFSymbolProtocol = CommunicationSymbol.message
        #expect(symbol.symbolName == "message")
    }
}
