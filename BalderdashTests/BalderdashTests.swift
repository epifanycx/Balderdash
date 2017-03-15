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
    var gibberishController = BalderdashController()

    override func setUp() {
        super.setUp()

        gibberishController = BalderdashController()
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "trained_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        gibberishController.loadFile(url: url)
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
        let result = gibberishController.isGiberrish(string: "adfjas;dkj;")
        XCTAssertTrue(result)
    }

    func testHasMinimumUniqueCharacterCount() {
        gibberishController.minimumUniqueCharacters = 4

        let result = gibberishController.isGiberrish(string: "This is valid")
        XCTAssertFalse(result)
    }

    func testDoesNotHaveMinimumUniqueCharacterCount() {
        gibberishController.minimumUniqueCharacters = 4

        let result = gibberishController.isGiberrish(string: "ffffff")
        XCTAssertTrue(result)
    }

    func testIsNotGibberish() {
        let result = gibberishController.isGiberrish(string: "This is not gibberish")
        XCTAssertFalse(result)
    }

}
