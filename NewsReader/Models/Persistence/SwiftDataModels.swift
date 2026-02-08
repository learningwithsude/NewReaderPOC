//
//  SwiftDataModels.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation
import SwiftData

@Model
final class SavedArticleEntity {
    @Attribute(.unique) var url: String
    var title: String?
    var descriptionText: String?
    var author: String?
    var imageUrl: String?
    var sourceName: String?
    var savedAt: Date

    init(from article: Article) {
        self.url = article.url
        self.title = article.title
        self.descriptionText = article.description
        self.author = article.author
        self.imageUrl = article.urlToImage
        self.sourceName = article.source.name
        self.savedAt = Date()
    }

    func toArticle() -> Article {
        Article(
            source: ArticleSourceRef(id: nil, name: sourceName),
            author: author,
            title: title,
            description: descriptionText,
            url: url,
            urlToImage: imageUrl,
            publishedAt: nil,
            content: nil
        )
    }
}

@Model
final class SelectedSourceEntity {
    @Attribute(.unique) var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
