//
//  UserTest.swift
//  MeetMeAppTests
//
//  Created by Bogdan Nikolaev on 26.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import XCTest
@testable import MeetMeApp

class UserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserInit() {
        let user = User(username: "q", password: "q")
        XCTAssertNotNil(user)
        XCTAssertFalse(user.isNil())
    }
    
}
