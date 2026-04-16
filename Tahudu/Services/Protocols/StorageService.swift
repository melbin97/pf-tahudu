//
//  StorageService.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//

protocol StorageService {
    func save<T: Encodable>(value: T, key: StorageKeys)
    func get<T: Decodable>(key: StorageKeys) -> T?
}


enum StorageKeys: String {
    case favourites = "user_favourites_ids"
}
