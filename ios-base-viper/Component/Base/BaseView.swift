//
//  BaseView.swift
//  ios-base-viper
//
//  Created by Isaac on 11/2/22.
//

import Foundation

protocol BaseView {
    func showError(msg: String)
    func onLoading()
    func onFinishLoading()
}
