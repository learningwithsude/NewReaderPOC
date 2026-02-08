//
//  Mocks.swift
//  NewsReaderTests
//
//  Created by Sudheshna on 9/2/2026.
//

import Foundation
@testable import NewsReader

final class MockNewsAPIClient: NewsAPIClient {
    var articlesToReturn: [Article] = []
    var sourcesToReturn: [Source] = []
    var shouldThrow = false

    func fetchSources() async throws -> [Source] {
        if shouldThrow { throw NewsAPIError.apiError("Test error") }
        return sourcesToReturn
    }

    func fetchHeadlines(forSources sourceIDs: [String]) async throws -> [Article] {
        if shouldThrow { throw NewsAPIError.apiError("Test error") }
        return articlesToReturn
    }
}

final class MockArticleRepository: ArticleRepository {
    var storage: [String: Article] = [:]

    func fetchSavedArticles() throws -> [SavedArticleEntity] { [] }

    func isSaved(url: String) throws -> Bool {
        storage[url] != nil
    }

    func save(article: Article) throws {
        storage[article.url] = article
    }

    func delete(url: String) throws {
        storage[url] = nil
    }
}

final class MockSourceSelectionRepository: SourceSelectionRepository {
    var ids: [String] = []

    func selectedSourceIDs() throws -> [String] {
        ids
    }

    func toggle(source: Source) throws {
        if let idx = ids.firstIndex(of: source.id) {
            ids.remove(at: idx)
        } else {
            ids.append(source.id)
        }
    }
}
