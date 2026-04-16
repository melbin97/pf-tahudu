//
//  ListingManager.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

class ListingManager: ListingsFetching {
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getListings() async throws -> ListingResponse {
        return try await apiClient.fetch(url: "https://simplejsoncms.com/api/m6nfoc4jlw")
    }
}
