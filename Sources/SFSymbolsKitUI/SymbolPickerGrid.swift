import SwiftUI
import SFSymbolsKitCore

// MARK: - SymbolPickerGrid

/// A lazy grid of SF Symbol cells. Calls `onSelect` when the user taps a symbol.
@MainActor
struct SymbolPickerGrid: View {
    let symbols: [AnySymbol]
    let selection: AnySymbol?
    let onSelect: (AnySymbol) -> Void

    private let columns = [GridItem(.adaptive(minimum: 50, maximum: 64), spacing: 10)]

    var body: some View {
        ScrollView {
            if symbols.isEmpty {
                ContentUnavailableView(
                    "No Symbols",
                    systemImage: "questionmark.square.dashed",
                    description: Text("Try a different search or category.")
                )
                .padding(.top, 60)
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(symbols, id: \.rawValue) { symbol in
                        SymbolCell(
                            symbol: symbol,
                            isSelected: symbol == selection,
                            onSelect: onSelect
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
    }
}

// MARK: - SymbolCell

@MainActor
private struct SymbolCell: View {
    let symbol: AnySymbol
    let isSelected: Bool
    let onSelect: (AnySymbol) -> Void

    var body: some View {
        Button {
            onSelect(symbol)
        } label: {
            Image(systemName: symbol.rawValue)
                .font(.system(size: 22))
                .frame(width: 50, height: 50)
                .foregroundStyle(isSelected ? AnyShapeStyle(.white) : AnyShapeStyle(.primary))
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? AnyShapeStyle(Color.accentColor) : AnyShapeStyle(Color.primary.opacity(0.06)))
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(symbol.rawValue)
    }
}
