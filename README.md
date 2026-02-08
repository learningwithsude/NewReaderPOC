# NewReaderPOC
NewsReader is a three-tab iOS application built with SwiftUI, MVVM architecture, SwiftData persistence, NSURLSession networking.
The app fetches trending Tesla-related news articles using NewsAPI, allows users to select preferred sources, read articles in-app using WebView, and save favorites for later.

This project demonstrates scalable SwiftUI patterns, clean data flow, and strong architectural boundaries suitable for real-world apps or portfolio presentation.

Features:
- Headlines: fetch, display, filter, open in WebView, save.
- Sources: fetch English sources, multi-select, persist.
- Saved: view saved articles using SwiftData, delete items.

Architecture:
- MVVM pattern.
- Networking: NewsAPIService using async/await.
- Persistence: SwiftData models (SavedArticleEntity, SelectedSourceEntity).
- Repositories abstract persistence from ViewModels.
- SwiftUI Views structurally separated per feature.

API Usage

Headlines are fetched from:
https://newsapi.org/v2/everything?q=tesla&from=2026-01-08&sortBy=publishedAt&apiKey=YOUR_KEY

Sources list is fetched from:
https://newsapi.org/v2/top-headlines/sources?language=en&apiKey=YOUR_KEY

Replace YOUR_KEY with your API key from https://newsapi.org/
<img width="1290" height="2796" alt="Headlines" src="https://github.com/user-attachments/assets/e5bc2aad-71f9-4037-b831-dd1f1e9bdc36" />
<img width="1290" height="2796" alt="Webview" src="https://github.com/user-attachments/assets/bd642e3f-8e10-49ef-adce-849061496a5d" />

<img width="1290" height="2796" alt="Sources" src="https://github.com/user-attachments/assets/7ce4a28c-f55e-45eb-9444-6a5c2864eb3d" />

<img width="1290" height="2796" alt="Save" src="https://github.com/user-attachments/assets/495d9869-3ea0-40b3-8243-35fea6b18da0" />

