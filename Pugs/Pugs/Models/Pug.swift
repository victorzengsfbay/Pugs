//
//  CellModel.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//Copyright © 2019 Victor Zeng. All rights reserved.
//

import Foundation

struct Pug {
    let imageUrl: URL
    let likesByOthers: Int
    var likedByMe: Bool
    var likes: Int {
        get {
            return self.likesByOthers + (self.likedByMe ? 1 : 0)
        }
    }
}
