//
//  SearchHistoryTableViewCell.swift
//  MyITunes
//
//  Created by 하연주 on 8/12/24.
//

import UIKit
import SnapKit

final class SearchHistoryTableViewCell : UITableViewCell {
    // MARK: - UI
    private let iconImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "clock")
        return iv
    }()
    
    private let keywordLabel = {
        let label = UILabel()
        label.text = "-"
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
    func confiureData(keyword : String) {
        keywordLabel.text = keyword
    }
    
    
    // MARK: - ConfigureUI
    
    private func configureSubView() {
        [iconImageView, keywordLabel]
            .forEach{
                contentView.addSubview($0)
            }
    }
    
    private func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.leading.centerY.equalTo(contentView)
            make.size.equalTo(16)
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(4)
            make.centerY.trailing.equalTo(contentView)
        }
    }

}
