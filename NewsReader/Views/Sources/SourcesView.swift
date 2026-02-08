//
//  SourcesView.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI

struct SourcesView: View {
    @StateObject var viewModel: SourcesViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Sources")
                .task { await viewModel.loadSources() }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading…")
        } else if let error = viewModel.errorMessage {
            VStack {
                Text("Error").font(.headline)
                Text(error)
                Button("Retry") { Task { await viewModel.loadSources() } }
            }.padding()
        } else {
            List {
                ForEach(viewModel.sources) { source in
                    Button {
                        viewModel.toggleSelection(for: source)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(source.name)
                                    .font(.headline)
                                if let desc = source.description {
                                    Text(desc)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            Spacer()
                            Image(systemName: viewModel.isSelected(source) ? "checkmark.circle.fill" : "circle")
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}


#if DEBUG
// MARK: - SourcesView Preview helpers

private final class PreviewSourceRepoForSourcesView: SourceSelectionRepository {
    private var ids: [String] = ["abc-news"]

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

private final class PreviewSourcesAPIClient: NewsAPIClient {
    func fetchSources() async throws -> [Source] {
        [
            Source(
                id: "abc-news",
                name: "ABC News",
                description: "US-based news channel",
                url: "https://abcnews.go.com",
                category: "general",
                language: "en",
                country: "us"
            ),
            Source(
                id: "bbc-news",
                name: "BBC News",
                description: "UK-based news organisation",
                url: "https://bbc.co.uk",
                category: "general",
                language: "en",
                country: "gb"
            )
        ]
    }

    func fetchHeadlines(forSources sourceIDs: [String]) async throws -> [Article] {
        []
    }
}

struct SourcesView_Previews: PreviewProvider {
    @MainActor
    static var previews: some View {
        let api = PreviewSourcesAPIClient()
        let sourceRepo = PreviewSourceRepoForSourcesView()
        let vm = SourcesViewModel(api: api, sourceRepo: sourceRepo)

        return SourcesView(viewModel: vm)
            .task {
                await vm.loadSources()
            }
    }
}
#endif
