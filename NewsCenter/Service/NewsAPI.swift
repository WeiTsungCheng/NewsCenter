//
//  WebServiceManager+News.swift
//  NewsCenter
//
//  Created by WEI-TSUNG CHENG on 2024/4/7.
//

import UIKit
import Combine

class NewsAPI {
    
    let service: WebServiceManager = WebServiceManager.shared
    
    let key: String
    let urlString: String
    
    init(key: String, urlString: String) {
        self.key = key
        self.urlString = urlString
    }
    
    enum Country: String, CaseIterable {
        case TW = "tw"
        case US = "us"
        case EN = "gb"
        case JP = "jp"
    }
    
    func fetchNews(country: Country) -> AnyPublisher<News, Error> {
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "country", value: country.rawValue),
            URLQueryItem(name: "apiKey", value: key)
        ]

        let endPoint = urlComponents.url
        
        return service.fetch(endpoint: endPoint!.absoluteString, type: News.self).eraseToAnyPublisher()
    }
}
