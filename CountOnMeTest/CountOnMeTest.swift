//
//  CountOnMeTest.swift
//  CountOnMeTest
//
//  Created by Birkyboy on 25/04/2021.
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

    func testGivenString_WhenAddingNumber_thenCalculate() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: .add)
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 + 2 = 4.0")
    }

    func testGivenString_WhenSubstractingNumber_thenCalculate() {
        calculator.addNumber(with: "3")
        calculator.addOperand(with: .substract)
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3 - 2 = 1.0")
    }

    func testGivenString_WhenMultiplyNumber_thenCalculate() {
        calculator.addNumber(with: "3")
        calculator.addOperand(with: .multiply)
        calculator.addNumber(with: "3")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3 x 3 = 9.0")
    }

    func testGivenString_WhenDividingNumber_thenCalculate() {
        calculator.addNumber(with: "4")
        calculator.addOperand(with: .divide)
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "4 / 2 = 2.0")
    }
    
    func testGivenString_WhenAddingDecimalPoint_thenDisplayDecimalNumber() {
        calculator.addNumber(with: "2")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "2")
        XCTAssertEqual(calculator.stringToCalculate, "2.2")
    }

    func testGivenClearButton_WhenClearButtonPressed_thenStringIsEmpty() {
        calculator.resetCalculation()
        XCTAssertEqual(calculator.stringToCalculate, "")
    }
}

