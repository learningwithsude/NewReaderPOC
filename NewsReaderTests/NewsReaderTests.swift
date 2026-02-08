//
//  NewsReaderTests.swift
//  NewsReaderTests
//
//  Created by Sudheshna on 8/2/2026.
//

import XCTest
@testable import NewsReader

final class NewsAPIServiceTests: XCTestCase {
    private var session: URLSession!
    private var service: NewsAPIService!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        service = NewsAPIService(apiKey: "TEST_KEY", session: session)
    }

    func testFetchSourcesDecodes() async throws {
        let json = """
        {
          "status": "ok",
          "sources": [
            {
              "id": "abc-news",
              "name": "ABC News",
              "description": "Test",
              "url": "https://abcnews.go.com",
              "category": "general",
              "language": "en",
              "country": "us"
            }
          ]
        }
        """
        MockURLProtocol.responseData = json.data(using: .utf8)
        MockURLProtocol.statusCode = 200

        let sources = try await service.fetchSources()
        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(sources.first?.id, "abc-news")
    }

    func testFetchHeadlinesHandlesError() async {
        MockURLProtocol.statusCode = 401
        MockURLProtocol.responseData = """
        { "status": "error", "message": "Invalid key" }
        """.data(using: .utf8)

        do {
            _ = try await service.fetchHeadlines(forSources: ["abc-news"])
            XCTFail("Expected error")
        } catch {
            guard case let NewsAPIError.apiError(message) = error else {
                XCTFail("Wrong error")
                return
            }
            XCTAssertTrue(message.contains("Invalid"))
        }
    }
}
