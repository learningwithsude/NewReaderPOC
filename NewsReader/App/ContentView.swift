//
//  ContentView.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String ?? ""

    
    // Shared networking service
    private var apiService: NewsAPIClient {
        NewsAPIService(apiKey: apiKey)
    }
    
    private var articleRepo: ArticleRepository {
        SwiftDataArticleRepository(context: modelContext)
    }

    private var sourceRepo: SourceSelectionRepository {
        SwiftDataSourceSelectionRepository(context: modelContext)
    }
    
    var body: some View {
        TabView {
            HeadlinesView(
                viewModel: HeadlinesViewModel(
                    api: apiService,
                    articleRepo: articleRepo,
                    sourceRepo: sourceRepo
                )
            )
            .tabItem { Label("Headlines", systemImage: "newspaper") }

            SourcesView(
                viewModel: SourcesViewModel(
                    api: apiService,
                    sourceRepo: sourceRepo
                )
            )
            .tabItem { Label("Sources", systemImage: "list.bullet") }

            SavedView()
                .tabItem { Label("Saved", systemImage: "bookmark") }
        }
    }
}

#Preview {
    ContentView()
}
