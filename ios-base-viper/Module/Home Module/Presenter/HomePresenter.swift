//
//  HomePresenter.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import Foundation

protocol HomePresenter {
    var router: HomeRouter? { get set }
    var interactor: HomeInteractor? { get set }
    var view: HomeView? { get set }
    
    func onGetHomeList(with result: Result<HomeBodyResponse, Error>)
}

class HomePresentation: HomePresenter {
    var router: HomeRouter?
    
    var interactor: HomeInteractor? {
        didSet {
            interactor?.getHomeList()
        }
    }
     
    var view: HomeView?
    
    func onGetHomeList(with result: Result<HomeBodyResponse, Error>) {
        switch result {
        case.success(let output):
            var model: [HomeBodyFullResponse] = []
            
            view?.onFinishLoading()
            view?.update(with: model)
        case .failure:
            view?.onFinishLoading()
            view?.update(with: "Something went wrong")
        }
    }
}
