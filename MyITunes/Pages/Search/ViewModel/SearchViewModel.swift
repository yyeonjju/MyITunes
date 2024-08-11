//
//  SearchViewModel.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import Foundation
import RxSwift

final class SearchViewModel {
    let searchResult = [
            ItunesSearchResult(artistName: "1", trackName: "1--", artworkUrl60: ""),
            ItunesSearchResult(artistName: "2", trackName: "2--", artworkUrl60: ""),
            ItunesSearchResult(artistName: "3", trackName: "3å--", artworkUrl60: ""),
    ]
    
    lazy var outputSearchResultSubject = BehaviorSubject(value: searchResult)
    
    
    
    struct Input {
        
    }
    
    struct Output {
        let serchResult : BehaviorSubject<[ItunesSearchResult]>
    }
    
    func transform(input : Input) -> Output {
        
        
        return Output(serchResult: outputSearchResultSubject)
    }
    
    
    
}
