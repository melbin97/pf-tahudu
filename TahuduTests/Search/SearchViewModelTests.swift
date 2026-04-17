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
        vm.isLoading = true
        await vm.getListings()
        
        XCTAssertEqual(vm.listings, mockData)
        XCTAssertFalse(vm.isLoading, "At the end loading will be set to false")
        XCTAssertNil(vm.errorMessage)
    }
    
    func testGetListingsFailure() async {
        // setup mockdata
        mockAPI.shouldFail = true
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        await vm.getListings()
        
        XCTAssertNotNil(vm.errorMessage)
    }
    
    func testLoadFavourites() async {
        let mockData = Listing.mockList()
        mockAPI.mockData = ListingResponse(listings: mockData)
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        
        vm.toggleFavourites(id: "prop_005")
        vm.loadFavourites()
        XCTAssertEqual(vm.favoriteIds, ["prop_005"])
    }
    
    func testLoadFavouritesEmpty() async {
        let mockData = Listing.mockList()
        mockAPI.mockData = ListingResponse(listings: mockData)
        
        let vm = SearchViewModel(listingsFetching: ListingManager(apiClient: mockAPI), keyValueStore: mockStorage)
        vm.loadFavourites()
        XCTAssertEqual(vm.favoriteIds, [])
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
        let favouritesOnlyMock = [mockData.first(where: {$0.id == "prop_005"})]
        mockAPI.mockData = ListingResponse(listings: mockData)
        
        await vm.getListings()
        vm.toggleFavourites(id: "prop_005")
        
        XCTAssertFalse(vm.showFavouritesOnly)
        XCTAssertEqual(vm.displayListings, mockData)
        
        vm.showFavouritesOnly.toggle()
        XCTAssertEqual(vm.displayListings, favouritesOnlyMock)
    }
}
