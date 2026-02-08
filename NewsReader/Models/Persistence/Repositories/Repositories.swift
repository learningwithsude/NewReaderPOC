//
//  Repositories.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation
import SwiftData

// MARK: - Repository
protocol ArticleRepository {
    func fetchSavedArticles() throws -> [SavedArticleEntity]
    func isSaved(url: String) throws -> Bool
    func save(article: Article) throws
    func delete(url: String) throws
}

protocol SourceSelectionRepository {
    func selectedSourceIDs() throws -> [String]
    func toggle(source: Source) throws
}
