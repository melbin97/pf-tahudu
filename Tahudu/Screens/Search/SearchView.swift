//
//  SearchView.swift
//  Tahudu
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    
    init(listingService: ListingService, keyValueStore: StorageService) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(listingService: listingService,
                                                               keyValueStore: keyValueStore))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            toolBar
            ClearableTextField(label: "City, area or building", symbol: "magnifyingglass", text: $viewModel.listingFilter.searchText) { _ in
                //TODO: implement search later - out of scope fot Take home assignment.
            }
            switch viewModel.listViewState {
            case .loading, .loaded:
                listings
            case .apiError:
                EmptyStateView(emptyState: .apiError)
            case .emptyState(let emptyState):
                EmptyStateView(emptyState: emptyState)
            }
        }
        .padding(12)
        .redacted(reason: viewModel.listViewState == .loading ? .placeholder : [])
        .task {
            await viewModel.getListings()
        }
    }
}

extension SearchView {
    
    private var toolBar: some View {
        HStack(spacing: 20) {
            Group {
                Button {
                    print("Filter button tapped")
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 20, height: 20)
                }

                Button {
                    print("Sort button tapped")
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 20, height: 20)
                }

                Spacer()
                
                //MARK: I am using star here for the fav filter because in Task 1 the design shows star.
                // I feel like this should also have been heart so that it is consistent with rest of the fav symbol.
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    viewModel.listingFilter.showFavouritesOnly.toggle()
                } label: {
                    Image(systemName: viewModel.listingFilter.showFavouritesOnly ? "star.fill" : "star")
                        .resizable()
                        .foregroundStyle(viewModel.listingFilter.showFavouritesOnly ? .yellow : .blue)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

extension SearchView {
    var listings: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.displayListings) { listing in
                    ListingCardView(listingInfo: listing, isFavourite: viewModel.isFavourite(id: listing.id)) { contactType in
                        viewModel.onContactTap(contactType: contactType)
                    } toggleFavourite: { id in
                        viewModel.toggleFavourites(id: id)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(listingService: AppDependencies.preview().listingService, keyValueStore: AppDependencies.preview().keyValueStore)
    }
}
