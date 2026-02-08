//
//  ArticleDetailView.swift
//  NewsReader
//
//  Created by Sudheshna on 9/2/2026.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    // Initial saved state comes from the ViewModel
    @State private var isSaved: Bool
    
    // ViewModel logic is injected as a closure – keeps MVVM separation
    let onToggleSaved: (Article) -> Void
    
    init(
        article: Article,
        isInitiallySaved: Bool,
        onToggleSaved: @escaping (Article) -> Void
    ) {
        self.article = article
        self._isSaved = State(initialValue: isInitiallySaved)
        self.onToggleSaved = onToggleSaved
    }
    
    var body: some View {
        Group {
            if let url = URL(string: article.url) {
                ArticleWebView(url: url)
            } else {
                Text("Invalid article URL")
            }
        }
        .navigationTitle(article.source.name ?? "Article")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                onToggleSaved(article)  // delegate to VM
                isSaved.toggle()        // update local UI state
            }) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
            }
        }
    }
}

#if DEBUG
struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = Article(
            source: ArticleSourceRef(id: "abc-news", name: "ABC News"),
            author: "Preview Author",
            title: "Tesla hits new record",
            description: "Preview description for the detail view.",
            url: "https://example.com/preview",
            urlToImage: nil,
            publishedAt: nil,
            content: nil
        )
        
        NavigationStack {
            ArticleDetailView(
                article: sample,
                isInitiallySaved: false,
                onToggleSaved: { _ in }
            )
        }
    }
}
#endif
