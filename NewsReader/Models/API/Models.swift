//
//  Models.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation

// MARK: - API Models
struct Source: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}

struct ArticleSourceRef: Codable, Hashable {
    let id: String?
    let name: String?
}

struct Article: Codable, Identifiable, Hashable {
    // Use URL as stable ID
    var id: String { url }

    let source: ArticleSourceRef
    let author: String?
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
}

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}


