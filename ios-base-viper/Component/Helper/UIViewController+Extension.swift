//
//  UIViewController+Extension.swift
//  ios-base-viper
//
//  Created by Isaac on 11/3/22.
//

import UIKit

extension UIViewController {
    
    func hideNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func showNavigationBar() {
        navigationController?.extendedLayoutIncludesOpaqueBars = true
        navigationController?.isNavigationBarHidden = false
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = #colorLiteral(red: 0, green: 0.2014982402, blue: 0.3980255723, alpha: 1)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupNavBarSquareArrow(title: String = "", color: UIColor = .white){
        guard let nav = navigationController else {
            return
        }
        
        nav.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.2014982402, blue: 0.3980255723, alpha: 1)
        nav.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.2014982402, blue: 0.3980255723, alpha: 1)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        extendedLayoutIncludesOpaqueBars = true
        self.title = title
        tabBarController?.tabBar.barTintColor = UIColor.brown
        
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 18)]
    }
    
    func backToPreviousVC() {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count <= 2{
                NotificationCenter.default.post(name: Notification.Name("ShowTab"), object: nil)
            }
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
}

extension UIView {
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    @objc func tapGesture(action: (() -> Void)?) {
        isUserInteractionEnabled = true
        tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    func setupBorder(color: UIColor = .clear) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }
}
