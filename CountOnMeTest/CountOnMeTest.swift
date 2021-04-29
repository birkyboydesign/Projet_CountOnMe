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

    override func tearDown() {
        super.tearDown()
        calculator = nil
    }

    // MARK: - Test with operand

    func testGivenNumber_WhenAddingNumber_thenCalculate() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 + 2 = 4")
    }

    func testGivenNumber_WhenSubstractingNumber_ThenCalculate() {
        calculator.addNumber(with: "3")
        calculator.addOperand(with: " - ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3 - 2 = 1")
    }

    func testGivenNumber_WhenMultiplyNumber_ThenCalculate() {
        calculator.addNumber(with: "3")
        calculator.addOperand(with: " x ")
        calculator.addNumber(with: "3")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3 x 3 = 9")
    }

    func testGivenNumber_WhenDividingNumber_ThenCalculate() {
        calculator.addNumber(with: "4")
        calculator.addOperand(with: " / ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "4 / 2 = 2")
    }

    func testGivenNumber_WhenCalulatingWithSeveralNumbersAndOperands_ThenShowResult() {
        calculator.addNumber(with: "4")
        calculator.addOperand(with: " / ")
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " x ")
        calculator.addNumber(with: "3")
        calculator.addOperand(with: " - ")
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "4 / 2 x 3 - 2 + 2 = 6")
    }

    func testGivenStringHasDecimalNumber_WhenAddingNumber_ThenShowDecimalNumberResult() {
        calculator.addNumber(with: "3")
        calculator.addDecimalSeparator()
        calculator.addNumber(with: "5")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3.5 + 2 = 5.5")
    }

    func testGivenDecimalNumber_WhenAddingDecimalAndNumber_ThenShowDecimalNumberResult() {
        calculator.addNumber(with: "3")
        calculator.addDecimalSeparator()
        calculator.addNumber(with: "5")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.addDecimalSeparator()
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3.5 + 2.2 = 5.7")
    }

    func testGivenClearButton_WhenClearButtonPressed_ThenStringIsZero() {
        calculator.resetCalculation()
        XCTAssertEqual(calculator.stringToCalculate, "0")
    }

    func testGivenStringHasResult_WhenAddingNumber_ThenShouldClear() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        calculator.addNumber(with: "2")
        XCTAssertEqual(calculator.stringToCalculate, "2")
    }

    func testGivenResultShowing_WhenAddingDecimalPoint_ThenResetCalculation() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        calculator.addDecimalSeparator()
        XCTAssertEqual(calculator.stringToCalculate, "0")
    }

    func testGivenHasDecimalPoint_WhenAddingDecimalPoint_ThenNoChanges() {
        calculator.addNumber(with: "2")
        calculator.addDecimalSeparator()
        calculator.addDecimalSeparator()
        XCTAssertEqual(calculator.stringToCalculate, "2.")
    }

    // MARK: - Test when error
    func testGivenNumber_WhenNothingToAddTo_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 + ")
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAStringWithANumber_WhenNothingToSubstractWith_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " - ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 - ")
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAStringWithANumber_WhenNothingToMultiplyBy_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " x ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 x ")
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAStringWithANumber_WhenNothingToDivideBy_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " / ")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 / ")
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenStringHasNumber_WhenDivindingBy0_ThenShouldDisplayErrorAndResultEqual0() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " / ")
        calculator.addNumber(with: "0")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "2 / 0")
        XCTAssertEqual(calculator.error?.description, CountError.zeroDivision.description)
    }

    func testGivenStringHasNumber_WhenNoOperand_ThenShowError() {

        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenStringHasOperand_WhenAddingOperand_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addOperand(with: " + ")
        calculator.calculate()
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenResultIsShowing_WhenAddingOperand_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        calculator.addOperand(with: " + ")
        XCTAssertEqual(calculator.error?.description, CountError.resultAlreadyShowing.description)
    }

    func testGivenResultGiven_WhenTappingResultButton_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        calculator.calculate()
        XCTAssertEqual(calculator.error?.description, CountError.resultAlreadyShowing.description)
    }

    func testGivenOneNumberHas2DecimalSeparator_WhenTappingResultButton_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addDecimalSeparator()
        calculator.addNumber(with: "2")
        calculator.addDecimalSeparator()
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAnError_WhenErrorFailed_ThenStop() {
        calculator.error = nil
        XCTAssertNil(calculator.error)
    }

}
