//
//  ListingCardView.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//

import Foundation
import SwiftUI

struct ListingCardView: View {
    var listingInfo: Listing
    var onContactTap: (ContactType) -> ()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                //carousal
                TabView {
                    ForEach(listingInfo.images, id: \.self) { image in
                        Image(image.pascalCase)
                            .resizable()
                    }
                }
                .cornerRadius(8)
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                // apartment details
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(listingInfo.type.rawValue)
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text("Delivery: \(listingInfo.deliveryYear)")
                                .font(.caption2)
                                .padding(4)
                                .foregroundColor(.blue)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.blue.opacity(0.2))
                                )
                        }
                        Text(listingInfo.displayPrice)
                            .bold()
                            .font(.headline)
                        HStack {
                            Image(systemName: "house.lodge")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.8))
                            Text(listingInfo.bedrooms == nil ? "Studio" : "\(listingInfo.bedrooms!) Beds" )
                                .font(.caption)
                                .foregroundStyle(.black.opacity(0.8))
                        }
                        .padding(4)
                    }
                    Spacer()
                }
                .padding(.leading)
                Divider()
                // contact
                HStack {
                    Text("Published \(listingInfo.publishedAt.timeAgo())")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    HStack(spacing: 12) {
                        ForEach(listingInfo.contactOptions, id: \.self) { option in
                            ContactButton(option) {
                                onContactTap(option)
                            }
                        }
                    }
                    
                }
                .padding()
                // last contact section
                if let lastContactedAt = listingInfo.lastContactedAt {
                    HStack {
                        Image(systemName: "phone.fill")
                            .font(.caption)
                        Text("Last contacted: \(lastContactedAt.timeAgo())")
                            .font(.caption)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.yellow.opacity(0.3))
                    )
                }
                
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    ForEach(listingInfo.tags, id: \.self) { tag in
                        badge(tag: tag)
                    }
                }
                Spacer()
                VStack {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray)
        )
    }
    
    func badge(tag: Tag) -> some View {
        
        var color: Color {
            switch tag {
            case .verified:
                return .green
            case .exclusive:
                return .green
            case .price_reduced:
                return .green
            case .new_construction, .furnished, .corner_unit:
                return .black.opacity(0.6)
            case .sea_view, .high_floor, .low_floor, .live_viewing:
                return .blue
            }
        }
        
        return (
            Text(tag.displayName)
                .bold()
                .font(.caption2)
                .padding(4)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                )
        )
    }
}


struct ListingCardView_Previews: PreviewProvider {
    static var previews: some View {
        ListingCardView(listingInfo: Listing.mockList()[1]) { type in
            print("Contact Type")
        }
    }
}
