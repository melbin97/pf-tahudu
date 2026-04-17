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
    
    var displayListings: [Listing] {
        listings.filter(listingByFavourite)
    }
    
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
    
    func getListings() async {
        defer { isLoading = false }
        isLoading = true
        hasError = false
        do {
            let response = try await listingService.getListings()
            listings = response.listings
        } catch(let error) {
            print("DEBUG - SearchViewModel: Listing error: \(error.localizedDescription)")
            isLoading = false
            hasError = true
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
        case apiError
        case emptyState(EmptyState)
    }
}
