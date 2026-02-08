//
//  ArticleRowView.swift
//  NewsReader
//
//  Created by Sudheshna on 8/2/2026.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
  //  let isSaved: Bool
  //  let onToggleSaved: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnail

            VStack(alignment: .leading, spacing: 6) {
                Text(article.title ?? "Untitled")
                    .font(.headline)
                    .lineLimit(2)

                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                Text(article.author ?? article.source.name ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let urlString = article.urlToImage,
           let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 80, height: 80)
            .clipped()
            .cornerRadius(8)
        } else {
            Color.gray.opacity(0.1)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
        }
    }
}

#if DEBUG
struct ArticleRowView_Previews: PreviewProvider {

    static var sampleArticleWithImage: Article {
        Article(
            source: ArticleSourceRef(id: "abc-news", name: "ABC News"),
            author: "Elon Musk",
            title: "Tesla hits record high production",
            description: "Tesla's latest quarterly report shows a significant increase in production...",
            url: "https://example.com/tesla",
            urlToImage: "https://via.placeholder.com/300x200",
            publishedAt: nil,
            content: nil
        )
    }

    static var sampleArticleNoImage: Article {
        Article(
            source: ArticleSourceRef(id: "bbc-news", name: "BBC News"),
            author: "Reporter",
            title: "Tesla unveils new model",
            description: "The company has announced a brand new model with extended range...",
            url: "https://example.com/model",
            urlToImage: nil,
            publishedAt: nil,
            content: nil
        )
    }

    static var previews: some View {
        Group {

            // With image
            ArticleRowView(article: sampleArticleWithImage)
                .previewDisplayName("Row with image")
                .padding()
                .previewLayout(.sizeThatFits)

            // Without image
            ArticleRowView(article: sampleArticleNoImage)
                .previewDisplayName("Row without image")
                .padding()
                .previewLayout(.sizeThatFits)

            // Dark mode
            ArticleRowView(article: sampleArticleWithImage)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif

