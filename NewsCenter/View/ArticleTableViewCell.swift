//
//  ArticleTableViewCell.swift
//  NewsCenter
//
//  Created by WEI-TSUNG CHENG on 2024/4/7.
//

import UIKit
import SnapKit
import SDWebImage

final class ArticleTableViewCell: UITableViewCell {

    lazy var newsImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(systemName: "photo")
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "title"
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var newsDescription: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 1
        lbl.text = """
        1. aaa
        2. bbb
        3. ccc
        """
        return lbl
    }()
    
    lazy var linkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "link"), for: .normal)
        btn.tintColor = .systemGreen
        return btn
    }()
    
    var viewModel: ArticleCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        setupUI()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.newsImageView.image = UIImage(systemName: "photo")
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newsDescription)
        contentView.addSubview(linkButton)
        
        newsImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.leading.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.equalTo(newsImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
        }
        
        newsDescription.snp.makeConstraints { make in
            make.leading.equalTo(newsImageView.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalTo(newsImageView.snp.bottom)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        linkButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.leading.equalTo(newsDescription.snp.trailing)
            make.bottom.equalTo(newsImageView.snp.bottom)
        }
        
    }
    
    func setAction() {
        linkButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc private func tapButton(_ sender: UIButton) {
        guard let url = viewModel?.model.url else { return }
        UIApplication.shared.open(url)
    }
    
    func setup(viewModel: ArticleCellViewModel) {
        self.viewModel = viewModel
        configure()
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.model.title
        newsDescription.text = viewModel.model.description
        if let urlString = viewModel.model.urlToImage {
            newsImageView.sd_setImage(with: URL(string: urlString))
        }
      
    }
}
