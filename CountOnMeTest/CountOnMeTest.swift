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

    // MARK: - Test with operand

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

    func testGivenStringHasNumber_WhenAddingDecimalAndNumber_ThenShowDecimalNumberResult() {
        calculator.addNumber(with: "3")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "5")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3.5 + 2 = 5.5")
    }

    func testGivenStringHasDecimalNumber_WhenAddingDecimalAndNumber_ThenShowDecimalNumberResult() {
        calculator.addNumber(with: "3")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "5")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "5")
        calculator.calculate()
        XCTAssertEqual(calculator.stringToCalculate, "3.5 + 2.5 = 6")
    }

    // MARK: - Test without result

    func testGivenEmptyString_WhenAddingNumber_ThenDisplayString() {
        calculator.addNumber(with: "2")
        XCTAssertEqual(calculator.stringToCalculate, "2")
    }

    func testGivenString_WhenAddingOperand_ThenDisplayString() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        XCTAssertEqual(calculator.stringToCalculate, "2 + ")
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
        calculator.addDecimalPoint()
        XCTAssertEqual(calculator.stringToCalculate, "0")
    }

    func testGivenHasDecimalPoint_WhenAddingDecimalPoint_ThenNoChanges() {
        calculator.addNumber(with: "2")
        calculator.addDecimalPoint()
        calculator.addDecimalPoint()
        XCTAssertEqual(calculator.stringToCalculate, "2.")
    }

    // MARK: - Test when error

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

    func testGivenResultIsShowing_WhenAddingOperand_ThenDisplayError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        calculator.addOperand(with: " + ")
        XCTAssertEqual(calculator.error, CountError.resultAlreadyShowing)
    }

    func testGivenResultGiven_WhenTappingResultButton_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        calculator.calculate()
        XCTAssertEqual(calculator.error, CountError.resultAlreadyShowing)
    }

    func testGivenOneNumberHas2DecimalSeparator_WhenTappingResultButton_ThenShowError() {
        calculator.addNumber(with: "2")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "2")
        calculator.addDecimalPoint()
        calculator.addNumber(with: "2")
        calculator.addOperand(with: " + ")
        calculator.addNumber(with: "2")
        calculator.calculate()
        XCTAssertEqual(calculator.error, CountError.incorrectExpression)
    }

    func testGivenAnError_WhenErrorFailed_ThenStop() {
        calculator.error = nil
        XCTAssertNil(calculator.error)
    }

    func testGivenAnError_WhenDividingByZero_ThenGiveError() {
        calculator.error = .zeroDivision
        XCTAssertEqual(CountError.zeroDivision.description,
                       "Division par zéro impossible !")
    }

    func testGivenAnError_WhenOperandSet_ThenGiveError() {
        calculator.error = .operandAlreadySet
        XCTAssertEqual(CountError.operandAlreadySet.description,
                       "Un operateur est déja mis !")
    }

    func testGivenAnError_WhenIncorrectExpression_ThenGiveError() {
        calculator.error = .incorrectExpression
        XCTAssertEqual(CountError.incorrectExpression.description,
                       "Entrez une expression correcte !")
    }

    func testGivenAnError_WhenResultAlreadyShowing_ThenGiveError() {
        calculator.error = .resultAlreadyShowing
        XCTAssertEqual(CountError.resultAlreadyShowing.description,
                       "Le resultat est déja affiché !")
    }

    func testGivenAnError_WhenStartNewCalculation_ThenGiveError() {
        calculator.error = .startNewCalculation
        XCTAssertEqual(CountError.startNewCalculation.description,
                       "Démarrez un nouveau calcul !")
    }
}
