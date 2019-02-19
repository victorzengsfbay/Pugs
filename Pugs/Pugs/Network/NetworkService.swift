//
//  NetworkService.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//Copyright © 2019 Victor Zeng. All rights reserved.
//

//
// Network service
// Ideally to include Reachability, SSL pinning, credential validation, session token etc.
//

import Foundation

enum ServiceError: Error {
    case invalidData
    case unknownResponse
    case connectionError
}

protocol Requests {
    var url: URL { get }
}

protocol Service {
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void)
}

final class NetworkService: Service {
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.dataTask(with: request.url) { (data, response, error) in
            if let error = error {
                completion(Result.error(error))
                return
            }
            
            guard
                let _ = response as? HTTPURLResponse,
                let data = data
                else {
                    completion(Result.error(ServiceError.invalidData))
                    return
            }
            
            completion(.results(data))
            }.resume()
    }
}
