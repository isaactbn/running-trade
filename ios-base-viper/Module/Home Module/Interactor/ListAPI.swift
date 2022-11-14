//
//  ListAPI.swift
//  ios-base-viper
//
//  Created by Isaac on 11/3/22.
//

import Foundation

class GetListAPI: APISetup {
    var method: HttpMethod = .GET
    
    var path: String = "/finance/chart"
    
    var parameters: [String : Any]
    
    init(parameters: [String:Any]) {
        self.parameters = parameters
    }
}
