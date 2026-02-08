//
//  SourceViewModelTests.swift
//  NewsReaderTests
//
//  Created by Sudheshna on 9/2/2026.
//

import XCTest
@testable import NewsReader

@MainActor
final class SourcesViewModelTests: XCTestCase {
    func testLoadSourcesAndToggle() async {
        let api = MockNewsAPIClient()
        let sourceRepo = MockSourceSelectionRepository()

        api.sourcesToReturn = [
            Source(id: "abc-news", name: "ABC News", description: nil,
                   url: nil, category: nil, language: "en", country: "us")
        ]

        let vm = SourcesViewModel(api: api, sourceRepo: sourceRepo)

        await vm.loadSources()
        XCTAssertEqual(vm.sources.count, 1)

        let src = vm.sources[0]
        XCTAssertFalse(vm.isSelected(src))

        vm.toggleSelection(for: src)
        XCTAssertTrue(vm.isSelected(src))

        vm.toggleSelection(for: src)
        XCTAssertFalse(vm.isSelected(src))
    }
}
