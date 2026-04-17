//
//  MockStorageService.swift
//  Tahudu
//
//  Created by Melbin Mathew on 17/04/26.
//

@testable import Tahudu

class MockStorageService: StorageService {
    var isNotFound = false
    var mockData: Any?
    
    var didCallSave = false
    var lastSavedKey: Tahudu.StorageKeys?
    
    func save<T>(value: T, key: Tahudu.StorageKeys) where T : Encodable {
        mockData = value
        didCallSave = true
        lastSavedKey = key
    }
    
    func get<T>(key: Tahudu.StorageKeys) -> T? where T : Decodable {
        guard !isNotFound else { return nil }
        if let data = mockData {
            print("DEBUG: Mock has \(type(of: data)), but Code wants \(T.self)")
        }
        return mockData as? T
    }
    
    func clearStore() {
        isNotFound = false
        mockData = nil
        didCallSave = false
        lastSavedKey = nil
    }
}
