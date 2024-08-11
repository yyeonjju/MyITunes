//
//  SearchView.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import UIKit
import SnapKit

final class SearchView : UIView{
    // MARK: - UI

    let searchBar = UISearchBar()
    let tableView = {
        let tv = UITableView()
        tv.rowHeight = 70
        return tv
    }()

    // MARK: - Initializer
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ConfigureUI
    private func configureSubView() {
        [tableView]
            .forEach{
                addSubview($0)
            }
    }
    
    private func configureLayout() {

        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    
}
