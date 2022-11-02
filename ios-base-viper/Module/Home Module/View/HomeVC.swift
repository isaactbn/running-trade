//
//  HomeVC.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import UIKit

protocol HomeView: BaseView {
    var presenter: HomePresenter? { get set }
    
    func update(with data: [HomeBodyFullResponse])
    func update(with error: String)
}

class HomeVC: BaseVC, HomeView {
    var presenter: HomePresenter?
    
    func update(with data: [HomeBodyFullResponse]) {
        
    }
    
    func update(with error: String) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
