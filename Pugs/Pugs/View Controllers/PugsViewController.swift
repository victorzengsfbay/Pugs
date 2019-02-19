//
//  PugsViewController.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//  Copyright © 2019 Victor Zeng. All rights reserved.
//

import UIKit

class PugsViewController: UIViewController, UICollectionViewDelegate, DataSourceObserver {
    let spacing: CGFloat = 20.0
    let insets = UIEdgeInsets(top: 8, left: 2, bottom: 120, right: 2)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var dataSource: PugsCollectionViewModel = PugsCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource.addDataSourceObserver(self)
        _ = self.dataSource.loadPugs()
    }

    func showLoading(_ show: Bool) {
        switch show {
        case true:
            self.loadingIndicator.startAnimating()
        case false:
            self.loadingIndicator.stopAnimating()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.reloadData()
    }
    
    //
    // check if current content reach near bottom, and may trigger new content adding
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let leftContent = scrollView.contentSize.height - scrollView.contentOffset.y - self.collectionView.frame.height
        if leftContent < self.collectionView.frame.height/2.0  {
            DispatchQueue.main.async {
                if self.dataSource.loadPugs() {
                    self.showLoading(true)
                }
            }
        }
    }

    func onPugsAdded(at indexes: [IndexPath]) {
        self.collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: indexes)
        }, completion: nil)
        self.showLoading(false)
    }
}

extension PugsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,  numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfPugs()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PugCell.reuseIdentifier,
                                                      for: indexPath) as! PugCell
        let pug = dataSource.pug(at: indexPath.row)
        cell.configureCell(with: pug, for: indexPath)
        
        return cell
    }
    
    @IBAction func onLikeButtonTapped(_ sender: LikeButton) {
        guard let indexPath = sender.indexPath else { return }
        self.dataSource.toggleLike(at: indexPath.row)
        let pug = self.dataSource.pug(at: indexPath.row)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? PugCell {
            cell.configureLikeInfo(with: pug)
        }
    }
}

extension PugsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.frame.size.width > collectionView.frame.size.height {
            let extraSpacing = self.insets.left + self.insets.right + self.insets.top
            let w = (max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - 3 * extraSpacing - self.view.safeAreaInsets.right - self.view.safeAreaInsets.left)/2.0
            let h = w + 65
            return CGSize(width: w, height: h)
        }
        else {
            let extraSpacing = self.insets.left + self.insets.right
            let w = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) -  extraSpacing
            let h = w + 65
            return CGSize(width: w, height: h)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.insets.top
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacing
    }
    
}

