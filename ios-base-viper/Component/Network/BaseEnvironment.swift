//
//  BaseEnvironment.swift
//  ios-base-viper
//
//  Created by Isaac on 11/3/22.
//

import Foundation

class BaseEnvironment: APIEnvironment{
    
    var isConvertedFromSnakeCase: Bool = true
    
    var staging: String = "https://query1.finance.yahoo.com/v8"
    var production: String = "https://query1.finance.yahoo.com/v8"
    var isDebug: Bool = true
}
