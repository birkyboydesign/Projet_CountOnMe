//
//  CalculatorTests.swift
//  CountOnMeTests
//
//  Created by Birkyboy on 24/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTests: XCTestCase {

    var calculator: Calculator!

    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }

    func testGivenInstanceOfCalculator_WhenAccessingIt_thenItExist() {
        let calculator = Calculator()
        XCTAssertNotNil(calculator)
    }
}
