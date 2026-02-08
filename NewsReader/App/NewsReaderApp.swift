//
//  NewsReaderApp.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI
import SwiftData

@main
struct NewsReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // SwiftData container for our models
        .modelContainer(for: [SavedArticleEntity.self, SelectedSourceEntity.self])

    }
}
