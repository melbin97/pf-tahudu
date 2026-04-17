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
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var listingFilter: ListingFilter = ListingFilter()
    
    @Published var favoriteIds: Set<String> = [] {
        didSet {
            keyValueStore.save(value: favoriteIds, key: .favourites)
        }
    }
    
    private var listingService: ListingService
    private var keyValueStore: StorageService
    
    init(listingService: ListingService, keyValueStore: StorageService) {
        self.listingService = listingService
        self.keyValueStore = keyValueStore
        self.loadFavourites()
    }
    
    // Drives the UI list
    var displayListings: [Listing] {
        listings.filter(listingByFavourite)
    }
    
    // View state
    var listViewState: ListViewState {
        guard !isLoading else { return .loading }
        guard !hasError else { return .apiError }
        guard displayListings.isEmpty else { return .loaded }
        
        if listingFilter.showFavouritesOnly {
            return .emptyState(.noFavourites)
        } else {
            return .emptyState(.noData)
        }
    }
    
    // Calls the API service via listing manager
    func getListings() async {
        defer { isLoading = false }
        isLoading = true
        hasError = false
        do {
            let response = try await listingService.getListings()
            listings = response.listings
        } catch(let error) {
            //Not using this error now. Showing generic erro screen.
            print("DEBUG - SearchViewModel: Listing error: \(error.localizedDescription)")
            hasError = true
        }
    }
    
    func onContactTap(contactType: ContactType) {
        print("\(contactType.rawValue) Tapped")
    }
    
    // loads favourites into memory
    func loadFavourites() {
        self.favoriteIds = keyValueStore.get(key: .favourites) ?? []
    }
    
    // Set a particular listing as fav or remove a listing as fav
    func toggleFavourites(id: String) {
        if favoriteIds.contains(id) {
            favoriteIds.remove(id)
        } else {
            favoriteIds.insert(id)
        }
    }
    
    // Check to see if a listing is fav
    func isFavourite(id: String) -> Bool {
        return favoriteIds.contains(id)
    }
    
    // For filtering display data
    private func listingByFavourite(_ listing: Listing) -> Bool {
        guard listingFilter.showFavouritesOnly else { return true }
        return isFavourite(id: listing.id)
    }
}

extension SearchViewModel {
    enum ListViewState: Equatable {
        case loading
        case loaded
        case apiError
        case emptyState(EmptyState)
    }
}
