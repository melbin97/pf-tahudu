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

struct Listing: Codable, Identifiable {
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

extension Listing {
    static func mockList() -> [Listing] {
        return [
            // 1. Full data - Apartment
            .init(
                id: "prop_005",
                type: .apartment,
                deliveryYear: 2024,
                price: 2650000,
                currency: "AED",
                priceInclusive: true,
                location: "Address Jumeirah Beach Residence, JBR",
                bedrooms: 2,
                bathrooms: 3,
                areaSqft: 1450,
                publishedAt: Date(),
                lastContactedAt: Date().addingTimeInterval(-86400),
                tags: [.verified, .new_construction, .sea_view],
                images: ["FirstImage", "SecondImage"],
                contactOptions: [.phone, .email, .whatsApp]
            ),
            
            // 2. Data with nil bedrooms (Studio) - Apartment
            .init(
                id: "prop_001",
                type: .apartment,
                deliveryYear: 2022,
                price: 2575000,
                currency: "AED",
                priceInclusive: true,
                location: "Laguna Tower, JLT",
                bedrooms: nil, // Testing null handling
                bathrooms: 1,
                areaSqft: 1356,
                publishedAt: Date().addingTimeInterval(-172800),
                lastContactedAt: nil,
                tags: [.verified, .live_viewing],
                images: ["FirstImage"],
                contactOptions: [.phone, .whatsApp]
            ),
            
            // 3. Different Property Type - Villa
            .init(
                id: "prop_006",
                type: .villa,
                deliveryYear: 2020,
                price: 4850000,
                currency: "AED",
                priceInclusive: false,
                location: "Arabian Ranches 2, Dubai",
                bedrooms: 4,
                bathrooms: 5,
                areaSqft: 3800,
                publishedAt: Date().addingTimeInterval(-604800),
                lastContactedAt: nil,
                tags: [.exclusive, .verified],
                images: ["SecondImage"],
                contactOptions: [.phone]
            )
        ]
    }
}
