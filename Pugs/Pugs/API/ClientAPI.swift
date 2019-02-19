//
//  ClientAPI.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//Copyright © 2019 Victor Zeng. All rights reserved.
//

import Foundation

import UIKit

enum APIError: Error {
    case ServiceError(ServiceError)
    case serviceStatus
    case dataDecode
}

protocol ClientAPI  {
    func getPugs(_ pugsRequest: Requests, _ completion: @escaping (Result<PugsResults>) -> Void)
}

struct GetPugsRequest: Requests {
    let url: URL
    init?(count: Int) {
        let urlString = "https://pugme.herokuapp.com/bomb?count=\(count)"
        if let url = URL(string: urlString) {
            self.url = url
        }
        else {
            return nil
        }
    }
}

final class DefaultClientAPI: ClientAPI {
    let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    convenience init() {
        self.init(service: NetworkService())
    }
    
    func getPugs(_ pugsRequest: Requests, _ completion: @escaping (Result<PugsResults>) -> Void) {
        service.get(request: pugsRequest) { (r: Result<Data>) in
            switch r {
            case .error:
                completion(Result.error(ServiceError.connectionError))
            case .results(let data):
                do {
                    let decoder = JSONDecoder()
                    let pugsResults = try decoder.decode(PugsResults.self, from: data)
                    completion(Result.results(pugsResults))                    
                } catch {
                    completion(Result.error(APIError.dataDecode))
                    return
                }
            }
        }
    }
    
}
