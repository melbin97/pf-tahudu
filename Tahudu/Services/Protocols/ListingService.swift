//
//  ListingService.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//

import Foundation

protocol ListingService {
    func getListings() async throws -> ListingResponse
}
