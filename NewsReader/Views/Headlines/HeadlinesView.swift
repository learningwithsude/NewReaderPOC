//
//  HeadlinesView.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI

struct HeadlinesView: View {
    @StateObject var viewModel: HeadlinesViewModel
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Headlines")
                .task {
                    if viewModel.articles.isEmpty && !viewModel.isLoading {
                        await viewModel.loadHeadlines()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading headlines…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let message = viewModel.errorMessage {
            VStack(spacing: 12) {
                Text("Something went wrong")
                    .font(.headline)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Button("Retry") {
                    Task { await viewModel.loadHeadlines() }
                }
            }
            .padding()
        } else if !viewModel.hasSelectedSources {
            // No sources selected show explicit empty state
            VStack(spacing: 12) {
                Text("No sources selected")
                    .font(.headline)
                Text("Go to the Sources tab and pick a few news sources to see headlines here.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        } else if viewModel.articles.isEmpty {
            // Sources selected but no results
            VStack(spacing: 12) {
                Text("No articles found")
                    .font(.headline)
                Text("Try refreshing or selecting different sources.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Button("Refresh") {
                    Task { await viewModel.loadHeadlines() }
                }
            }
            .padding()
        } else {
            // Main list all articles
            List(viewModel.articles) { article in
                NavigationLink {
                    ArticleDetailView(
                        article: article,
                        isInitiallySaved: viewModel.isSaved(article),
                        onToggleSaved: { viewModel.toggleSaved($0) } 
                    )
                } label: {
                    ArticleRowView(article: article)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.loadHeadlines()
            }
        }
    }
}

#if DEBUG
// MARK: - Preview mocks

/// Mock API client used only for previews
final class PreviewNewsAPIClient: NewsAPIClient {
    func fetchSources() async throws -> [Source] {
        return []
    }
    
    func fetchHeadlines(forSources sourceIDs: [String]) async throws -> [Article] {
        return [
            Article(
                source: ArticleSourceRef(id: "abc-news", name: "ABC News"),
                author: "Jane Doe",
                title: "Tesla hits new production record",
                description: "Tesla has announced a record-breaking production number for the quarter.",
                url: "https://example.com/tesla-record",
                urlToImage: "https://via.placeholder.com/300x200",
                publishedAt: nil,
                content: nil
            ),
            Article(
                source: ArticleSourceRef(id: "bbc-news", name: "BBC News"),
                author: "John Smith",
                title: "New Tesla model revealed",
                description: "The latest Tesla model features a longer range and improved safety.",
                url: "https://example.com/tesla-model",
                urlToImage: nil,
                publishedAt: nil,
                content: nil
            )
        ]
    }
}

/// Mock article repository used only for previews (no real persistence)
final class PreviewArticleRepository: ArticleRepository {
    private var saved: Set<String> = []
    
    func fetchSavedArticles() throws -> [SavedArticleEntity] { [] }
    
    func isSaved(url: String) throws -> Bool {
        saved.contains(url)
    }
    
    func save(article: Article) throws {
        saved.insert(article.url)
    }
    
    func delete(url: String) throws {
        saved.remove(url)
    }
}

/// Mock source selection repository used only for previews
final class PreviewSourceSelectionRepository: SourceSelectionRepository {
    private var ids: [String] = ["abc-news", "bbc-news"]
    
    func selectedSourceIDs() throws -> [String] {
        ids
    }
    
    func toggle(source: Source) throws {
        if let index = ids.firstIndex(of: source.id) {
            ids.remove(at: index)
        } else {
            ids.append(source.id)
        }
    }
}

// MARK: - HeadlinesView Preview

struct HeadlinesView_Previews: PreviewProvider {
    @MainActor
    static var previews: some View {
        let api = PreviewNewsAPIClient()
        let articleRepo = PreviewArticleRepository()
        let sourceRepo = PreviewSourceSelectionRepository()
        
        let vm = HeadlinesViewModel(
            api: api,
            articleRepo: articleRepo,
            sourceRepo: sourceRepo
        )
        
        return HeadlinesView(viewModel: vm)
            .task {
                await vm.loadHeadlines()
            }
    }
}
#endif
