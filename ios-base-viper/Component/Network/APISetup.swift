//
//  APISetup.swift
//  ios-base-viper
//
//  Created by Isaac on 11/3/22.
//

import Foundation

public enum HttpMethod: String {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH
}

public protocol APISetup {
    var method: HttpMethod {get}
    var path: String {get}
    var parameters: [String:Any] {get}
}

extension APISetup {
    func setupRequest(environment: APIEnvironment) -> URLRequest {
        let url = "\(environment.setupUrl().absoluteString)\(path)"
        let finalUrl = URL(string: url)!
        
        var request = finalUrl.setParameter(parameters: parameters, method: method)
        
        request.setHeader()
        request.httpMethod = method.rawValue
        if environment.isDebug { logRequest(withRequest: request) }
        
        return request
    }
    
    func logRequest(withRequest request: URLRequest) {
        print("HEADER = \(String(describing: request.allHTTPHeaderFields))")
        print("BODY = \(String(describing: request.httpBody))")
        print("URL = \(String(describing: request.url?.absoluteString))")
        print("METHOD = \(request.httpMethod ?? "NONE")")
    }
}
