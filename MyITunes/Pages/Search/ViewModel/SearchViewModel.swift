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
    @UserDefaultsWrapper(key : .searchKeywordHistory) var searchKeywordHistory : [String]?
    private let disposeBag = DisposeBag()

    
    struct Input {
        let searchButtonTap : PublishSubject<Void>
        let inputText : PublishSubject<String>
    }
    
    struct Output {
        let serchResult : PublishSubject<[ItunesSearchResult]>
        let showkeywordHistory : BehaviorSubject<Bool>
        let keywordHistory : BehaviorSubject<[String]>
    }
    
    func transform(input : Input) -> Output {
        let outputSearchResultSubject = PublishSubject<[ItunesSearchResult]>()
        let showkeywordHistorySubject = BehaviorSubject(value: false)
        let keywordHistorySubject : BehaviorSubject<[String]> = BehaviorSubject(value: searchKeywordHistory ?? [])
        
        
        
        let resultData = input.searchButtonTap
            .withLatestFrom(input.inputText)
            .flatMap { inputText in
                return NetworkManager.shared.getItunesData(query: inputText)
                    .catch({ error in
                        return Single<ItunesSearchModel>.never()
                    })
            }
            .asDriver(onErrorJustReturn: ItunesSearchModel(resultCount: 0, results: []))
        
        resultData
            .drive(onNext: { single in
                outputSearchResultSubject.onNext(single.results)
            })
            .disposed(by: disposeBag)
        
        
        //검색 시 키워드 저장
        input.searchButtonTap
            .withLatestFrom(input.inputText)
            .bind(with: self) { owner, searchKeyword in
                showkeywordHistorySubject.onNext(false)
                
                
                //아직 저장된 값이 없다면
                guard owner.searchKeywordHistory != nil else {
                    owner.searchKeywordHistory = [searchKeyword]
                    keywordHistorySubject.onNext(owner.searchKeywordHistory!)
                    return
                }
                
                // 똑같은 키워드가 있다면 지워주고
                if let index = owner.searchKeywordHistory!.firstIndex(where: {
                    $0 == searchKeyword
                }) {
                    owner.searchKeywordHistory!.remove(at: index)
                }
                
                // index 0 에 지금 검색한 키워드 insert
                owner.searchKeywordHistory!.insert(searchKeyword, at: 0)
                keywordHistorySubject.onNext(owner.searchKeywordHistory!)
            }
            .disposed(by: disposeBag)
        
        
        
        //한글자 이상 입력했을 때
        input.inputText
            .withUnretained(self)
            .map{ owner, text in
                return !text.isEmpty && owner.searchKeywordHistory != nil
            }
            .bind(with: self) { owner, bool in
                showkeywordHistorySubject.onNext(bool)
            }
            .disposed(by: disposeBag)
        

        
        
        return Output(
            serchResult: outputSearchResultSubject,
            showkeywordHistory: showkeywordHistorySubject,
            keywordHistory: keywordHistorySubject
        )
    }
    
    
    
}
