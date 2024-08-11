//
//  SearchResultTableViewCell.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchResultTableViewCell : UITableViewCell {
    // MARK: - UI
    let mainImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        return iv
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.text = "----"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubView()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureData
    func confiureData(data : ItunesSearchResult) {
        let url = URL(string: data.artworkUrl60)
        mainImageView.kf.setImage(with: url)
        
        titleLabel.text = data.trackName
        
    }
    
    // MARK: - ConfigureUI
    
    private func configureSubView() {
        [mainImageView, titleLabel]
            .forEach{
                contentView.addSubview($0)
            }
    }
    
    private func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView).offset(4)
            make.size.equalTo(50)
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(4)
            make.trailing.equalTo(contentView)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }

}
