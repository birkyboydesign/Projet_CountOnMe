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

    func testGivenEmptyString_WhenAddingNumber_ThenDisplayString() {
        calculator.addNumber(with: "2")
        XCTAssertEqual(calculator.stringToCalculate, "2")
    }

    func testGivenString_WhenAddingOperand_ThenDisplayString() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        XCTAssertEqual(calculator.stringToCalculate, "2 + ")
    }

    func testGivenString_WhenAddingNumber_thenCalculate() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 + 2 = 4")
    }

    func testGivenString_WhenSubstractingNumber_ThenCalculate() {
        calculator.addNumber(with: "3")
        calculator.addOperand(with: " - ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3 - 2 = 1")
    }

    func testGivenString_WhenMultiplyNumber_ThenCalculate() {
        calculator.addNumber(with: "3")
        calculator.addOperand(with: " x ")
        calculator.addNumber(with: "3")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3 x 3 = 9")
    }

    func testGivenString_WhenDividingNumber_ThenCalculate() {
        calculator.addNumber(with: "4")
        calculator.addOperand(with: " / ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "4 / 2 = 2")
    }
    
    func testGivenString_WhenAddingDecimalPoint_ThenDisplayDecimalNumber() {
        calculator.addNumber(with: "2")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "2")
        XCTAssertEqual(calculator.stringToCalculate, "2.2")
    }

    func testGivenClearButton_WhenClearButtonPressed_ThenStringIsZero() {
        calculator.resetCalculation()
        XCTAssertEqual(calculator.stringToCalculate, "0")
    }

    func testGivenAStringWithANumber_WhenNothingToAddTo_ThenNoResultWithEqualSign() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 + ")
    }

    func testGivenAStringWithANumber_WhenNothingToSubstractWith_ThenNoResultWithEqualSign() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " - ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 - ")
    }

    func testGivenAStringWithANumber_WhenNothingToMultiplyBy_ThenNoResultWithEqualSign() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " x ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 x ")
    }

    func testGivenAStringWithANumber_WhenNothingToDivideBy_ThenNoResultWithEqualSign() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " / ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 / ")
    }

    func testGivenStringHasResult_WhenAddingNumber_ThenShouldClear() {
        calculator.stringToCalculate = "2 + 2 = 4"
        calculator.addNumber(with: "2")
        XCTAssertEqual(calculator.stringToCalculate, "2")
    }

    func testGivenStringHasNumber_WhenDivindingBy0_ThenShouldDisplayErrorAndResultEqual0() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " / ")
        calculator.addNumber(with: "0")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "0")
        XCTAssertEqual(calculator.error, CountError.zeroDivision)
    }

    func testGivenStringHasNumber_WhenNoOperand_ThenDisplayError() {
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.error, CountError.incorrectExpression)
    }

    func testGivenStringHasOperand_WhenAddingOperand_ThenDisplayError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addOperand(with: " + ")
        calculator.calculate()
        XCTAssertEqual(calculator.error, CountError.operandAlreadySet)
    }

    func testGivenResultGiven_WhenTappingResultButton_ThenShowError() {
        calculator.stringToCalculate = "2 + 2 = 4"
        calculator.calculate()
        XCTAssertEqual(calculator.error, CountError.resultAlreadyShowing)
    }

    func testGivenAnError_WhenErrorFailed_ThenStop() {
        calculator.error = nil
        XCTAssertNil(calculator.error)
    }

    func testGivenResultShowing_WhenAddingDecimalPoint_ThenResetCalculation() {
        calculator.stringToCalculate = "2 + 2 = 4"
        calculator.addDecimalPoint()
        XCTAssertEqual(calculator.stringToCalculate, "0.")
    }

}


