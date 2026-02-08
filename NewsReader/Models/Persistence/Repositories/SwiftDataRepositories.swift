//
//  SwiftDataRepositories.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation
import SwiftData

final class SwiftDataArticleRepository: ArticleRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchSavedArticles() throws -> [SavedArticleEntity] {
        let descriptor = FetchDescriptor<SavedArticleEntity>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func isSaved(url: String) throws -> Bool {
        let descriptor = FetchDescriptor<SavedArticleEntity>(
            predicate: #Predicate { $0.url == url }
        )
        return try !context.fetch(descriptor).isEmpty
    }

    func save(article: Article) throws {
        guard try !isSaved(url: article.url) else { return }
        let entity = SavedArticleEntity(from: article)
        context.insert(entity)
        try context.save()
    }

    func delete(url: String) throws {
        let descriptor = FetchDescriptor<SavedArticleEntity>(
            predicate: #Predicate { $0.url == url }
        )
        let results = try context.fetch(descriptor)
        results.forEach(context.delete)
        try context.save()
    }
}

final class SwiftDataSourceSelectionRepository: SourceSelectionRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func selectedSourceIDs() throws -> [String] {
        let descriptor = FetchDescriptor<SelectedSourceEntity>()
        return try context.fetch(descriptor).map { $0.id }
    }

    func toggle(source: Source) throws {
        let descriptor = FetchDescriptor<SelectedSourceEntity>(
            predicate: #Predicate { $0.id == source.id }
        )
        let existing = try context.fetch(descriptor)
        if let first = existing.first {
            context.delete(first)
        } else {
            context.insert(SelectedSourceEntity(id: source.id, name: source.name))
        }
        try context.save()
    }
}
