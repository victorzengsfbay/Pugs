//
//  PugCell.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//  Copyright © 2019 Victor Zeng. All rights reserved.
//

import UIKit

class PugCell: UICollectionViewCell {
    static let reuseIdentifier: String = "PugCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var totalLikes: UILabel!
    
    func configureCell(with pug: Pug, for indexPath: IndexPath) {
        self.likeButton.indexPath = indexPath
        self.tag = indexPath.row
        
        let request = URLRequest(url: pug.imageUrl, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 20.0)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            [weak self, id = indexPath.row] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if self?.tag == id {
                        self?.imageView.image = image
                    }
                }
                return
            }
        }
        task.resume()
        
        self.configureLikeInfo(with: pug)
    }
    
    func configureLikeInfo(with pug: Pug) {
        self.likeButton.showLikedByMe(pug.likedByMe)
        self.totalLikes.text = "\(pug.likes) likes"
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
