//
//  HomeRouter.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import Foundation
import UIKit

typealias EntryPoint = HomeView & BaseVC

protocol HomeRouter {
    var entry: EntryPoint? { get }
    
    static func start() -> HomeRouter
}

class HomeRouters: HomeRouter {
    var entry: EntryPoint?
    
    static func start() -> HomeRouter {
        let router = HomeRouters()
        
        // Assign VIP
        var view: HomeView = HomeVC()
        var presenter: HomePresenter = HomePresentation()
        var interactor: HomeInteractor = HomeInteractors()
        
        view.onLoading()
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
}
