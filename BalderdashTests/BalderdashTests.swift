//
//  BalderdashTests.swift
//  BalderdashTests
//
//  Created by Dirk Smith on 2/20/17.
//  Copyright © 2017 Dirk. All rights reserved.
//

import XCTest
@testable import Balderdash

class BalderdashTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDoubleNgram() {
        let string = "asd😀f"
        let acceptArray = [["a", "s"], ["s", "d"], ["d", "😀"], ["😀", "f"]]
        let ngrams = string.ngrams(2)

        XCTAssert(ngrams.first! == acceptArray.first!)
    }

    func testTripleNgram() {
        let string = "asd😀f"
        let acceptArray = [["a", "s", "d"], ["s", "d", "😀"], ["d", "😀", "f"]]
        let ngrams = string.ngrams(3)

        XCTAssert(ngrams.first! == acceptArray.first!)
    }

    func testIsGibberish() {
        let gibberishController = BalderdashController()
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "trained_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        gibberishController.loadFile(url: url)

        let result = gibberishController.isGiberrish(string: "adfjas;dkj;")
        XCTAssertTrue(result)
    }

    func testIsNotGibberish() {
        let gibberishController = BalderdashController()
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "trained_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        gibberishController.loadFile(url: url)

        let result = gibberishController.isGiberrish(string: "This is not gibberish")
        XCTAssertFalse(result)
    }

    func testRepetitionFalse() {
        let gibberishController = BalderdashController()
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "trained_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        gibberishController.loadFile(url: url)

        let result = gibberishController.hasRepetition(string: "this has no repetition ..")
        XCTAssertFalse(result)
    }

    func testRepetitionTrue() {
        let gibberishController = BalderdashController()
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "trained_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        gibberishController.loadFile(url: url)

        let result = gibberishController.hasRepetition(string: "this has repetition aaa")
        XCTAssertTrue(result)
    }
}
