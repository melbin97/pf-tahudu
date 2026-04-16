//
//  SearchView.swift
//  Tahudu
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    
    init(listingsFetching: ListingsFetching, keyValueStore: StorageService) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(listingsFetching: listingsFetching,
                                                               keyValueStore: keyValueStore))
    }
    
    var body: some View {
        VStack {
            toolBar
            ClearableTextField(label: "City, area or building", symbol: "magnifyingglass", text: $viewModel.searchText) { _ in
                //TODO: print some statement
            }
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
        .padding(12)
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .task {
            await viewModel.getListings()
        }
        .onAppear {
            viewModel.loadFavourites()
        }
    }
}

extension SearchView {
    
    private var toolBar: some View {
        HStack(spacing: 20) {
            Group {
                Button {
                    //TODO: Do filter
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                Button {
                    //TODO: Do sort
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                Spacer()
                Button {
                    viewModel.showFavouritesOnly.toggle()
                } label: {
                    Image(systemName: viewModel.showFavouritesOnly ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(listingsFetching: AppDependencies.preview().listingsFetching, keyValueStore: AppDependencies.preview().keyValueStore)
    }
}
