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
    var isFavourite: Bool
    var onContactTap: (ContactType) -> ()
    var toggleFavourite: (String) -> ()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                //carousal
                TabView {
                    ForEach(listingInfo.images, id: \.self) { image in
                        Image(image.pascalCase)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                // apartment details
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(listingInfo.type.rawValue)
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text(verbatim: "Delivery: \(listingInfo.deliveryYear)")
                                .bold()
                                .font(.caption2)
                                .padding(4)
                                .foregroundColor(.deliveryIndigo)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.indigo.opacity(0.05))
                                )
                        }
                        Text(listingInfo.displayPrice)
                            .bold()
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "house.lodge")
                                    .font(.caption)
                                    .foregroundColor(.black.opacity(0.8))
                                Text(listingInfo.bedroomDisplayName)
                                    .font(.caption)
                                    .foregroundStyle(.black.opacity(0.8))
                            }
                            Text(listingInfo.location)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                    }
                    Spacer()
                }
                .padding(.leading)
                Divider()
                // contact
                HStack {
                    VStack(alignment: .leading) {
                        Text("Published \(listingInfo.publishedAt.timeAgo())")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
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
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.5, blendDuration: 0)) {
                        toggleFavourite(listingInfo.id)
                    }
                } label: {
                    VStack {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .foregroundColor(isFavourite ? .red : .white)
                            .font(.system(size: 20, weight: .medium))
                            .scaleEffect(isFavourite ? 1.2 : 1.0)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(UIColor.separator), lineWidth: 1)
        )
    }
}

extension ListingCardView {
    private func badge(tag: Tag) -> some View {
        
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
        ListingCardView(listingInfo: Listing.mockList()[1], isFavourite: false) { type in
            print("Contact Type")
        } toggleFavourite: { _ in }
    }
}
