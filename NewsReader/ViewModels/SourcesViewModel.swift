//
//  SourcesViewModel.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import Foundation
import Combine 

@MainActor
final class SourcesViewModel: ObservableObject {
    // All sources loaded from API
    @Published var sources: [Source] = []
    
    // Local selection state that drives the UI
    @Published private(set) var selectedSourceIDs: Set<String> = []
   
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: NewsAPIClient
    private let sourceRepo: SourceSelectionRepository

    init(api: NewsAPIClient, sourceRepo: SourceSelectionRepository) {
        self.api = api
        self.sourceRepo = sourceRepo
    }

    // Loading data from API
    func loadSources() async {
        isLoading = true
        errorMessage = nil

        do {
            // fetch sources from API
            let fetched = try await api.fetchSources()
            sources = fetched.sorted { $0.name < $1.name }
            
            // Sync initial selection from swiftData --> ViewModel
            let ids = try sourceRepo.selectedSourceIDs()
            self.selectedSourceIDs = Set(ids)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            sources = []
        }

        isLoading = false
    }
    // MARK: - Selection
    
    func isSelected(_ source: Source) -> Bool {
        selectedSourceIDs.contains(source.id)
    }

    func toggleSelection(for source: Source) {
        do {
            // 1. Update persistence
            try sourceRepo.toggle(source: source)
            
            // 2. Update local @Published state → triggers UI update
            if selectedSourceIDs.contains(source.id) {
                selectedSourceIDs.remove(source.id)
            } else {
                selectedSourceIDs.insert(source.id)
            }
        } catch {
            print("Selection persistence error: \(error)")
        }
    }
}
