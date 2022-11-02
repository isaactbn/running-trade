//
//  HomeInteractor.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import Foundation

protocol HomeInteractor {
    var presenter: HomePresenter? { get set }
    
    func getHomeList()
}

class HomeInteractors: HomeInteractor {
    var presenter: HomePresenter?
    
    func getHomeList() {
        let repo = CARequestService<HomeBodyResponse>()
        
        repo.request(api: "/genre/movie/list", path: "", onSuccess: { (response) in
            self.presenter?.onGetHomeList(with: .success(response))
        }) { (error) in
            self.presenter?.onGetHomeList(with: .failure(error))
        }
    }
}
