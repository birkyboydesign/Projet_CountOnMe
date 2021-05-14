//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Birkyboy on 25/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTests: XCTestCase {

    var sut: Calculator!

    override func setUp() {
        super.setUp()
        sut = Calculator()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Test with operand

    func testGivenNumber_WhenAddingNumber_thenCalculate() {
        // Given
        sut.addNumber(with: "2")
        // When
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        // Then
        let result = "2 + 2 = 4"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenNumber_WhenSubstractingNumber_ThenCalculate() {
        sut.addNumber(with: "3")
        sut.addOperand(with: " - ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        let result = "3 - 2 = 1"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenNumber_WhenMultiplyNumber_ThenCalculate() {
        sut.addNumber(with: "3")
        sut.addOperand(with: " x ")
        sut.addNumber(with: "3")
        sut.calculationRequest()
        let result = "3 x 3 = 9"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenNumber_WhenDividingNumber_ThenCalculate() {
        sut.addNumber(with: "4")
        sut.addOperand(with: " ÷ ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        let result = "4 ÷ 2 = 2"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenNumber_WhenCalulatingWithSeveralNumbersAndOperands_ThenShowResult() {
        sut.addNumber(with: "4")
        sut.addOperand(with: " ÷ ")
        sut.addNumber(with: "2")
        sut.addOperand(with: " x ")
        sut.addNumber(with: "3")
        sut.addOperand(with: " - ")
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        let result = "4 ÷ 2 x 3 - 2 + 2 = 6"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenStringHasDecimalNumber_WhenAddingNumber_ThenShowDecimalNumberResult() {
        sut.addNumber(with: "3")
        sut.addDecimalSeparator()
        sut.addNumber(with: "5")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        let result = "3.5 + 2 = 5.5"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenDecimalNumber_WhenAddingDecimalAndNumber_ThenShowDecimalNumberResult() {
        sut.addNumber(with: "3")
        sut.addDecimalSeparator()
        sut.addNumber(with: "5")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.addDecimalSeparator()
        sut.addNumber(with: "2")
        sut.calculationRequest()
        let result = "3.5 + 2.2 = 5.7"
        XCTAssertEqual(sut.stringToCalculate, result)
    }

    func testGivenResultShowing_WhenClearButtonPressed_ThenStringIsZero() {
        sut.stringToCalculate = "2 + 2 = 4"
        sut.resetCalculation()
        XCTAssertEqual(sut.stringToCalculate, "0")
    }

    func testGivenStringHasResult_WhenAddingNumber_ThenShouldClear() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        sut.addNumber(with: "2")
        XCTAssertEqual(sut.stringToCalculate, "2")
    }

    func testGivenResultShowing_WhenAddingDecimalPoint_ThenResetCalculation() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        sut.addDecimalSeparator()
        XCTAssertEqual(sut.stringToCalculate, "0")
    }

    func testGivenHasDecimalPoint_WhenAddingDecimalPoint_ThenNoChanges() {
        sut.addNumber(with: "2")
        sut.addDecimalSeparator()
        sut.addDecimalSeparator()
        XCTAssertEqual(sut.stringToCalculate, "2.")
    }

    // MARK: - Test when error

    func testGivenNoNumberEntered_WhenAddingOperand_ThenShowError() {
        sut.addOperand(with: " - ")
        XCTAssertEqual(sut.error?.description, CountError.firstIsOperand.description)
    }

    func testGivenNumber_WhenMultiplyWithBigNumber_ThenShowInfiniteError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " x ")
        sut.addNumber(with: "88888888888888888888888888888888888888888888888888")
        sut.calculationRequest()
        XCTAssertEqual(sut.error?.description, CountError.infiniteResult.description)
    }

    func testGivenNumber_WhenNothingToAddTo_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.calculationRequest()
        XCTAssertEqual(sut.stringToCalculate, "2 + ")
        XCTAssertEqual(sut.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAStringWithANumber_WhenNothingToSubstractWith_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " - ")
        sut.calculationRequest()
        XCTAssertEqual(sut.stringToCalculate, "2 - ")
        XCTAssertEqual(sut.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAStringWithANumber_WhenNothingToMultiplyBy_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " x ")
        sut.calculationRequest()
        XCTAssertEqual(sut.stringToCalculate, "2 x ")
        XCTAssertEqual(sut.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAStringWithANumber_WhenNothingToDivideBy_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " ÷ ")
        sut.calculationRequest()
        XCTAssertEqual(sut.stringToCalculate, "2 ÷ ")
        XCTAssertEqual(sut.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenStringHasNumber_WhenDivindingBy0_ThenShouldDisplayErrorAndResultEqual0() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " ÷ ")
        sut.addNumber(with: "0")
        sut.calculationRequest()
        XCTAssertEqual(sut.stringToCalculate, "2 ÷ 0")
        XCTAssertEqual(sut.error?.description, CountError.zeroDivision.description)
    }

    func testGivenStringHasNumber_WhenNoOperand_ThenShowError() {
        sut.addNumber(with: "2")
        sut.calculationRequest()
        XCTAssertEqual(sut.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenStringHasOperand_WhenAddingOperand_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addOperand(with: " + ")
        XCTAssertEqual(sut.error?.description, CountError.operandAlreadySet.description)
    }

    func testGivenResultIsShowing_WhenAddingOperand_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        sut.addOperand(with: " + ")
        XCTAssertEqual(sut.error?.description, CountError.resultAlreadyShowing.description)
    }

    func testGivenResultGiven_WhenTappingResultButton_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        sut.calculationRequest()
        XCTAssertEqual(sut.error?.description, CountError.resultAlreadyShowing.description)
    }

    func testGivenOneNumberHas2DecimalSeparator_WhenTappingResultButton_ThenShowError() {
        sut.addNumber(with: "2")
        sut.addDecimalSeparator()
        sut.addNumber(with: "2")
        sut.addDecimalSeparator()
        sut.addNumber(with: "2")
        sut.addOperand(with: " + ")
        sut.addNumber(with: "2")
        sut.calculationRequest()
        XCTAssertEqual(sut.error?.description, CountError.incorrectExpression.description)
    }

    func testGivenAnError_WhenErrorFailed_ThenStop() {
        sut.error = nil
        XCTAssertNil(sut.error)
    }

}
