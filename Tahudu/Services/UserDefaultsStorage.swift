//
//  UserDefaultsStorage.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

final class UserDefaultsStorage: StorageService {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Encodable>(value: T, key: StorageKeys) {
        if let encoded = try? JSONEncoder().encode(value) {
            userDefaults.set(encoded, forKey: key.rawValue)
        }
    }
    
    func get<T: Decodable>(key: StorageKeys) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
