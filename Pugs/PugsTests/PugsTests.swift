//
//  PugsTests.swift
//  PugsTests
//
//  Created by Victor Zeng on 2/16/19.
//  Copyright © 2019 Victor Zeng. All rights reserved.
//

import XCTest
@testable import Pugs

class PugsTests: XCTestCase {
    
    let loadPugs: XCTestExpectation = XCTestExpectation(description: "expection for load pugs")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPug() {
        let url = URL(string: "google.com")!
        var pug = Pug(imageUrl: url, likesByOthers: Int.random(in: 10...1000), likedByMe: true)
        XCTAssert(pug.likes == (pug.likesByOthers+1), "Like total error")
        pug.likedByMe = false
        XCTAssertFalse(pug.likes == (pug.likesByOthers+1))
    }

    func testRequestPerformance() {
        let api = DefaultClientAPI()
        self.measure {
            let defaultGetCount = 50
            if  let loadRequest = GetPugsRequest(count: defaultGetCount) {
                let expection = XCTestExpectation(description: "Test API request")
                api.getPugs(loadRequest) { (r: Result<PugsResults>) in
                    switch r {
                    case .error(let error):
                        XCTFail(error.localizedDescription)
                    case .results(let result):
                        XCTAssertTrue(result.pugs.count > 0, "Get no result from API call")
                    }
                    expection.fulfill()
                }
                self.wait(for: [expection], timeout: 10.0)
            } else {
                XCTFail("can not create request")
            }
        }
    }

    
}
