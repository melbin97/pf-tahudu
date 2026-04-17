//
//  URLSessionAPIClient.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(Int)
    case decodingError
}

class URLSessionAPIClient: APIService {
    func fetch<T>(url: String) async throws -> T where T : Decodable {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(0)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        return decoded
    }
}
