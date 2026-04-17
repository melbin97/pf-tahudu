//
//  MockAPIService.swift
//  Tahudu
//
//  Created by Melbin Mathew on 17/04/26.
//

@testable import Tahudu
import Foundation

final class MockAPIService: APIService {
    var mockData: Decodable?
    var shouldFail = false
    
    func fetch<T>(url: String) async throws -> T where T : Decodable {
        if shouldFail { throw NetworkError.noInternet }
        return mockData as! T
    }
}
