//
//  NewsAPIService.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation

protocol NewsAPIClient {
    func fetchSources() async throws -> [Source]
    func fetchHeadlines(forSources sourceIDs: [String]) async throws -> [Article]
}

enum NewsAPIError: Error, LocalizedError {
    case invalidURL
    case apiError(String)
    case noSourcesSelected

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .apiError(let message):
            return "API error: \(message)"
        case .noSourcesSelected:
            return "No sources selected."
        }
    }
}

final class NewsAPIService: NewsAPIClient {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchSources() async throws -> [Source] {
        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines/sources")
        components?.queryItems = [URLQueryItem(name: "language", value: "en")]

        guard let url = components?.url else { throw NewsAPIError.invalidURL }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)

        let decoded = try JSONDecoder().decode(SourcesResponse.self, from: data)
        return decoded.sources
    }

    func fetchHeadlines(forSources sourceIDs: [String]) async throws -> [Article] {
        guard !sourceIDs.isEmpty else { throw NewsAPIError.noSourcesSelected }

        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")
        components?.queryItems = [
            URLQueryItem(name: "sources", value: sourceIDs.joined(separator: ",")),
            URLQueryItem(name: "pageSize", value: "50")
        ]

        guard let url = components?.url else { throw NewsAPIError.invalidURL }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decoded = try decoder.decode(ArticlesResponse.self, from: data)
        return decoded.articles
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200..<300).contains(http.statusCode) else {
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String {
                throw NewsAPIError.apiError(message)
            }
            throw NewsAPIError.apiError("HTTP \(http.statusCode)")
        }
    }
}
