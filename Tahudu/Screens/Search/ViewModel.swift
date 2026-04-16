//
//  ViewModel.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var listings: [Listing] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showFavouritesOnly = false
    
    @Published var favoriteIds: Set<String> = [] {
        didSet {
            keyValueStore.save(value: favoriteIds, key: .favourites)
        }
    }
    
    private var listingsManager: ListingsFetching
    private var keyValueStore: StorageService
    
    var displayListings: [Listing] {
        if showFavouritesOnly {
            return listings.filter({ favoriteIds.contains($0.id) })
        }
        return listings
    }
    
    init(listingsFetching: ListingsFetching, keyValueStore: StorageService) {
        self.listingsManager = listingsFetching
        self.keyValueStore = keyValueStore
    }
    
    func getListings() async {
        defer { isLoading = false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await listingsManager.getListings()
            listings = response.listings
        } catch(let error) {
            errorMessage = error.localizedDescription
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
}
