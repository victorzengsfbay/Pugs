//
//  Result.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//Copyright © 2019 Victor Zeng. All rights reserved.
//

import Foundation

// Generic Result
enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
