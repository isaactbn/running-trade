//
//  BaseVC.swift
//  ios-base-viper
//
//  Created by Isaac on 11/2/22.
//

import Foundation
import ProgressHUD

class BaseVC: UIViewController {
    private let loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension BaseVC: UIGestureRecognizerDelegate{
}

extension BaseVC: BaseView {
    func showError(msg: String) {
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
    }
    
    func onLoading() {
        showLoading()
    }
    
    private func showLoading() {
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorBackground = .clear
        ProgressHUD.show()
    }
    
    func onFinishLoading() {
        hideLoading()
    }
    
    private func hideLoading() {
        ProgressHUD.dismiss()
    }
}
