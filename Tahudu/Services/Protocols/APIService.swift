//
//  APIClient.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

protocol APIService {
    func fetch<T: Decodable>(url: String) async throws -> T
}
