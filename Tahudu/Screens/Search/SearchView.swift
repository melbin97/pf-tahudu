//
//  SearchView.swift
//  Tahudu
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel = .init()
    
    var body: some View {
        VStack {
            toolBar
            ClearableTextField(label: "City, area or building", symbol: "magnifyingglass", text: $viewModel.searchText) { _ in
                //do something
            }
            ScrollView {
                // listing card
                LazyVStack {
                    ListingCardView(listingInfo: Listing.mockList()[0])
                }
            }
        }
        .padding(12)
    }
}

extension SearchView {
    
    private var toolBar: some View {
        HStack(spacing: 20) {
            Group {
                Button {
                    //do some filter
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                Button {
                    // do sorting
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                Spacer()
                Button {
                    // star the property
                } label: {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
