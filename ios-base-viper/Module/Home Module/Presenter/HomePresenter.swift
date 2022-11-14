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
    var interval: String { get set }
    var range: String { get set }
    
    func onGetHomeList(with result: Result<HomeBodyResponse, Error>)
}

class HomePresentation: HomePresenter {
    var router: HomeRouter?
    
    var symbol: String = "GOOG"
    var interval: String = "1m"
    var range: String = "1d"
    
    var interactor: HomeInteractor? {
        didSet {
            let bodyReq = HomeBodyRequest(interval: interval, range: range)
            interactor?.getHomeList(body: bodyReq, symbol: symbol)
        }
    }
     
    var view: HomeView?
    
    func onGetHomeList(with result: Result<HomeBodyResponse, Error>) {
        switch result {
        case.success(let output):
            var model: [ResultModel] = []
            output.chart?.result?.forEach{ (data) in
                var timeStampModel: [Int64] = []
                var count = 0
                data.timestamp?.forEach{ (x) in
                    if count <= 100 {
                        timeStampModel.append(x)
                    }
                    count += 1
                }
                
                let newResult = ResultModel(meta: data.meta, timestamp: timeStampModel, indicators: data.indicators)
                model.append(newResult)
            }
            
            view?.onFinishLoading()
            view?.update(with: model)
        case .failure:
            view?.onFinishLoading()
            view?.update(with: "Something went wrong")
        }
    }
}
