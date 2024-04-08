//
//  ViewController.swift
//  NewsCenter
//
//  Created by WEI-TSUNG CHENG on 2024/3/11.
//

import UIKit
import Combine
import SnapKit

final class NewsViewController: UIViewController {
    
    var cancellable = Set<AnyCancellable>()
    
    var viewModel: NewsViewModel?
    
    var cellViewModels: [ArticleCellViewModel] = []
    
    private lazy var searchController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
       
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "搜尋...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).title = "取消"
    
        return controller
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var scrollView: UIScrollView = {
        let srv = UIScrollView()
        srv.showsVerticalScrollIndicator = false
        srv.showsHorizontalScrollIndicator = false
        return srv
    }()
    
    lazy var stackView: UIStackView = {
        let stv = UIStackView()
        stv.alignment = .center
        stv.distribution = .fill
        stv.axis = .horizontal
        stv.spacing = 10
        return stv
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = .white
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.showsHorizontalScrollIndicator = false
        tbv.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.cellIdentifier())
        return tbv
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let sp = UIActivityIndicatorView(style: .medium)
        sp.color = .brown
        return sp
    }()
    
    private let output = PassthroughSubject<NewsViewModel.Input, Never>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        output.send(.viewDidLoad)
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .white
        self.navigationItem.searchController = searchController
        self.tableView.backgroundView = spinner
        
        view.addSubview(containerView)
        view.addSubview(tableView)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        containerView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        for country in NewsAPI.Country.allCases {
            let btn = CountryButton(country: country)
            btn.snp.makeConstraints { make in
                make.width.equalTo(120)
            }
            btn.addTarget(self, action: #selector(getNews), for: .touchUpInside)
            stackView.addArrangedSubview(btn)
        }

    }
    
    @objc func getNews(_ sender: CountryButton) {
        output.send(.countrySelect(country: sender.country))
    }
    
    private func bind() {
        viewModel?.transform(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                case .spinner(state: let bool):
                    if bool {
                        spinner.startAnimating()
                    } else {
                        spinner.stopAnimating()
                    }
                    
                case .setArticles(articles: let articles):
                    self.cellViewModels = articles.map { article in
                        return ArticleCellViewModel(model: article)
                    }
                    
                case .updateView:
                    self.tableView.reloadData()
                    
                case .setSearchBar:
                    break
                }
                
            }
            .store(in: &cancellable)
    }
    
}

extension NewsViewController: UITableViewDelegate { }

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ArticleTableViewCell = tableView.dequeueReusableCell()
        
        cell.setup(viewModel: cellViewModels[indexPath.row])
        return cell
    }
    
}

extension NewsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            output.send(.searchBar(text: searchText))
        }
    }
}



class CountryButton: UIButton {
    
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
