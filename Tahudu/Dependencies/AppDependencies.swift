//
//  AppDependencies.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

struct AppDependencies {
    let listingsFetching: ListingsFetching
    
    static func live() -> AppDependencies {
        let apiClient = URLSessionAPIClient()
        let listings = ListingManager(apiClient: apiClient)
        return AppDependencies(listingsFetching: listings)
    }
    
    static func preview() -> AppDependencies {
        return AppDependencies(listingsFetching: MockListingsFetching())
    }
}

// Example mock (put in same file or Previews/Mocks)
final class MockListingsFetching: ListingsFetching {
    func getListings() async throws -> ListingResponse {
        ListingResponse(listings: Listing.mockList())
    }
}
