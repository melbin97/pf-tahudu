//
//  SearchView.swift
//  Tahudu
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    
    init(listingsFetching: ListingsService, keyValueStore: StorageService) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(listingsFetching: listingsFetching,
                                                               keyValueStore: keyValueStore))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            toolBar
            ClearableTextField(label: "City, area or building", symbol: "magnifyingglass", text: $viewModel.searchText) { _ in
                //TODO: So something with input data
            }
            if viewModel.displayListings.isEmpty {
                noFavourites
            } else {
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
                        .foregroundStyle(viewModel.showFavouritesOnly ? .red : .blue)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

extension SearchView {
    var noFavourites: some View {
        VStack {
            Spacer()
            HStack(spacing: 4) {
                Spacer()
                Image("sad")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.gray)
                Text("You don't have any favourites!")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
            }
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(listingsFetching: AppDependencies.preview().listingsFetching, keyValueStore: AppDependencies.preview().keyValueStore)
    }
}
