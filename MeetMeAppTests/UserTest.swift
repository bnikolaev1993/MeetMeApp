//
//  UserTest.swift
//  MeetMeAppTests
//
//  Created by Bogdan Nikolaev on 26.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import XCTest
import Sodium
@testable import MeetMeApp

class UserTest: XCTestCase {
    
    var userLog: User!
    var userReg: User!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        userLog = User(username: "q", password: "q")
        userReg = User(username: "q", password: "q", firstname: "Bogdan", familyname: "Nikolaev", gender: "m", dob: "20.01.1993")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserLoginInit() {
        XCTAssertNotNil(userLog)
        XCTAssertFalse(userLog.isNil())
    }
    
    func testUserRegisterInit() {
        XCTAssertNotNil(userReg)
        XCTAssertFalse(userReg.isNil())
    }
    
    func testUserHashPassword() {
        userLog.hashPassword()
        print(userLog.password)
        XCTAssertNotEqual(userLog.password, "q", "Password hasn't been hashed")
        let sodium = Sodium()
        let isHashed = sodium.pwHash.strVerify(hash: userLog.password, passwd: "q".bytes)
        XCTAssertTrue(isHashed, "Password has been hashed incorrectly")
    }
    
}
