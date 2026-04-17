//
//  SearchViewModel.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var listingFilter: ListingFilter = ListingFilter() {
        didSet {
            updateListViewState()
        }
    }
    @Published var listViewState: ListViewState = .loading
    
    @Published var favoriteIds: Set<String> = [] {
        didSet {
            keyValueStore.save(value: favoriteIds, key: .favourites)
        }
    }
    
    private var listingsManager: ListingsService
    private var keyValueStore: StorageService
    
    var displayListings: [Listing] {
        listings.filter(listingByFavourite)
    }
    
    init(listingsFetching: ListingsService, keyValueStore: StorageService) {
        self.listingsManager = listingsFetching
        self.keyValueStore = keyValueStore
        self.loadFavourites()
    }
    
    func getListings() async {
        listViewState = .loading
        do {
            let response = try await listingsManager.getListings()
            listings = response.listings
            updateListViewState()
        } catch(let error) {
            print("DEBUG - SearchViewModel: Listing error: \(error.localizedDescription)")
            listViewState = .error
        }
    }
    
    func onContactTap(contactType: ContactType) {
        print("\(contactType.rawValue) Tapped")
    }
    
    func loadFavourites() {
        self.favoriteIds = keyValueStore.get(key: .favourites) ?? []
    }
    
    func toggleFavourites(id: String) {
        if favoriteIds.contains(id) {
            favoriteIds.remove(id)
        } else {
            favoriteIds.insert(id)
        }
        updateListViewState()
    }
    
    func isFavourite(id: String) -> Bool {
        return favoriteIds.contains(id)
    }
    
    private func listingByFavourite(_ listing: Listing) -> Bool {
        guard listingFilter.showFavouritesOnly else { return true }
        return isFavourite(id: listing.id)
    }
}


extension SearchViewModel {
    enum ListViewState: Equatable {
        case loading
        case loaded
        case error
        case emptyState(EmptyState)
    }
    
    fileprivate func updateListViewState() {
        if displayListings.isEmpty {
            if listingFilter.showFavouritesOnly {
                listViewState = .emptyState(.noFavourites)
            } else {
                listViewState = .emptyState(.noData)
            }
        } else {
            listViewState = .loaded
        }
    }
}
