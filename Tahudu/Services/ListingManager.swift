//
//  ListingManager.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

final class ListingManager: ListingsService {
    
    let apiClient: APIService
    
    init(apiClient: APIService) {
        self.apiClient = apiClient
    }
    
    func getListings() async throws -> ListingResponse {
        return try await apiClient.fetch(url: "https://simplejsoncms.com/api/m6nfoc4jlw")
    }
}
