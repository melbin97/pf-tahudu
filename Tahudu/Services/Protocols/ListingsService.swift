//
//  ListingsService.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//

import Foundation

protocol ListingsService {
    func getListings() async throws -> ListingResponse
}
