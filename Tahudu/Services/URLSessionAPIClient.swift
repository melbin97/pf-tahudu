//
//  URLSessionAPIClient.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError(String)
    case noInternet
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .serverError(let statusCode):
            return "The server responded with an error (Status: \(statusCode))."
        case .decodingError(let message):
            return message
        case .noInternet:
            return "No internet connection. Please check your settings and try again."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

final class URLSessionAPIClient: APIService {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T>(url: String) async throws -> T where T : Decodable {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(statusCode: -999)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError {
            print("DEBUG: Decoding failed: \(decodingError)")
            throw NetworkError.decodingError("There is an issue reading data. Please try again later.")
        }
    }
}
