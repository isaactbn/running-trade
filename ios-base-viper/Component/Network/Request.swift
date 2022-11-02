//
//  Request.swift
//  ios-base-viper
//
//  Created by Isaac on 11/2/22.
//

import Foundation

enum fetchError: Error {
    case failed
}

public typealias OnSuccess<T> = ((T)->Void)?
public typealias OnFailure = ((Error)->Void)?

/// An object that responsible for requesting remote data
/// - Parameters:
///   - T: response object and should extends Codable
open class CARequestService<T: Codable> {
    
    let baseURL = "https://api.themoviedb.org/3"
    let apiKey = "f6098121525c0986c904e574ae7a5eb7"
    let language = "en-US"
    
    /// Request remote data
    /// - Parameters:
    ///   - environment: determine the environment for base URL
    ///   - config: request blueprint for API setup
    ///   - onSuccess: retrieve model from response
    ///   - onFailure: retrieve error from response
    public func request(api: String, path: String, onSuccess: OnSuccess<T>, onFailure: OnFailure) {
        
        let setURL = "\(baseURL)\(api)?api_key=\(apiKey)&language=\(language)\(path)"
        guard let url = URL(string: setURL) else { return }
        print("finalURL", url)
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
//                onFailure?(error!)
                return
            }
            
            do {
                let entities = try JSONDecoder().decode(T.self, from: data)
                onSuccess?(entities)
            } catch {
                onFailure?(error)
            }
        }
        
        task.resume()
    }
}
