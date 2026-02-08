//
//  HeadlinesViewModelTests.swift
//  NewsReaderTests
//
//  Created by Sudheshna on 9/2/2026.
//

import XCTest
@testable import NewsReader

@MainActor
final class HeadlinesViewModelTests: XCTestCase {

    func testToggleSavedArticle() async {
        let api = MockNewsAPIClient()
        let articleRepo = MockArticleRepository()
        let sourceRepo = MockSourceSelectionRepository()
        sourceRepo.ids = ["abc-news"]

        let article = Article(
            source: ArticleSourceRef(id: "abc-news", name: "ABC News"),
            author: nil,
            title: "Title",
            description: nil,
            url: "https://example.com",
            urlToImage: nil,
            publishedAt: nil,
            content: nil
        )

        let vm = HeadlinesViewModel(api: api, articleRepo: articleRepo, sourceRepo: sourceRepo)

        XCTAssertFalse(vm.isSaved(article))
        vm.toggleSaved(article)
        XCTAssertTrue(vm.isSaved(article))
        vm.toggleSaved(article)
        XCTAssertFalse(vm.isSaved(article))
    }
}
