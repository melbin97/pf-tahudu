//
//  SearchView.swift
//  Tahudu
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel = .init()
    @State var isFocused = false
    
    var body: some View {
        VStack {
            toolBar
            ClearableTextField(label: "City, area or buidling", symbol: "magnifyingglass", text: $viewModel.searchText) { _ in
                //do something
            }
            ScrollView {
                // listing card
                LazyVStack {
                    card
                    card
                    card
                }
            }
        }
        .padding(12)
    }
}

extension SearchView {
    
    var toolBar: some View {
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

extension SearchView {
    var card: some View {
        ZStack(alignment: .top) {
            VStack {
                //carousal
                TabView {
                    Image("FirstImage")
                        .resizable()
                    Image("SecondImage")
                        .resizable()
                }
                .cornerRadius(8)
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                // apartment details
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Apartment")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text("Delivery: 2022")
                                .font(.caption2)
                                .padding(4)
                                .foregroundColor(.blue)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.blue.opacity(0.2))
                                )
                        }
                        Text("2,575,000 AED")
                            .bold()
                            .font(.headline)
                        HStack {
                            Image(systemName: "house.lodge")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.8))
                            Text("Studio")
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
                    Text("Published 3 days ago")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    HStack(spacing: 12) {
                        ContactButton(.phone) {
                            //do somethin
                        }
                        ContactButton(.email) {
                            //do somethin
                        }
                        ContactButton(.whatsApp) {
                            //do somethin
                        }
                    }

                }
                .padding()
                // last contact section
                HStack {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                    Text("Last contacted: 28 Jul 2021")
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
            HStack {
                badge
                Spacer()
                Image(systemName: "heart")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray)
        )
    }
    
    var badge: some View {
        Text("VERIFIED")
            .bold()
            .font(.caption2)
            .padding(4)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.green)
            )
    }
    
    func contactButton(imageName: String, color: UIColor, onClick: @escaping () -> ()) -> some View {
        Button {
            onClick()
        } label: {
            Image(systemName: imageName)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(uiColor: color))
                )
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
