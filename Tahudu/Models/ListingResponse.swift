//
//  ListingResponse.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//

import Foundation

struct ListingResponse: Codable {
    let listings: [Listing]
}

struct Listing: Codable, Identifiable, Equatable {
    let id: String
    let type: PropertyType
    let deliveryYear: Int
    let price: Int
    let currency: String
    let priceInclusive: Bool
    let location: String
    let bedrooms: Int?
    let bathrooms: Int
    let areaSqft: Int
    let publishedAt: Date
    let lastContactedAt: Date?
    let tags: [Tag]
    let images: [String]
    let contactOptions: [ContactType]
    
    var displayPrice: String {
        price.formatted(.currency(code: currency))
    }
    
    var bedroomDisplayName: String {
        bedrooms.map { "\($0) \($0 == 1 ? "Bed" : "Beds")" } ?? "Studio"
    }
}

enum PropertyType: String, Codable {
    case apartment = "Apartment"
    case villa = "Villa"
    case townhouse = "Townhouse"
}

enum Tag: String, Codable {
    case verified
    case exclusive
    case price_reduced
    
    case new_construction
    case furnished
    case corner_unit
    
    case sea_view
    case high_floor
    case low_floor
    
    case live_viewing
    
    var displayName: String {
        return self.rawValue.replacingOccurrences(of: "_", with: " ").uppercased()
    }
}
