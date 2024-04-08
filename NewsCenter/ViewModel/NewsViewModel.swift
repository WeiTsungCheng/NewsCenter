//
//  NewsViewModel.swift
//  NewsCenter
//
//  Created by WEI-TSUNG CHENG on 2024/3/11.
//

import Foundation
import Combine

final class NewsViewModel {
    
    enum Input {
        case viewDidLoad
        case searchBar(text: String)
        case countrySelect(country: NewsAPI.Country)
    }
    
    enum Output {
        case setArticles(articles: [Article])
        case setSearchBar
        case spinner(state: Bool)
        case updateView
    }
    
    private let output = PassthroughSubject<NewsViewModel.Output, Never>()
    var cancellable = Set<AnyCancellable>()
    
    @Published var articles: [Article] = []
    @Published var searchText: String = ""
    var selectCountry: NewsAPI.Country = .JP
    
    let service: NewsAPI
    init(service: NewsAPI) {
        self.service = service
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [unowned self] event in
                switch event {
                case .viewDidLoad:
                    output.send(.spinner(state: true))
                    getNews(country: selectCountry)
                    
                case .searchBar(text: let searchText):
                    self.searchText = searchText
                
                case .countrySelect(country: let country):
                    self.selectCountry = country
                    getNews(country: country)
                }
            }
            .store(in: &cancellable)
        
        Publishers.CombineLatest($articles, $searchText)
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] (articles, text) in
                
                if !text.isEmpty {
                    let filtered = articles.filter { $0.title.lowercased().contains(text.lowercased())
                    }
                    self.output.send(.setArticles(articles: filtered))
                } else {
                    self.output.send(.setArticles(articles: articles))
                }
                
                self.output.send(.spinner(state: false))
                self.output.send(.updateView)
                
            }.store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
    
    
    private func getNews(country: NewsAPI.Country) {
        
        service.fetchNews(country: country)
            .sink { completion in
                print(completion)
                
            } receiveValue: { [unowned self] news in
                self.articles = news.articles
                
            }
            .store(in: &cancellable)
    }
    
}
