//
//  SavedView.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI
import SwiftData

struct SavedView: View {
    @Query(sort: \SavedArticleEntity.savedAt, order: .reverse)
    private var savedArticles: [SavedArticleEntity]

    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            Group {
                if savedArticles.isEmpty {
                    VStack(spacing: 12) {
                        Text("No saved articles yet")
                            .font(.headline)
                        Text("Tap the bookmark icon in Headlines to save articles for later.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(savedArticles) { entity in
                            let article = entity.toArticle()

                            NavigationLink {
                                // Use the same detail view as Headlines
                                ArticleDetailView(
                                    article: article,
                                    isInitiallySaved: true,
                                    onToggleSaved: { _ in
                                        // Unsave from detail → delete from SwiftData
                                        delete(entity)
                                    }
                                )
                            } label: {
                                ArticleRowView(article: article)
                            }
                        }
                        .onDelete(perform: delete(at:))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved")
        }
    }

    private func delete(_ entity: SavedArticleEntity) {
        context.delete(entity)
        try? context.save()
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(savedArticles[index])
        }
        try? context.save()
    }
}

#Preview {
    SavedView()
}
