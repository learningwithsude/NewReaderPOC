//
//  HeadlinesViewModel.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation
import Combine

@MainActor
final class HeadlinesViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasSelectedSources = false

    private let api: NewsAPIClient
    private let articleRepo: ArticleRepository
    private let sourceRepo: SourceSelectionRepository

    init(
        api: NewsAPIClient,
        articleRepo: ArticleRepository,
        sourceRepo: SourceSelectionRepository
    ) {
        self.api = api
        self.articleRepo = articleRepo
        self.sourceRepo = sourceRepo
    }

    func loadHeadlines() async {
        isLoading = true
        errorMessage = nil

        do {
            let ids = try sourceRepo.selectedSourceIDs()
            hasSelectedSources = !ids.isEmpty

            guard !ids.isEmpty else {
                articles = []
                isLoading = false
                return
            }

            let fetched = try await api.fetchHeadlines(forSources: ids)
            articles = fetched
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            articles = []
        }

        isLoading = false
    }

    // MARK: - Save / Unsave

    func isSaved(_ article: Article) -> Bool {
        (try? articleRepo.isSaved(url: article.url)) ?? false
    }

    func toggleSaved(_ article: Article) {
        do {
            if try articleRepo.isSaved(url: article.url) {
                try articleRepo.delete(url: article.url)
            } else {
                try articleRepo.save(article: article)
            }
        } catch {
            print("Persistence error: \(error)")
        }
    }
}
