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
        navigationItem.titleView = viewManager.searchBar
        viewManager.tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.description())
        viewManager.searchHistoryTableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: SearchHistoryTableViewCell.description())
        
        setupBind()
    }
    
    // MARK: - Bind
    private func setupBind() {
        let searchButtonTap = PublishSubject<Void>()
        let inputText = PublishSubject<String>()
        viewManager.searchBar.rx.searchButtonClicked
            .bind(to: searchButtonTap)
            .disposed(by: disposeBag)
        viewManager.searchBar.rx.text.orEmpty
            .bind(to: inputText)
            .disposed(by: disposeBag)
        
        
        
        let input = SearchViewModel.Input(
            searchButtonTap: searchButtonTap,
            inputText: inputText
        )
        let output = vm.transform(input: input)
        
        
        
        //검색결과
        output.serchResult
            .bind(to: viewManager.tableView.rx.items(cellIdentifier: SearchResultTableViewCell.description(), cellType: SearchResultTableViewCell.self)) { (row, element, cell : SearchResultTableViewCell) in
                
                cell.confiureData(data: element)
                
            }
            .disposed(by: disposeBag)
        
        
        viewManager.tableView.rx.modelSelected(ItunesSearchResult.self)
            .bind(with:self) {owner, selectedModel in
                let vc = DetailInformationViewController()
                vc.detailData = selectedModel
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
        //검색 키워드 히스토리
        output.keywordHistory
            .bind(to: viewManager.searchHistoryTableView.rx.items(cellIdentifier: SearchHistoryTableViewCell.description(), cellType: SearchHistoryTableViewCell.self)) { (row, element, cell : SearchHistoryTableViewCell) in
                
                cell.confiureData(keyword: element)
                
            }
            .disposed(by: disposeBag)
        
        output.showkeywordHistory
            .map{!$0}
            .bind(to: viewManager.searchHistoryTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        //검색 키워드 히스토리의 셀을 클릭했을 때
        viewManager.searchHistoryTableView.rx.modelSelected(String.self)
            .bind(with:self) {owner, keyword in
                inputText.onNext(keyword)
                searchButtonTap.onNext(())
            }
            .disposed(by: disposeBag)
    }

}
