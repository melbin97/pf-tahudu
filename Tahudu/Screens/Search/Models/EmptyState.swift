//
//  EmptyState.swift
//  Tahudu
//
//  Created by Melbin Mathew on 17/04/26.
//

enum EmptyState {
    case noData
    case apiError
    case noFavourites
    
    var description: String {
        switch self {
        case .noData:
            "There are no listings available at the moment"
        case .apiError:
            "There was an issue fetching data. Please try again later"
        case .noFavourites:
            "You don't have any favourites!"
        }
    }
    
    var sfIconName: String {
        switch self {
        case .noData:
            "circle.slash"
        case .apiError:
            "exclamationmark.triangle.fill"
        case .noFavourites:
            "heart.slash.fill"
        }
    }
}
