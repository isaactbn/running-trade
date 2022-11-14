//
//  HomeInteractor.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import Foundation

protocol HomeInteractor {
    var presenter: HomePresenter? { get set }
    
    func getHomeList(body: HomeBodyRequest, symbol: String)
}

class HomeInteractors: HomeInteractor {
    var presenter: HomePresenter?
    
    func getHomeList(body: HomeBodyRequest, symbol: String) {
        if let dict = body.dictionary{
            let repo = CARequestService<HomeBodyResponse>()
            let apiConfig = GetListAPI(parameters: dict)
            apiConfig.path += "/\(symbol)"
            repo.request(environment: BaseEnvironment(), config: apiConfig, onSuccess: { (response) in
                self.presenter?.onGetHomeList(with: .success(response))
            }) { (error) in
                self.presenter?.onGetHomeList(with: .failure(error))
            }
        }
    }
}
