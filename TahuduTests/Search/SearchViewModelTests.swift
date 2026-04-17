//
//  SearchViewModelTests.swift
//  Tahudu
//
//  Created by Melbin Mathew on 17/04/26.
//

import XCTest
@testable import Tahudu

@MainActor
final class SearchViewModelTests: XCTestCase {
    var mockStorage: MockStorageService!
    var mockAPI: MockAPIService!
    
    override func setUpWithError() throws {
        mockStorage = MockStorageService()
        mockAPI = MockAPIService()
    }
    
    override func tearDownWithError() throws {
        mockStorage.clearStore()
    }
    
    func testGetListingsSuccess() async {
        // setup mockdata
        let mockData = Listing.mockList()
        mockAPI.mockData = ListingResponse(listings: mockData)
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        await vm.getListings()
        
        XCTAssertEqual(vm.listings, mockData)
        XCTAssertEqual(vm.listViewState, SearchViewModel.ListViewState.loaded)
    }
    
    func testGetListingsFailure() async {
        // setup mockdata
        mockAPI.shouldFail = true
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        await vm.getListings()
        
        XCTAssertEqual(vm.listViewState, SearchViewModel.ListViewState.error)
    }
    
    func testLoadFavourites() async {
        let mockData = Listing.mockList()
        mockAPI.mockData = ListingResponse(listings: mockData)
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        
        vm.toggleFavourites(id: "prop_005")
        vm.loadFavourites()
        XCTAssertEqual(vm.favoriteIds, ["prop_005"])
    }
    
    func testLoadFavouritesFromExistingStorage() {
        mockStorage.save(value: Set(["prop_005", "prop_001"]), key: .favourites)
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        // loadFavourites called in init
        XCTAssertEqual(vm.favoriteIds, ["prop_005", "prop_001"])
    }
    
    func testToggleFavourites() async {
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        
        vm.toggleFavourites(id: "prop_005")
        XCTAssertEqual(vm.favoriteIds, ["prop_005"])
        
        vm.toggleFavourites(id: "prop_005")
        XCTAssertEqual(vm.favoriteIds, [])
    }
    
    func testFavouritesPersistence() async {
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        
        vm.toggleFavourites(id: "prop_005")
        
        let persistedData: Set<String>? = mockStorage.get(key: .favourites)
        XCTAssertEqual(vm.favoriteIds, persistedData)
    }
    
    func testShowFavouritesOnly() async {
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        let mockData = Listing.mockList()
        let favouritesOnlyMock = mockData.filter({ $0.id == "prop_005"})
        mockAPI.mockData = ListingResponse(listings: mockData)
        
        await vm.getListings()
        vm.toggleFavourites(id: "prop_005")
        
        XCTAssertFalse(vm.listingFilter.showFavouritesOnly)
        XCTAssertEqual(vm.displayListings, mockData)
        
        vm.listingFilter.showFavouritesOnly.toggle()
        XCTAssertEqual(vm.displayListings, favouritesOnlyMock)
    }
    
    func testEmptyStateWhenNoListings() async {
        mockAPI.mockData = ListingResponse(listings: [])
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        
        await vm.getListings()
        
        XCTAssertEqual(vm.listViewState, .emptyState(.noData))
    }

    func testEmptyStateWhenNoFavourites() async {
        let mockData = Listing.mockList()
        mockAPI.mockData = ListingResponse(listings: mockData)
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        
        await vm.getListings()
        vm.listingFilter.showFavouritesOnly = true
        
        XCTAssertEqual(vm.listViewState, .emptyState(.noFavourites))
    }
}
