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
    
    var favs = Set<String>()
    
    private var listingsManager: ListingsFetching
    
    init(listingsFetching: ListingsFetching) {
        self.listingsManager = listingsFetching
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
}
