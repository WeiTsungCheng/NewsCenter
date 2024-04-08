//
//  CountryButton.swift
//  NewsCenter
//
//  Created by WEI-TSUNG CHENG on 2024/4/9.
//

import Foundation
import UIKit

final class CountryButton: UIButton {
    
    var country: NewsAPI.Country
    
    required init(country: NewsAPI.Country) {
        self.country = country
        super.init(frame: CGRect.zero)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGreen
        setTitle(country.rawValue, for: .normal)
        setTitleColor(.white, for: .normal)
    }
    
}
