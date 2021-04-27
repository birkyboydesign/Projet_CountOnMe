//
//  Calculator.swift
//  CountOnMe
//
//  Created by Birkyboy on 21/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import SwiftUI

protocol CalculatorDelegate: AnyObject {
    func presentAlert(with error: CountError)
    func displayResult(with result: String)
}

enum Operand: String {
    case add       = "+"
    case multiply  = "x"
    case divide    = "/"
    case substract = "-"
    case equal     = "="
}

class Calculator {

    // MARK: - Properties

    weak var delegate: CalculatorDelegate?
    private let zeroValue = "0"
    private let decimalSeparator = "."

    /// String where elements are added and the n displayed.
    var stringToCalculate = "" {
        didSet {
            delegate?.displayResult(with: stringToCalculate)
        }
    }

    var error: CountError? {
        didSet {
            guard let error = error else {return}
            delegate?.presentAlert(with: error)
        }
    }

    /// Split a string into parts and appened to  elements array.
    private var elements: [String] {
        return stringToCalculate.split(separator: " ").map { "\($0)" }
    }

    // MARK: - Checks

    /// Checks if the last elements is not an operand then the expression is ready for calculation
    private var expressionIsCorrect: Bool {
        return elements.last != Operand.add.rawValue &&
            elements.last != Operand.substract.rawValue &&
            elements.last != Operand.multiply.rawValue &&
            elements.last != Operand.divide.rawValue
    }

    /// Checks if the elements array contain more than 3 indexes.
    /// If there are more than 3 elements, a calculation est permissible.
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /// Check If the last element is not an operand, then true can add and operand.
    private var canAddOperator: Bool {
        return elements.last != Operand.add.rawValue &&
            elements.last != Operand.substract.rawValue &&
            elements.last != Operand.multiply.rawValue &&
            elements.last != Operand.divide.rawValue
    }

    /// Check If the first index of the elements to calculate is not an equal sign, then there is no result.
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: Operand.equal.rawValue) != nil
    }

    /// Checks if the string to be calculated contains only a zero.
    /// Usually the case when app is first launched or the reset button has been tapped.
    private var expressionIsZero: Bool {
        return elements.firstIndex(of: zeroValue) != nil
    }

    /// Checks if the string to be calculated contains a divider operand followed by a zero.
    private var isZeroDivision: Bool {
        if let index = elements.firstIndex(of: Operand.divide.rawValue) {
            if elements[index + 1] == zeroValue {
                return true
            }
        }
        return false
    }

    // MARK: Decimal seprator checks

    /// Checks if a decimal separator is already set for the last number entered
    private var decimalSeparatorAlreadySet: Bool {
        return stringToCalculate.last == "."
    }

    /// Checks if one of the numbers has a two decimal separator
    private var numberAlreadyHasDecimalSeparator: Bool {
        for index in 0..<elements.count {
            return elements[index].numberOfOccurrences(".") > 1
        }
        return false
    }
    // MARK: - Reset

    /// Reset calculation.
    func resetCalculation() {
        stringToCalculate = zeroValue
    }

    // MARK: - Add Data

    /// Add number to the string to calculate.
    /// - Parameter number: String value passsed from number button.
    func addNumber(with number: String) {
        if expressionHaveResult {
            resetCalculation()
        }
        if expressionIsZero {
            stringToCalculate = ""
        }
        stringToCalculate.append(number)
    }

    /// Add operand to string to calculate.
    /// - Parameter operand: Title string value of the operand button pressed.
    func addOperand(with operand: String) {
        guard expressionHaveResult == false else {
            error = .resultAlreadyShowing
            return
        }
        guard canAddOperator else {
            error = .operandAlreadySet
            return
        }
        stringToCalculate.append(operand)
    }

    /// Add a decimal point to string.
    func addDecimalSeparator() {
        guard expressionHaveResult == false else {
            resetCalculation()
            return
        }
        guard decimalSeparatorAlreadySet == false else {
            return
        }
        stringToCalculate.append(decimalSeparator)
    }


    // MARK: - Calculations

    func calculate() {
        guard numberAlreadyHasDecimalSeparator == false else {
            error = .incorrectExpression
            return
        }
        if expressionHaveResult {
            error = .resultAlreadyShowing
            return
        }
        guard expressionIsCorrect else {
            error = .incorrectExpression
            return
        }
        guard expressionHaveEnoughElement else {
            error = .incorrectExpression
            return
        }
        guard !isZeroDivision else {
            error = .zeroDivision
            resetCalculation()
            return
        }
        let result = calculateOperation(with: elements)
        if let resultToFloat = Float(result) {
            let formattedResult = resultToFloat.formatResult()
            stringToCalculate.append(" = \(formattedResult)")
        }
    }

    private func calculateOperation(with operationsToReduce: [String]) -> String {
        // Iterate over operations while an operand still here
        var operationsToReduce = operationsToReduce
        while operationsToReduce.count > 1 {

            let operand = operationsToReduce[1]
            if let left = Float(operationsToReduce[0]),
               let right = Float(operationsToReduce[2]) {
                let result: Float
                switch operand {
                case Operand.add.rawValue      : result = left + right
                case Operand.substract.rawValue: result = left - right
                case Operand.multiply.rawValue : result = left * right
                case Operand.divide.rawValue   : result = left / right
                default: result = 0.0
                }
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
            }
        }
        guard let operation = operationsToReduce.first else {
            return zeroValue
        }
        return operation
    }

}

