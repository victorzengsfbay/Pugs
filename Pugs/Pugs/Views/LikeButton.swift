//
//  LikeButton.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//  Copyright © 2019 Victor Zeng. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showLikedByMe(_ liked: Bool) {
        if liked {
            self.setAttributedTitle(NSAttributedString(string: "💖",
                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.red]), for: UIControl.State.normal)
        }
        else {
            self.setAttributedTitle(NSAttributedString(string: "♡",
                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]), for: UIControl.State.normal)
        }
    }   
}
