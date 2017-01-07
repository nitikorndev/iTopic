//
//  LoginViewModelTests.swift
//  iTopic
//
//  Created by Nitikorn Ruengmontre on 1/7/17.
//  Copyright © 2017 Nitikorn Ruengmontre. All rights reserved.
//

import XCTest
import FirebaseAuth
@testable import iTopic

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testLoginFacebook() {
//        let result: Future<FIRUser,NSError> = viewModel.loginFacebook()
//        result.
    }
    
}
