//
//  NetworkiManager.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import Foundation
import RxSwift

enum APIError : Error{
    case error
    case invalidUrl
    case unknownResponse
    case satusCode
}


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    

    func getItunesData(query : String) -> Single<ItunesSearchModel> {
        
        let url = "https://itunes.apple.com/search?term=\(query)&limit=5"
        
        let boxofficeResult = Single<ItunesSearchModel>.create { single in
            guard let url = URL(string: url) else {
                single(.failure(APIError.invalidUrl))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error {
                    single(.failure(APIError.error))
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    single(.failure(APIError.unknownResponse))
                    return
                }
                
                if let data = data, let decodeddata = try? JSONDecoder().decode(ItunesSearchModel.self, from: data) {
                    single(.success(decodeddata))
                }
            }
            .resume()
            
            return Disposables.create()
        }
//            .debug("💜boxofficeResult💜")
        
        
        return boxofficeResult
    }
    
    
}
