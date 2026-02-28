import SFSymbolsKitCore
import SwiftUI

// MARK: - SymbolPickerView

/// A SwiftUI view that lets the user browse and select an SF Symbol.
///
/// Present a filtered subset by passing specific categories:
/// ```swift
/// SymbolPickerView(
///     categories: [.communication, .weather],
///     selection: $selectedSymbol
/// )
/// ```
///
/// Pass an empty array (the default) to show all symbols:
/// ```swift
/// SymbolPickerView(selection: $selectedSymbol)
/// ```
public struct SymbolPickerView: View {
	/// The categories available in this picker. Empty means all symbols.
	public let categories: [SFSymbolCategory]

	/// The currently selected symbol, or `nil` if none.
	@Binding public var selection: AnySymbol?

	@State private var viewModel: SymbolPickerViewModel

	public init(
		categories: [SFSymbolCategory] = [],
		selection: Binding<AnySymbol?>
	) {
		self.categories = categories
		self._selection = selection
		self._viewModel = State(
			wrappedValue: SymbolPickerViewModel(categories: categories)
		)
	}

	public var body: some View {
		@Bindable var viewModel = viewModel
		VStack(spacing: 0) {
			// Search bar
			searchBar(searchText: $viewModel.searchText)

			// Category filter pills (only shown when more than one category available)
			if viewModel.availableCategories.count > 1 {
				categoryFilterBar
					.padding(.vertical, 12)
					.padding(.bottom, 8)
				Divider()
			}

			// Symbol grid
			SymbolPickerGrid(
				symbols: viewModel.filteredSymbols,
				selection: selection,
				onSelect: { symbol in
					selection = symbol
				}
			)
		}
	}

	// MARK: - Subviews

	private func searchBar(searchText: Binding<String>) -> some View {
		HStack(spacing: 8) {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(.secondary)
			TextField("Search symbols", text: searchText)
				.textFieldStyle(.plain)
				.autocorrectionDisabled()
			if !searchText.wrappedValue.isEmpty {
				Button {
					searchText.wrappedValue = ""
				} label: {
					Image(systemName: "xmark.circle.fill")
						.foregroundStyle(.secondary)
				}
				.buttonStyle(.plain)
			}
		}
		.padding(12)
		.background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
		.padding(.horizontal, 16)
		.padding(.top, 16)
		.padding(.bottom, 8)
	}

	private var categoryFilterBar: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				ForEach(viewModel.availableCategories) { category in
					CategoryPill(
						category: category,
						isActive: viewModel.activeCategories.contains(category),
						onToggle: {
							if viewModel.activeCategories.contains(category) {
								viewModel.activeCategories.remove(category)
							} else {
								viewModel.activeCategories.insert(category)
							}
						}
					)
				}
			}
			.padding(.horizontal, 16)
		}
	}
}

// MARK: - CategoryPill

@MainActor
private struct CategoryPill: View {
	let category: SFSymbolCategory
	let isActive: Bool
	let onToggle: () -> Void

	var body: some View {
		Button(action: onToggle) {
			HStack(spacing: 4) {
				Image(systemName: category.iconSymbolName)
					.font(.system(size: 12, weight: .medium))
				Text(category.label)
					.font(.system(size: 13, weight: .medium))
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 6)
			.foregroundStyle(isActive ? AnyShapeStyle(.white) : AnyShapeStyle(.primary))
			.background(
				Capsule(style: .continuous)
					.fill(isActive ? AnyShapeStyle(Color.accentColor) : AnyShapeStyle(Color.primary.opacity(0.08)))
			)
		}
		.buttonStyle(.plain)
		.accessibilityLabel(category.label)
		.accessibilityAddTraits(isActive ? .isSelected : [])
	}
}

// MARK: - Preview

#Preview {
	@Previewable @State var selectedSymbol: AnySymbol?

	SymbolPickerView(
		categories: [.communication, .weather, .nature, .commerce],
		selection: $selectedSymbol
	)
}
