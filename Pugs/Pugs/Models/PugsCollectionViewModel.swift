//
//  PugsCollectionViewModel.swift
//  Pugs
//
//  Created by Victor Zeng on 2/16/19.
//Copyright © 2019 Victor Zeng. All rights reserved.
//

import Foundation

protocol DataSourceObserver: AnyObject {
    func onPugsAdded(at indexes: [IndexPath])
    //func onPugsRemoved(at indexes: [IndexPath])
}

protocol DataSourceServer {
    func addDataSourceObserver(_ observer: DataSourceObserver)
    func removeDataSourceObserver(_ observer: AnyObject)
}

final class PugsCollectionViewModel: NSObject, DataSourceServer {
    
    private let lock: NSLock = NSLock()
    private var observerList: [DataSourceObserver] = []
    private var pugs: [Pug] = []
    private let apiClient: ClientAPI
    
    init(apiClient: ClientAPI = DefaultClientAPI()) {
        self.apiClient = apiClient
    }
    
    func numberOfPugs() -> Int {
        return self.pugs.count
    }
    
    func pug(at index: Int) -> Pug {
        return pugs[index]
    }
    
    func toggleLike(at index: Int) {
        self.pugs[index].likedByMe = !self.pugs[index].likedByMe
    }
    
    //return true if loading started, otherwise false
    func loadPugs(request: Requests? = nil) -> Bool {
        if self.lock.try() {
            let defaultGetCount = 50
            let loadRequest = request ?? GetPugsRequest(count: defaultGetCount)
            guard let pugsRequest = loadRequest else { self.lock.unlock(); return false }
            
            self.apiClient.getPugs(pugsRequest) {  [weak self] (r: Result<PugsResults>) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    var indexes = [IndexPath]()
                    switch r {
                    case .error(let error):
                        print(error.localizedDescription)
                        
                    case .results(let result):
                        var index = strongSelf.pugs.count
                        for p in result.pugs {
                            if let url = URL(string: p.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
                                let likes = LikesUtil.likesByOthers(for: url.absoluteString)
                                let pug = Pug(imageUrl: url,
                                              likesByOthers: likes,
                                              likedByMe: false)
                                strongSelf.pugs.append(pug)
                                indexes.append(IndexPath(row: index,
                                                         section: 0))
                                index += 1
                            }
                        }
                    }
                    strongSelf.notify(newIndexs: indexes)
                    strongSelf.lock.unlock()
                }
            }
            return true
        }
        else {
            return false
        }
    }

    private func notify(newIndexs: [IndexPath]) {
        for  observer in self.observerList {
            observer.onPugsAdded(at: newIndexs)
        }
    }

    func addDataSourceObserver(_ observer: DataSourceObserver) {
        DispatchQueue.main.async {
            self.observerList.append(observer)
        }
    }
    
    func removeDataSourceObserver(_ observer: AnyObject) {
        DispatchQueue.main.async {
            for i in 0 ..< self.observerList.count {
                if self.observerList[i] === observer {
                    self.observerList.remove(at: i)
                    break
                }
            }
        }
    }

}

fileprivate struct  LikesUtil {
    static var likesInfoDict: [String : Int] = [:]
    
    //helper function to give likes
    static func likesByOthers(for urlString: String) -> Int {
        if let likes = LikesUtil.likesInfoDict[urlString]  {
            return likes
        }
        else {
            let randomLikes = Int.random(in: 10 ... 1000)
            LikesUtil.likesInfoDict[urlString] = randomLikes
            return randomLikes
        }
    }
    
}


