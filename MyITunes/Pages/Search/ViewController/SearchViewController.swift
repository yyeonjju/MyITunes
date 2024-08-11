//
//  SearchViewController.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import UIKit
import RxSwift
import RxCocoa

struct ItunesSearchModel : Decodable {
    let resultCount : Int
    let results : [ItunesSearchResult]
}

struct ItunesSearchResult : Decodable {
    let artistName : String
    let trackName : String
    let artworkUrl60 : String
}

final class SearchViewController : UIViewController {
    // MARK: - UI
    private let searchBar = UISearchBar()
    private let viewManager = SearchView()
    
    // MARK: - Properties
    private let vm = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle
    override func loadView() {
        view = viewManager
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        setupBind()
    }
    
    // MARK: - Bind
    private func setupBind() {
        
        let input = SearchViewModel.Input()
        let output = vm.transform(input: input)
        
        viewManager.tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.description())
        
        output.serchResult
            .bind(to: viewManager.tableView.rx.items(cellIdentifier: SearchResultTableViewCell.description(), cellType: SearchResultTableViewCell.self)) { (row, element, cell : SearchResultTableViewCell) in
                
                cell.confiureData(data: element)
                
            }
            .disposed(by: disposeBag)
        
        
        
    }

}
