//
//  SearchViewModel.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import Foundation
import RxSwift
//import RxCocoa

final class SearchViewModel {
    private let disposeBag = DisposeBag()

    
    struct Input {
        let searchButtonTap : PublishSubject<Void>
        let inputText : PublishSubject<String>
    }
    
    struct Output {
        let serchResult : PublishSubject<[ItunesSearchResult]>
    }
    
    func transform(input : Input) -> Output {
        let outputSearchResultSubject = PublishSubject<[ItunesSearchResult]>()
        
        
        let resultData = input.searchButtonTap
            .withLatestFrom(input.inputText)
            .flatMap { inputText in NetworkManager.shared.getItunesData(query: inputText)
            }
        
        resultData
            .subscribe { searchData in
                outputSearchResultSubject.onNext(searchData.results)
            } onError: { error in
                print("onError", error)
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        return Output(serchResult: outputSearchResultSubject)
    }
    
    
    
}
