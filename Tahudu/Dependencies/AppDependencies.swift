//
//  AppDependencies.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

struct AppDependencies {
    let listingsFetching: ListingsFetching
    let keyValueStore: StorageService
    
    static func live() -> AppDependencies {
        let apiClient = URLSessionAPIClient()
        let listings = ListingManager(apiClient: apiClient)
        let userDefaultsStorage = UserDefaultsStorage()
        return AppDependencies(listingsFetching: listings, keyValueStore: userDefaultsStorage)
    }
    
    static func preview() -> AppDependencies {
        return AppDependencies(listingsFetching: MockListingsFetching(), keyValueStore: MockStorage())
    }
}

// Example mock (put in same file or Previews/Mocks)
final class MockListingsFetching: ListingsFetching {
    func getListings() async throws -> ListingResponse {
        ListingResponse(listings: Listing.mockList())
    }
}

final class MockStorage: StorageService {
    func save<T>(value: T, key: StorageKeys) where T : Encodable {}
    
    func get<T>(key: StorageKeys) -> T? where T : Decodable {
        return nil
    }
    
    
}
