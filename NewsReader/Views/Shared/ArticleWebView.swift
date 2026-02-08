//
//  ArticleWebView.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI
import WebKit

struct ArticleWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

#Preview {
    ArticleWebView(url: URL(string: "https://newsapi.org/")!)
}
